//
//  HTGPSLog.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 12/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTUtility.h>
#import "NSDate+Extention.h"
#import "HTLocation.h"
#import "NSDictionary+Extension.h"

#import "HTGPSLog.h"

static NSString * const logIDKey = @"id";
static NSString * const recordedAtKey = @"recorded_at";
static NSString * const locationKey = @"location";
static NSString * const bearingKey = @"bearing";
static NSString * const speedKey = @"speed";
static NSString * const altitudeKey = @"altitude";
static NSString * const locationAccuracyKey = @"location_accuracy";

@interface HTGPSLog ()

@property (copy, nonatomic, readwrite, nullable) NSString *logID;
@property (strong, nonatomic, readwrite, nullable) NSDate *recordedAt;
@property (assign, nonatomic, readwrite) double bearing;
@property (assign, nonatomic, readwrite) double speed;
@property (assign, nonatomic, readwrite) double altitude;
@property (assign, nonatomic, readwrite) double locationAccuracy;
@property (strong, nonatomic, readwrite, nullable) HTLocation *location;

@end

@implementation HTGPSLog

- (instancetype)init {
    return [self initWithResponseObject:nil];
}

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject {
    self = [super init];
    if (self) {
        [self updateWithResponseObject:responseObject];
    }
    
    return self;
}

- (void)updateWithResponseObject:(NSDictionary *)responseObject {
    if (!responseObject
        || responseObject.count == 0) {
        return;
    }
    
    self.logID = objc_dynamic_cast(NSString, responseObject[logIDKey]);
    self.bearing = objc_dynamic_cast(NSNumber, responseObject[bearingKey]).doubleValue;
    self.speed = objc_dynamic_cast(NSNumber, responseObject[speedKey]).doubleValue;
    self.altitude = objc_dynamic_cast(NSNumber, responseObject[altitudeKey]).doubleValue;
    self.locationAccuracy = objc_dynamic_cast(NSNumber, responseObject[locationAccuracyKey]).doubleValue;
    self.recordedAt = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[recordedAtKey])];
    self.location = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[locationKey])];
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary ht_setNilSafeObject:self.logID forKey:logIDKey];
    [dictionary ht_setNilSafeObject:@(self.bearing) forKey:bearingKey];
    [dictionary ht_setNilSafeObject:@(self.speed) forKey:speedKey];
    [dictionary ht_setNilSafeObject:@(self.altitude) forKey:altitudeKey];
    [dictionary ht_setNilSafeObject:@(self.locationAccuracy) forKey:locationAccuracyKey];
    [dictionary ht_setNilSafeObject:self.recordedAt.ht_stringValue forKey:recordedAtKey];
    [dictionary ht_setNilSafeObject:self.location.dictionaryValue forKey:locationKey];
    
    return dictionary;
}

- (instancetype)initWithTimedLocation:(NSArray *)timedLocation {
    self = [self init];
    if (self) {
        [self updateWithTimedLocation:timedLocation];
    }
    
    return self;
}

- (void)updateWithTimedLocation:(NSArray *)timedLocation {
    if (!timedLocation || timedLocation.count == 0) {
        return;
    }
    
    NSNumber *latitude = (NSNumber *)timedLocation[0];
    NSNumber *longitude = (NSNumber *)timedLocation[1];
    self.location = [[HTLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)];
    
    NSDate *timeStamp = (NSDate *)timedLocation[2];
    self.recordedAt = timeStamp;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ID : %@, Bearing : %@, Recorded at : %@, location : %@", self.logID, @(self.bearing), self.recordedAt, self.location];
}

- (BOOL)isEqualToLog:(HTGPSLog *)log {
    if (self.location.location.coordinate.latitude == log.location.location.coordinate.latitude
        && self.location.location.coordinate.longitude == log.location.location.coordinate.longitude) {
        return YES;
    }
    
    if (!log) {
        return NO;
    }
    
    return [self.logID isEqualToString:log.logID];
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[HTGPSLog class]]) {
        return NO;
    }
    
    return [self isEqualToLog:object];
}

- (NSUInteger)hash {
    return [self.logID hash];
}

@end
