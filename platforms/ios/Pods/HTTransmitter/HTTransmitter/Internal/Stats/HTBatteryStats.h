//
//  HTBatteryStats.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTBatteryStats : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong, readonly) NSNumber *percentage;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, strong, readonly) NSNumber *powerSaver;

+ (HTBatteryStats *)currentBatteryStats;

@property (nonatomic, readonly) NSDictionary *dictionaryValue;

- (HTBatteryStats *)statsFromSubtractingStats:(HTBatteryStats *)batteryStats;
- (BOOL)isEqualToBatteryStats:(HTBatteryStats *)stats;

@end
