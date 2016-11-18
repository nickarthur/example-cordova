//
//  HTDriverStats.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/NSDictionary+Extension.h>
#import <HTCommon/NSDate+Extention.h>

#import "HTRadioStats.h"
#import "HTBatteryStats.h"
#import "HTLocationStats.h"
#import "HTDeviceStats.h"
#import "HTDriverStats.h"

NSString * const batteryKey = @"battery";
NSString * const radioKey = @"radio";
NSString * const locationKey = @"location";
NSString * const deviceKey = @"device";
NSString * const recordedAtKey = @"recorded_at";
NSString * const driverIDKey = @"driver_id";

@interface HTDriverStats ()

@property (nonatomic, strong, readwrite) HTBatteryStats *battery;
@property (nonatomic, strong, readwrite) HTRadioStats *radio;
@property (nonatomic, strong, readwrite) HTLocationStats *location;
@property (nonatomic, strong, readwrite) HTDeviceStats *device;
@property (nonatomic, strong, readwrite) NSDate *recordedAt;
@property (nonatomic, copy, readwrite) NSString *driverID;

@end

@implementation HTDriverStats

+ (HTDriverStats *)currentDriverStatsForDriverID:(NSString *)driverID reachability:(HTReachability *)reachability {
    HTDriverStats *driverStats = [[HTDriverStats alloc] init];
    driverStats.recordedAt = [NSDate date];
    driverStats.driverID = driverID;
    
    driverStats.battery = [HTBatteryStats currentBatteryStats];
    driverStats.radio = [HTRadioStats currentRadioStats:reachability];
    driverStats.location = [HTLocationStats currentLocationStats];
    driverStats.device = [HTDeviceStats currentDeviceStats];
    
    return driverStats;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params ht_setNilSafeObject:self.battery.dictionaryValue forKey:batteryKey];
    [params ht_setNilSafeObject:self.radio.dictionaryValue forKey:radioKey];
    [params ht_setNilSafeObject:self.location.dictionaryValue forKey:locationKey];
    [params ht_setNilSafeObject:self.device.dictionaryValue forKey:deviceKey];
    [params ht_setNilSafeObject:self.driverID forKey:driverIDKey];
    [params ht_setNilSafeObject:self.recordedAt.ht_stringValue forKey:recordedAtKey];
    
    return params;
}

- (HTDriverStats *)statsFromSubtractingStats:(HTDriverStats *)driverStats {
    if (!driverStats) {
        return [self copy];
    }
    
    if ([self isEqualToDriverStats:driverStats]) {
        return nil;
    }
    
    HTDriverStats *stats = [[HTDriverStats alloc] init];

    stats.driverID = self.driverID;
    stats.recordedAt = self.recordedAt;
    stats.battery = [self.battery statsFromSubtractingStats:driverStats.battery];
    stats.radio = [self.radio statsFromSubtractingStats:driverStats.radio];
    stats.location = [self.location statsFromSubtractingStats:driverStats.location];
    stats.device = [self.device statsFromSubtractingStats:driverStats.device];
    
    return stats;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.battery = [aDecoder decodeObjectForKey:batteryKey];
        self.radio = [aDecoder decodeObjectForKey:radioKey];
        self.location = [aDecoder decodeObjectForKey:locationKey];
        self.device = [aDecoder decodeObjectForKey:deviceKey];
        self.driverID = [aDecoder decodeObjectForKey:driverIDKey];
        self.recordedAt = [aDecoder decodeObjectForKey:recordedAtKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.battery forKey:batteryKey];
    [aCoder encodeObject:self.radio forKey:radioKey];
    [aCoder encodeObject:self.location forKey:locationKey];
    [aCoder encodeObject:self.device forKey:deviceKey];
    [aCoder encodeObject:self.driverID forKey:driverIDKey];
    [aCoder encodeObject:self.recordedAt forKey:recordedAtKey];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    HTDriverStats *driverStats = [[HTDriverStats alloc] init];
    
    driverStats.driverID = [self.driverID copyWithZone:zone];
    driverStats.recordedAt = [self.recordedAt copyWithZone:zone];
    driverStats.battery = [self.battery copyWithZone:zone];
    driverStats.radio = [self.radio copyWithZone:zone];
    driverStats.location = [self.location copyWithZone:zone];
    driverStats.device = [self.device copyWithZone:zone];
    
    return driverStats;
}

#pragma mark - Equality

- (BOOL)isEqualToDriverStats:(HTDriverStats *)stats {
    if (!stats) {
        return NO;
    }
    
    BOOL haveEqualDriverID = (!self.driverID && !stats.driverID) || [self.driverID isEqualToString:stats.driverID];
    BOOL haveEqualRecordedAt = (!self.recordedAt && !stats.recordedAt) || [self.recordedAt isEqualToDate:stats.recordedAt];
    BOOL haveEqualPowerBattery = (!self.battery && !stats.battery) || [self.battery isEqualToBatteryStats:stats.battery];
    BOOL haveEqualPowerRadio = (!self.radio && !stats.radio) || [self.radio isEqualToRadioStats:stats.radio];
    BOOL haveEqualPowerLocation = (!self.location && !stats.location) || [self.location isEqualToLocationStats:stats.location];
    BOOL haveEqualPowerDevice = (!self.device && !stats.device) || [self.device isEqualToDeviceStats:stats.device];
    
    return haveEqualDriverID && haveEqualRecordedAt && haveEqualPowerBattery && haveEqualPowerRadio && haveEqualPowerLocation && haveEqualPowerDevice;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[HTDriverStats class]]) {
        return NO;
    }
    
    return [self isEqualToDriverStats:(HTDriverStats *)object];
}

- (NSUInteger)hash {
    return self.driverID.hash ^ self.recordedAt.hash ^ self.battery.hash ^ self.radio.hash ^ self.location.hash ^ self.device.hash;
}

@end
