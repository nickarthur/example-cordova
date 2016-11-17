//
//  HTTransmitterJobSchedulerListener.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 25/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTScheduler;
@class HTNetworkRequestManager;
@protocol HTLoggerProtocol;
@protocol HTGetLogDataSource;

@interface HTTransmitterJobSchedulerListener : NSObject

- (instancetype)initWithJobScheduler:(id<HTScheduler>)scheduler logger:(id<HTLoggerProtocol>)logger networkManager:(HTNetworkRequestManager *)requestManager logDatasource:(id<HTGetLogDataSource>)logDataSource;

@end
