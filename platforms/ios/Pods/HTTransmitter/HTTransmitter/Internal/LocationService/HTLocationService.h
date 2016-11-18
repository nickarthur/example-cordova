//
//  HTLocationService.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 02/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTNetworkRequestManager;
@protocol HTLocationDataSourceProtocol;
@class HTJobScheduler;
@class HTReachability;

@interface HTLocationService : NSObject

@property (nonatomic, readonly) BOOL active;
@property (nonatomic, readonly) NSString *driverID;

- (instancetype)initWithLocationManager:(HTLocationManager *)locationManager
                             dataSource:(id<HTLocationDataSourceProtocol>)dataSource
                  networkRequestManager:(HTNetworkRequestManager *)networkRequestManager
                           reachability:(HTReachability *)reachability
                              scheduler:(HTJobScheduler *)jobScheduler
                                 logger:(id<HTLoggerProtocol>)logger;

- (void)startForDriverID:(NSString *)driverID;
- (BOOL)canStartServiceForDriverID:(NSString *)driverID;
- (void)updateSDKControls;
- (void)postLocations:(HTVoidBlock)block;
- (void)subscribeDriverID:(NSString *)driverID toSDKControlEventsWithCompletion:(HTErrorBlock)completion;

- (void)startServiceIfNeeded;

@end
