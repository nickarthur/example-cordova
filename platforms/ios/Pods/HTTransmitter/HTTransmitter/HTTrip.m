//
//  HTTrip.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 19/01/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTCommon.h>

#import "HTTrip.h"

static NSString * const tripIDKey = @"id";
static NSString * const driverIDKey = @"driver_id";
static NSString * const etaKey = @"eta";
static NSString * const statusKey = @"status";
static NSString * const connectionStatusKey = @"connection_status";
static NSString * const distanceKey = @"distance";
static NSString * const encodedPolylineKey = @"encoded_polyline";
static NSString * const timeAwarePolylineKey = @"time_aware_polyline";
static NSString * const startLocationKey = @"start_location";
static NSString * const endLocationKey = @"end_location";
static NSString * const startedAtKey = @"started_at";
static NSString * const endedAtKey = @"ended_at";
static NSString * const tasksKey = @"tasks";
static NSString * const hasOrderedTasksKey = @"has_ordered_tasks";
static NSString * const isAutoEndedKey = @"is_auto_ended";
static NSString * const vehicleTypeKey = @"vehicle_type";

@interface HTTrip ()

@property (copy, nonatomic, readwrite) NSString *tripID;
@property (copy, nonatomic, readwrite) NSString *driverID;
@property (strong, nonatomic, readwrite, nullable) NSDate *ETA;
@property (copy, nonatomic, readwrite, nullable) NSString *status;
@property (copy, nonatomic, readwrite, nullable) NSString *connectionStatus;
@property (strong, nonatomic, readwrite, nullable) NSNumber *distance;
@property (strong, nonatomic, readwrite, nullable) NSString *encodedPolyline;
@property (strong, nonatomic, readwrite, nullable) NSString *timeAwarePolyline;
@property (strong, nonatomic, readwrite, nullable) HTLocation *startLocation;
@property (strong, nonatomic, readwrite, nullable) HTLocation *endLocation;
@property (strong, nonatomic, readwrite, nullable) NSDate *startedAt;
@property (strong, nonatomic, readwrite, nullable) NSDate *endedAt;
@property (strong, nonatomic, readwrite, nullable) NSArray<NSString *> *taskIDs;
@property (strong, nonatomic, readwrite, nullable) NSNumber *hasOrderedTasks;
@property (strong, nonatomic, readwrite, nullable) NSNumber *isAutoEnded;
@property (nonatomic, readwrite) HTDriverVehicleType vehicleType;

@end

@implementation HTTrip

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
    
    self.tripID = objc_dynamic_cast(NSString, responseObject[tripIDKey]);
    self.driverID = objc_dynamic_cast(NSString, responseObject[driverIDKey]);
    self.ETA = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[etaKey])];
    self.status = objc_dynamic_cast(NSString, responseObject[statusKey]);
    self.connectionStatus = objc_dynamic_cast(NSString, responseObject[connectionStatusKey]);
    self.distance = objc_dynamic_cast(NSNumber, responseObject[distanceKey]);
    self.encodedPolyline = objc_dynamic_cast(NSString, responseObject[encodedPolylineKey]);
    self.timeAwarePolyline = objc_dynamic_cast(NSString, responseObject[timeAwarePolylineKey]);
    self.startLocation = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[startLocationKey])];
    self.endLocation = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[endLocationKey])];
    self.startedAt = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[startedAtKey])];
    self.endedAt = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[endedAtKey])];
    self.taskIDs = objc_dynamic_cast(NSArray <NSString *>, responseObject[tasksKey]);
    self.hasOrderedTasks = objc_dynamic_cast(NSNumber, responseObject[hasOrderedTasksKey]);
    self.isAutoEnded = objc_dynamic_cast(NSNumber, responseObject[isAutoEndedKey]);
    self.vehicleType = [HTVehicleType vehicleTypeForStringValue:objc_dynamic_cast(NSString, responseObject[vehicleTypeKey])];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Trip ID : %@, Driver : %@", self.tripID, self.driverID];
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

- (NSNumber *)distanceInKMs {
    return @(self.distance.floatValue / 1000);
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary ht_setNilSafeObject:self.tripID forKey:tripIDKey];
    [dictionary ht_setNilSafeObject:self.driverID forKey:driverIDKey];
    [dictionary ht_setNilSafeObject:self.ETA.ht_stringValue forKey:etaKey];
    [dictionary ht_setNilSafeObject:self.status forKey:statusKey];
    [dictionary ht_setNilSafeObject:self.connectionStatus forKey:connectionStatusKey];
    [dictionary ht_setNilSafeObject:self.distance forKey:distanceKey];
    [dictionary ht_setNilSafeObject:self.encodedPolyline forKey:encodedPolylineKey];
    [dictionary ht_setNilSafeObject:self.timeAwarePolyline forKey:timeAwarePolylineKey];
    [dictionary ht_setNilSafeObject:self.startLocation.dictionaryValue forKey:startLocationKey];
    [dictionary ht_setNilSafeObject:self.endLocation.dictionaryValue forKey:endLocationKey];
    [dictionary ht_setNilSafeObject:self.startedAt.ht_stringValue forKey:startedAtKey];
    [dictionary ht_setNilSafeObject:self.endedAt.ht_stringValue forKey:endedAtKey];
    [dictionary ht_setNilSafeObject:self.taskIDs forKey:tasksKey];
    [dictionary ht_setNilSafeObject:self.hasOrderedTasks forKey:hasOrderedTasksKey];
    [dictionary ht_setNilSafeObject:self.isAutoEnded forKey:isAutoEndedKey];
    [dictionary ht_setNilSafeObject:[HTVehicleType stringValueForVehicleType:self.vehicleType] forKey:vehicleTypeKey];
    
    return dictionary;
}

@end
