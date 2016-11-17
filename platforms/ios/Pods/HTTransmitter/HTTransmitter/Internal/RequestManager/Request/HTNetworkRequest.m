//
//  HTBaseNetworkRequest.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 23/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTNetworkRequest.h"

static NSTimeInterval const timeoutInterval = 30;

static NSString * const coderParallelKey = @"parallel";
static NSString * const coderCachedKey = @"cached";
static NSString * const coderHasTimeoutKey = @"timeout";
static NSString * const coderMethodKey = @"method";
static NSString * const coderAPIStringKey = @"APIString";
static NSString * const coderParamsKey = @"params";
static NSString * const coderTopicKey = @"topic";
static NSString * const coderTypeKey = @"type";

@interface HTNetworkRequest ()

@property (nonatomic, assign, readwrite) HTNetworkRequestMethodType method;
@property (nonatomic, copy, readwrite) NSString *APIString;
@property (nonatomic, copy, readwrite) id params;
@property (nonatomic, copy, readwrite) HTNetworkResponseStatusBlock callback;
@property (nonatomic, copy, readwrite) HTNetworkResponseBlock messageHandler;

@property (nonatomic, strong) NSTimer *timeoutTimer;

@end

@implementation HTNetworkRequest

@synthesize requestID = _requestID;
@synthesize retryCount = _retryCount;

@synthesize delegate = _delegate;
@synthesize processed = _processed;
@synthesize retry = _retry;
@synthesize callback = _callback;
@synthesize responseOffline = _responseOffline;

@synthesize parallel = _parallel;
@synthesize cached = _cached;
@synthesize hasTimeout = _hasTimeout;
@synthesize method = _method;
@synthesize APIString = _APIString;
@synthesize params = _params;
@synthesize topic = _topic;
@synthesize type = _type;
@synthesize messageHandler = _messageHandler;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestID = -1;
        self.retryCount = -1;
    }
    
    return self;
}

- (instancetype)initWithMethodType:(HTNetworkRequestMethodType)method APIString:(NSString *)APIString params:(id)params callback:(HTNetworkResponseStatusBlock)callback {
    self = [self init];
    if (self) {
        self.method = method;
        self.APIString = APIString;
        self.params = params;
        self.callback = callback;
    }
    
    return self;
}

- (instancetype)initWithTopic:(NSString *)topic messageHandler:(HTNetworkResponseBlock)messageHandler callback:(HTNetworkResponseStatusBlock)callback {
    self = [self init];
    if (self) {
        self.topic = topic;
        self.messageHandler = messageHandler;
        self.callback = callback;
        self.method = HTNetworkRequestMethodTypeGet;
        self.cached = NO;
        self.hasTimeout = NO;
        self.parallel = NO;
        self.type = HTNetworkRequestTypeMQTT;
    }
    
    return self;
}

- (instancetype)initWithTopicToDelete:(NSString *)topic {
    self = [self init];
    if (self) {
        self.topic = topic;
        self.messageHandler = nil;
        self.callback = nil;
        self.method = HTNetworkRequestMethodTypeDelete;
        self.cached = NO;
        self.hasTimeout = NO;
        self.parallel = NO;
        self.type = HTNetworkRequestTypeMQTT;
    }
    
    return self;
}

- (void)startTimerForTimeOut {
    if (self.hasTimeout && !self.timeoutTimer) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeoutInterval target:self selector:@selector(timeoutTimerFired:) userInfo:nil repeats:NO];
        });
    }
}

- (void)dealloc {
    [self.timeoutTimer invalidate];
}

- (void)timeoutTimerFired:(NSTimer *)timer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(networkRequestTimedOut:)]) {
        [self.delegate networkRequestTimedOut:self];
    }
}

- (void)cancel {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
}

- (void)processCallbackForResponseObject:(id)responseObject status:(HTNetworkRequestStatus)status error:(NSError *)error {
    DispatchMainThread(self.callback, responseObject, status, error);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.parallel = [aDecoder decodeBoolForKey:coderParallelKey];
        self.cached = [aDecoder decodeBoolForKey:coderCachedKey];
        self.hasTimeout = [aDecoder decodeBoolForKey:coderHasTimeoutKey];
        self.method = [aDecoder decodeIntegerForKey:coderMethodKey];
        self.APIString = [aDecoder decodeObjectForKey:coderAPIStringKey];
        self.params = [aDecoder decodeObjectForKey:coderParamsKey];
        self.topic = [aDecoder decodeObjectForKey:coderTopicKey];
        self.type = [aDecoder decodeIntegerForKey:coderTypeKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.parallel forKey:coderParallelKey];
    [aCoder encodeBool:self.cached forKey:coderCachedKey];
    [aCoder encodeBool:self.hasTimeout forKey:coderHasTimeoutKey];
    [aCoder encodeInteger:self.method forKey:coderMethodKey];
    [aCoder encodeObject:self.APIString forKey:coderAPIStringKey];
    [aCoder encodeObject:self.params forKey:coderParamsKey];
    [aCoder encodeObject:self.topic forKey:coderTopicKey];
    [aCoder encodeInteger:self.type forKey:coderTypeKey];
}

@end
