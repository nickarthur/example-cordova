//
//  HTDriverStats.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTBatteryStats;
@class HTRadioStats;
@class HTLocationStats;
@class HTDeviceStats;
@class HTReachability;

@interface HTDriverStats : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong, readonly) HTBatteryStats *battery;
@property (nonatomic, strong, readonly) HTRadioStats *radio;
@property (nonatomic, strong, readonly) HTLocationStats *location;
@property (nonatomic, strong, readonly) HTDeviceStats *device;
@property (nonatomic, strong, readonly) NSDate *recordedAt;
@property (nonatomic, copy, readonly) NSString *driverID;

+ (HTDriverStats *)currentDriverStatsForDriverID:(NSString *)driverID reachability:(HTReachability *)reachability;

@property (nonatomic, readonly) NSDictionary *dictionaryValue;

- (HTDriverStats *)statsFromSubtractingStats:(HTDriverStats *)driverStats;

@end
