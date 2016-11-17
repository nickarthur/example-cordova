//
//  HTMQTTSubscription.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 06/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTMQTTSubscriptionIDGenerator.h"

#import "HTMQTTSubscription.h"

@interface HTMQTTSubscription ()

@property (nonatomic, readwrite, assign) HTMQTTSubscriptionID subscriptionID;
@property (nonatomic, readwrite, copy) NSString *topic;
@property (nonatomic, readwrite, copy) HTSocketMessageBlock messageHandler;
@property (nonatomic, readwrite, copy) HTErrorBlock subscriptionHandler;

@end

@implementation HTMQTTSubscription

- (instancetype)init {
    return [self initWithTopic:nil messageHandler:nil subscriptionHandler:nil];
}

- (instancetype)initWithTopic:(NSString *)topic messageHandler:(HTSocketMessageBlock)messageHandler subscriptionHandler:(HTErrorBlock)subscriptionHandler {
    self = [super init];
    if (self) {
        self.subscriptionID = [HTMQTTSubscriptionIDGenerator getUniqueSubscriptionID];
        self.topic = topic;
        self.messageHandler = messageHandler;
        self.subscriptionHandler = subscriptionHandler;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    if (((HTMQTTSubscription *)object).subscriptionID == self.subscriptionID) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return [[NSString stringWithFormat:@"%ld", (long)self.subscriptionID] hash];
}

@end
