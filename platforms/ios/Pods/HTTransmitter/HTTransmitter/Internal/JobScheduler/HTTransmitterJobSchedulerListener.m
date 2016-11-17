//
//  HTTransmitterJobSchedulerListener.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 25/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTWeakStrongMacros.h>
#import <HTCommon/HTLoggerProtocol.h>
#import <HTCommon/HTConstants.h>

#import "HTScheduler.h"
#import "HTNetworkRequestManager.h"
#import "HTJobProtocol.h"
#import "HTGetLogsDataSource.h"
#import "HTNetworkRequest.h"
#import "NSArray+HTExtension.h"

#import "HTTransmitterJobSchedulerListener.h"

static const NSUInteger LogBatchCount = 50;

@interface HTTransmitterJobSchedulerListener ()

@property (strong, nonatomic) id<HTScheduler> scheduler;
@property (strong, nonatomic) id<HTLoggerProtocol> logger;
@property (strong, nonatomic) HTNetworkRequestManager *requestManager;
@property (strong, nonatomic) id<HTGetLogDataSource> logDataSource;
@property (assign, nonatomic) HTJobID jobID;
@property (copy, nonatomic) HTNetworkRequestManagerStatusBlock listener;

@end

@implementation HTTransmitterJobSchedulerListener

- (instancetype)initWithJobScheduler:(id<HTScheduler>)scheduler logger:(id<HTLoggerProtocol>)logger networkManager:(HTNetworkRequestManager *)requestManager logDatasource:(id<HTGetLogDataSource>)logDataSource {
    self = [super init];
    if (self) {
        self.scheduler = scheduler;
        self.logger = logger;
        self.requestManager = requestManager;
        self.logDataSource = logDataSource;
        
        WEAK(self);
        self.listener = ^(HTNetworkRequestStatus status) {
            STRONG(self);
            [self didListenRequestStatus:status];
        };
        
        [self.requestManager addListener:self.listener];
        [self subscribeToScheduler];
    }
    
    return self;
}

- (void)dealloc {
    [self.requestManager removeListener:self.listener];
}

- (void)didListenRequestStatus:(HTNetworkRequestStatus)status {
//    [self.logger info:@"Did receive status: %@", @(status)];
//    
//    [self.requestManager cachedRequestsCount:^(NSInteger count, NSError *error) {
//        if (count > 0) {
//            [self subscribeToScheduler];
//        } else {
//            [self unsubscribeFromScheduler];
//        }
//    }];
}

- (void)subscribeToScheduler {
    self.jobID = [self.scheduler subscribe:^(id<HTJobProtocol> job) {
        [self didSchedulejob];
    }];
}

- (void)didSchedulejob {
    [self.logger info:@"Did schedule job for job scheduler listner"];
    
    [self.logDataSource logMessages:^(NSArray<NSString *> *logMessages, NSError *error) {
        [self processLogMessages:logMessages];
        [self.logDataSource deleteMessages:nil];
        [self.requestManager processCachedRequests];
    }];
}

- (void)processLogMessages:(NSArray <NSString *> *)logMessages {
    NSArray <NSArray <NSString *> *> *logBatches = [logMessages splitWithCount:LogBatchCount];
    for (NSArray <NSString *> *logBatch in logBatches) {
        [self addLogMessagesToRequestManager:logBatch];
    }
}

- (void)addLogMessagesToRequestManager:(NSArray <NSString *> *)logMessages {
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost APIString:@"api/v1/logs/" params:logMessages callback:nil];
    request.cached = YES;
    request.parallel = YES;
    request.hasTimeout = NO;
    request.type = HTNetworkRequestTypeMQTT;
    request.topic = [NSString stringWithFormat:@"DeviceLogs/%@", HT_IDENTIFIER_FOR_VENDOR];
    
    [self.requestManager addRequest:request block:nil];
}

- (void)unsubscribeFromScheduler {
    [self.scheduler complete:self.jobID];
}

@end
