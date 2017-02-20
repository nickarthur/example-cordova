//
//  HTShift.m
//  HTTransmitter
//
//  Created by Piyush on 26/11/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTCommon.h>

#import "HTShift.h"

static NSString * const shiftIDKey = @"id";
static NSString * const driverIDKey = @"driver_id";
static NSString * const startLocationKey = @"start_location";
static NSString * const endLocationKey = @"end_location";
static NSString * const startedAtKey = @"started_at";
static NSString * const endedAtKey = @"ended_at";

@interface HTShift ()

@property (copy, nonatomic, readwrite) NSString *shiftID;
@property (copy, nonatomic, readwrite) NSString *driverID;
@property (strong, nonatomic, readwrite, nullable) HTLocation *startLocation;
@property (strong, nonatomic, readwrite, nullable) HTLocation *endLocation;
@property (strong, nonatomic, readwrite, nullable) NSDate *startedAt;
@property (strong, nonatomic, readwrite, nullable) NSDate *endedAt;

@end

@implementation HTShift

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
    
    self.shiftID = objc_dynamic_cast(NSString, responseObject[shiftIDKey]);
    self.driverID = objc_dynamic_cast(NSString, responseObject[driverIDKey]);
    self.startLocation = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[startLocationKey])];
    self.endLocation = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[endLocationKey])];
    self.startedAt = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[startedAtKey])];
    self.endedAt = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[endedAtKey])];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Shift ID : %@, Driver : %@", self.shiftID, self.driverID];
}

- (NSNumber *)duration {
    if (!self.endedAt && !self.startedAt) {
        return nil;
    }
    
    return @([self.endedAt timeIntervalSinceDate:self.startedAt]);
}

- (NSNumber *)durationInMinutes {
    return @(ceilf(self.duration.floatValue /60.f));
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary ht_setNilSafeObject:self.shiftID forKey:shiftIDKey];
    [dictionary ht_setNilSafeObject:self.driverID forKey:driverIDKey];
    [dictionary ht_setNilSafeObject:self.startLocation.dictionaryValue forKey:startLocationKey];
    [dictionary ht_setNilSafeObject:self.endLocation.dictionaryValue forKey:endLocationKey];
    [dictionary ht_setNilSafeObject:self.startedAt.ht_stringValue forKey:startedAtKey];
    [dictionary ht_setNilSafeObject:self.endedAt.ht_stringValue forKey:endedAtKey];
    
    return dictionary;
}

@end
