//
//  HTDriverStatsCollector.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTDriverStats;
@class HTReachability;

@interface HTDriverStatsCollector : NSObject

@property (nonatomic, strong, readonly) NSArray <HTDriverStats *> *driverStats;

- (void)startCollectingStatsForDriverID:(NSString *)driverID timeInterval:(NSTimeInterval)timeInterval reachability:(HTReachability *)reachability;
- (void)updateTimeInterval:(NSTimeInterval)timeInterval;
- (void)stopCollectingStats;

- (NSArray <HTDriverStats *> *)flushDriverStats;
- (void)addStats:(NSArray <HTDriverStats *> *)driverStats;
- (NSArray <NSDictionary *> *)paramsForDriverStats:(NSArray <HTDriverStats *> *)driverStats;

@end
