//
//  HTMQTTClient.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 05/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <MQTTClient/MQTTClient.h>

#import <HTCommon/HyperTrack.h>
#import <HTCommon/HTBlocks.h>
#import <HTCommon/NSDictionary+Extension.h>
#import <HTCommon/NSDate+Extention.h>
#import <HTCommon/HTError.h>
#import <HTCommon/HTLoggerProtocol.h>
#import <HTCommon/HTConstants.h>
#import "HTReachability.h"

#import "HTMQTTSubscription.h"

#import "HTMQTTClient.h"

@interface HTMQTTClient () <MQTTSessionDelegate>

@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *userAgent;
@property (nonatomic, copy) NSString *host;

@property (nonatomic, strong) id <HTLoggerProtocol> logger;
@property (nonatomic, strong) HTReachability *reachability;
@property (nonatomic, strong) NSTimer *reconnectTimer;

@property (nonatomic, strong) MQTTSession *session;

@property (nonatomic, strong) NSDictionary <NSString *, HTMQTTSubscription *> *subscribers;
@property (nonatomic, strong) NSArray <HTMQTTSubscription *> *pendingSubscriptions;

@end

static const UInt16 MQTTKeepAliveInterval = 30;
static const NSTimeInterval ReconnectRetryInterval = 15.0f;

@interface NSError (HTMQTTClient)

+ (NSError *)badDataError;

@end

@implementation HTMQTTClient

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithHost:nil prefix:nil userAgent:nil logger:nil reachability:nil];
}

- (instancetype)initWithHost:(NSString *)host prefix:(NSString *)prefix userAgent:(NSString *)userAgent logger:(id<HTLoggerProtocol>)logger reachability:(HTReachability *)reachability {
    self = [super init];
    if (self) {
        self.prefix = prefix;
        self.userAgent = userAgent;
        self.host = host;
        
        self.logger = logger;
        self.reachability = reachability;
        [self registerToNotifications];
        
        self.subscribers = @{};
        self.pendingSubscriptions = @[];
        
        [self setupSession];
        [self connectSessionIfNeeded];
    }
    
    return self;
}

- (void)setupSession {
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = self.host;
    
    self.session = [[MQTTSession alloc] init];
    self.session.transport = transport;
    self.session.keepAliveInterval = MQTTKeepAliveInterval;
    self.session.willRetainFlag = NO;
    
    self.session.delegate = self;
}

#pragma mark - Pub Sub helper methods

- (NSString *)userAgentString {
    NSString *userAgent = [NSString stringWithFormat:@"HyperTrack (%@ %@) %@/v%@", HT_DEVICE_NAME, HT_SYSTEM_VERSION, self.userAgent, HTSDKVersion];
    
    return userAgent;
}

- (NSDictionary *)header {
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header ht_setNilSafeObject:@"application/json" forKey:@"Content-Type"];
    [header ht_setNilSafeObject:@"application/json" forKey:@"Accept"];
    [header ht_setNilSafeObject:[self userAgentString] forKey:@"User-Agent"];
    [header ht_setNilSafeObject:[NSDate date].ht_stringValue forKey:@"Device-Time"];
    
    if ([HyperTrack publishableKey]) {
        [header ht_setNilSafeObject:[NSString stringWithFormat:@"Token %@", [HyperTrack publishableKey]] forKey:@"Authorization"];
    }
    
    return header;
}

- (NSData *)publishableDataForParams:(id)params {
    NSMutableDictionary *publishableDictionary = [NSMutableDictionary dictionary];
    [publishableDictionary ht_setNilSafeObject:[self header] forKey:@"headers"];
    [publishableDictionary ht_setNilSafeObject:params forKey:@"body"];
    
    NSError *writingError = nil;
    return [NSJSONSerialization dataWithJSONObject:publishableDictionary
                                           options:0
                                             error:&writingError];

}

