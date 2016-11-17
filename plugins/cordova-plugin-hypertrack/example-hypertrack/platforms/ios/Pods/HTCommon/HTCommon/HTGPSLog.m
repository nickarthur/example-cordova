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

#import "HTGPSLog.h"

static NSString * const logIDKey = @"id";
static NSString * const recordedAtKey = @"recorded_at";
static NSString * const locationKey = @"location";
static NSString * const bearingKey = @"bearing";
static NSString * const fetchNextPointsKey = @"fetch_next_points";
static NSString * const speedKey = @"speed";
static NSString * const altitudeKey = @"altitude";
static NSString * const locationAccuracyKey = @"location_accuracy";

@interface HTGPSLog ()

@property (copy, nonatomic, readwrite, nullable) NSString *logID;
@property (strong, nonatomic, readwrite, nullable) NSDate *recordedAt;
@property (strong, nonatomic, readwrite, nullable) NSString *recordedAtString;
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
    self.recordedAtString = objc_dynamic_cast(NSString, responseObject[recordedAtKey]);
    self.fetchNextPoints = objc_dynamic_cast(NSNumber, responseObject[fetchNextPointsKey]).boolValue;
    self.location = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[locationKey])];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ID : %@, Bearing : %@, Recorded at : %@, Fetch Next Points : %@, location : %@", self.logID, @(self.bearing), self.recordedAt, @(self.fetchNextPoints), self.location];
}

- (BOOL)isEqualToLog:(HTGPSLog *)log {
    
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
