//
//  HTBatteryStats.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTUtility.h>
#import <HTCommon/NSDictionary+Extension.h>
#import "HTBatteryStats.h"

NSString * const percentageKey = @"percentage";
NSString * const statusKey = @"status";
NSString * const powerSaverKey = @"power_saver";

@interface HTBatteryStats ()

@property (nonatomic, strong, readwrite) NSNumber *percentage;
@property (nonatomic, copy, readwrite) NSString *status;
@property (nonatomic, strong, readwrite) NSNumber *powerSaver;

@end

@implementation HTBatteryStats

+ (HTBatteryStats *)currentBatteryStats {
    HTBatteryStats *batteryStats = [[HTBatteryStats alloc] init];
    
    batteryStats.percentage = [self batteryPercentage];
    batteryStats.status = [self batteryStatus];
    batteryStats.powerSaver = [NSNumber numberWithBool:[[NSProcessInfo processInfo] isLowPowerModeEnabled]];
    
    return batteryStats;
}

+ (NSNumber *)batteryPercentage {
    return [[NSNumber alloc] initWithFloat:[HTUtility batteryLevel]];
}

+ (NSString *)batteryStatus {
    UIDeviceBatteryState state = [HTUtility batteryState];
    NSString *batteryStatus;
    
    switch (state) {
        case UIDeviceBatteryStateFull:
            batteryStatus = @"FULL";
            break;
            
        case UIDeviceBatteryStateCharging:
            batteryStatus = @"CHARGING";
            break;
            
        case UIDeviceBatteryStateUnplugged:
            batteryStatus = @"DISCHARGING";
            break;
            
        default:
            batteryStatus = @"UNKNOWN";
            break;
    }
    
    return batteryStatus;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params ht_setNilSafeObject:self.percentage forKey:percentageKey];
    [params ht_setNilSafeObject:self.status forKey:statusKey];
    [params ht_setNilSafeObject:self.powerSaver forKey:powerSaverKey];
    
    return params;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.percentage = [aDecoder decodeObjectForKey:percentageKey];
        self.status = [aDecoder decodeObjectForKey:statusKey];
        self.powerSaver = [aDecoder decodeObjectForKey:powerSaverKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.percentage forKey:percentageKey];
    [aCoder encodeObject:self.status forKey:statusKey];
    [aCoder encodeObject:self.powerSaver forKey:powerSaverKey];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    HTBatteryStats *stats = [[HTBatteryStats alloc] init];
    
    stats.percentage = [self.percentage copyWithZone:zone];
    stats.status = [self.status copyWithZone:zone];
    stats.powerSaver = [self.powerSaver copyWithZone:zone];
    
    return stats;
}

- (HTBatteryStats *)statsFromSubtractingStats:(HTBatteryStats *)batteryStats {
    if (!batteryStats) {
        return [self copy];
    }
    
    if ([self isEqualToBatteryStats:batteryStats]) {
        return nil;
    }
    
    HTBatteryStats *diff = [[HTBatteryStats alloc] init];
    
    if (![self.percentage isEqualToNumber:batteryStats.percentage]) {
        diff.percentage = self.percentage;
    }
    
    if (![self.status isEqualToString:batteryStats.status]) {
        diff.status = self.status;
    }
    
    if (![self.powerSaver isEqualToNumber:batteryStats.powerSaver]) {
        diff.powerSaver = self.powerSaver;
    }
    
    return diff;
}

#pragma mark - Equality

- (BOOL)isEqualToBatteryStats:(HTBatteryStats *)stats {
    if (!stats) {
        return NO;
    }
    
    BOOL haveEqualPercentage = (!self.percentage && !stats.percentage) || [self.percentage isEqualToNumber:stats.percentage];
    BOOL haveEqualStatus = (!self.status && !stats.status) || [self.status isEqualToString:stats.status];
    BOOL haveEqualPowerSaver = (!self.powerSaver && !stats.powerSaver) || [self.powerSaver isEqualToNumber:stats.powerSaver];
    
    return haveEqualPercentage && haveEqualStatus && haveEqualPowerSaver;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[HTBatteryStats class]]) {
        return NO;
    }
    
    return [self isEqualToBatteryStats:(HTBatteryStats *)object];
}

- (NSUInteger)hash {
    return self.percentage.hash ^ self.status.hash ^ self.powerSaver.hash;
}

@end