- (NSString *)prefixedTopic:(NSString *)topic {
    NSString *prefix = self.prefix != nil ? self.prefix : @"";
    return [NSString stringWithFormat:@"%@%@", prefix, topic];
}

#pragma mark - Pub Sub Methods

- (void)publishParams:(id)params onTopic:(NSString *)topic completion:(HTErrorBlock)completion {
    NSData *data = [self publishableDataForParams:params];
    if (data == nil) {
        [self.logger error:@"Publishable data is nil. Aborting"];
        InvokeBlock(completion, [NSError badDataError]);
        return;
    }
    
    NSString *prefixedTopic = [self prefixedTopic:topic];
    [self.session publishData:data
                      onTopic:prefixedTopic
                       retain:NO
                          qos:MQTTQosLevelAtMostOnce
               publishHandler:completion];
}

- (HTMQTTSubscriptionID)subscribeToTopic:(NSString *)topic messageHandler:(HTSocketMessageBlock)messageHandler subscriptionHandler:(HTErrorBlock)subscriptionHandler {
    HTMQTTSubscription *subscription = [[HTMQTTSubscription alloc] initWithTopic:[self prefixedTopic:topic]
                                                                  messageHandler:messageHandler
                                                             subscriptionHandler:subscriptionHandler];
    
    if (self.session.status != MQTTSessionStatusConnected) {
        [self.logger warn:@"MQTTSession not connected. Adding to pending subscription"];
        [self addPendingSubscription:subscription];
    } else {
        [self subscribe:subscription];
    }
    
    return subscription.subscriptionID;
}

- (void)subscribe:(HTMQTTSubscription *)subscription {
    [self.session subscribeToTopic:subscription.topic
                           atLevel:MQTTQosLevelAtLeastOnce
                  subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
                      
                      if (!error) {
                          [self.logger info:@"Added as subscriber"];
                          [self addSubscriber:subscription];
                      } else {
                          [self.logger error:@"Error in adding subscription. Error : %@", error.localizedDescription];
                      }
                      
                      if ([self.pendingSubscriptions containsObject:subscription]) {
                          [self removePendingSubscription:subscription];
                      }
                      
                      InvokeBlock(subscription.subscriptionHandler, error);
                  }];
}

- (void)unsubscribeFromTopic:(NSString *)topic {
    NSString *prefixedTopic = [self prefixedTopic:topic];
    HTMQTTSubscription *subscription = [self.subscribers valueForKey:prefixedTopic];
    
    [self.session unsubscribeTopic:prefixedTopic];
    [self removeSubscriber:subscription];
}

#pragma mark - Subscriber Management Methods

- (void)addSubscriber:(HTMQTTSubscription *)subscription {
    NSMutableDictionary *mutableSubscriber = [NSMutableDictionary dictionaryWithDictionary:self.subscribers];
    [mutableSubscriber ht_setNilSafeObject:subscription forKey:subscription.topic];
    self.subscribers = mutableSubscriber;
}

- (void)removeSubscriber:(HTMQTTSubscription *)subcription {
    if (!subcription) {
        return;
    }
    
    NSMutableDictionary *mutableSubscriber = [NSMutableDictionary dictionaryWithDictionary:self.subscribers];
    [mutableSubscriber removeObjectForKey:subcription.topic];
    self.subscribers = mutableSubscriber;
}

- (void)addPendingSubscription:(HTMQTTSubscription *)subscription {
    NSMutableArray *mutablePendingSubscriptions = [NSMutableArray arrayWithArray:self.pendingSubscriptions];
    [mutablePendingSubscriptions addObject:subscription];
    self.pendingSubscriptions = mutablePendingSubscriptions;
}

- (void)removePendingSubscription:(HTMQTTSubscription *)subscription {
    NSMutableArray *mutablePendingSubscriptions = [NSMutableArray arrayWithArray:self.pendingSubscriptions];
    [mutablePendingSubscriptions removeObject:subscription];
    self.pendingSubscriptions = mutablePendingSubscriptions;
}

