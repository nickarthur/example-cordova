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
static NSString * const isLiveKey = @"is_live";
static NSString * const intialETAKey = @"initial_eta";
static NSString * const etaKey = @"eta";
static NSString * const distanceKey = @"distance";
static NSString * const encodedPolylineKey = @"encoded_polyline";
static NSString * const startLocationKey = @"start_location";
static NSString * const endLocationKey = @"end_location";
static NSString * const startedAtKey = @"started_at";
static NSString * const endedAtKey = @"ended_at";
static NSString * const tasksKey = @"tasks";
static NSString * const vehicleTypeKey = @"vehicle_type";

@interface HTTrip ()

@property (copy, nonatomic, readwrite) NSString *tripID;
@property (copy, nonatomic, readwrite) NSString *driverID;
@property (strong, nonatomic, readwrite, nullable) NSNumber *isLive;
@property (strong, nonatomic, readwrite, nullable) NSDate *initialETA;
@property (strong, nonatomic, readwrite, nullable) NSDate *ETA;
@property (strong, nonatomic, readwrite, nullable) NSNumber *distance;
@property (strong, nonatomic, readwrite, nullable) NSString *encodedPolyline;
@property (strong, nonatomic, readwrite, nullable) HTLocation *startLocation;
@property (strong, nonatomic, readwrite, nullable) HTLocation *endLocation;
@property (strong, nonatomic, readwrite, nullable) NSDate *startedAt;
@property (strong, nonatomic, readwrite, nullable) NSDate *endedAt;
@property (strong, nonatomic, readwrite, nullable) NSArray<NSString *> *taskIDs;
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
    self.isLive = objc_dynamic_cast(NSNumber, responseObject[isLiveKey]);
    self.initialETA = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[intialETAKey])];
    self.ETA = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[etaKey])];
    self.distance = objc_dynamic_cast(NSNumber, responseObject[distanceKey]);
    self.encodedPolyline = objc_dynamic_cast(NSString, responseObject[encodedPolylineKey]);
    self.startLocation = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[startLocationKey])];
    self.endLocation = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[endLocationKey])];
    self.startedAt = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[startedAtKey])];
    self.endedAt = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[endedAtKey])];
    self.taskIDs = objc_dynamic_cast(NSArray <NSString *>, responseObject[tasksKey]);
    self.vehicleType = [HTVehicleType vehicleTypeForStringValue:objc_dynamic_cast(NSString, responseObject[vehicleTypeKey])];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Trip ID : %@, Driver : %@", self.tripID, self.driverID];
}

- (NSNumber *)duration {
    if (self.isLive.boolValue) {
        return nil;
    }
    
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

@end