- (void)addPendingSubscriptions:(NSArray <HTMQTTSubscription *> *)subscriptions {
    if (!subscriptions || subscriptions.count == 0) {
        return;
    }
    
    NSMutableArray *mutablePendingSubscriptions = [NSMutableArray arrayWithArray:self.pendingSubscriptions];
    [mutablePendingSubscriptions addObjectsFromArray:subscriptions];
    self.pendingSubscriptions = mutablePendingSubscriptions;
}

- (void)moveSubscribersToPending {
    [self addPendingSubscriptions:self.subscribers.allValues];
    self.subscribers = @{};
}

#pragma mark - Connection Methods

- (void)registerToNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (self.reachability.currentReachabilityStatus != NotReachable) {
                                                          [self.logger info:@"Reachability - Connection is available"];
                                                          [self stopReconnectTimer];
                                                          [self connectSessionIfNeeded];
                                                      } else {
                                                          [self.logger warn:@"Network not reachable"];
                                                      }
                                                  }];
}

- (void)connectSessionIfNeeded {
    if (self.connected
        || self.session.status == MQTTSessionStatusConnecting
        || self.reconnectTimer) {
        return;
    }
    
    [self connectSession];
}

- (void)connectSession {
    [self.session connectWithConnectHandler:^(NSError *error) {
        if (error) {
            [self.logger error:@"Connection to MQTT Broker couldn't be established. Error : %@", error.localizedDescription];
            [self startReconnectTimerIfNeeded];
        } else {
            [self.logger info:@"Connection to MQTT Broker is successful"];
            [self stopReconnectTimer];
        }
    }];
}

- (BOOL)connected {
    return self.session.status == MQTTSessionStatusConnected;
}

- (void)startReconnectTimerIfNeeded {
    if (self.reconnectTimer) {
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:ReconnectRetryInterval
                                                               target:self
                                                             selector:@selector(connectSession)
                                                             userInfo:nil
                                                              repeats:YES];
    });
}

- (void)stopReconnectTimer {
    [self.reconnectTimer invalidate];
    self.reconnectTimer = nil;
}

#pragma mark - MQTT Session delegate

- (void)connected:(MQTTSession *)session {
    [self.logger info:@"Session Connected"];
    
    if (self.pendingSubscriptions.count > 0) {
        [self.logger info:@"Pending subscriptions present."];
        
        for (HTMQTTSubscription *subscription in self.pendingSubscriptions) {
            [self subscribe:subscription];
        }
    }
}

- (void)connectionClosed:(MQTTSession *)session {
    [self.logger info:@"Session connection closed"];
}

- (void)connectionError:(MQTTSession *)session error:(NSError *)error {
    [self.logger error:@"Session connection error. Error : %@", error.localizedDescription];
    [self moveSubscribersToPending];
    [self connectSessionIfNeeded];
}

- (void)protocolError:(MQTTSession *)session error:(NSError *)error {
    [self.logger error:@"Session protocol error. Error : %@", error.localizedDescription];
}

- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    [self.logger info:@"New Message received on topic : %@", topic];
    HTMQTTSubscription *subscriber = [self.subscribers valueForKey:topic];
    
    if (subscriber == nil) {
        [self.logger error:@"No subscriber for the topic. Aborting."];
        return;
    }
    
    id responseObject = nil;
    NSError *jsonError = nil;
    if (data && data.length > 0) {
        responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    } else {
        jsonError = [NSError badDataError];
    }
    
    InvokeBlock(subscriber.messageHandler, responseObject, jsonError);
}

@end

@implementation NSError (HTMQTTClient)

+ (NSError *)badDataError {
    return [NSError ht_errorForType:HTConnectionError
                            message:@"MQTT payload error"
                          parameter:nil
                          errorCode:HTInvalidState
                    devErrorMessage:@"MQTT client bad data error in payload."];
}

@end
