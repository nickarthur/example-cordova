//
//  HTTripParams.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 10/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import "HTTripParams.h"

static NSString * const coderDriverIDKey = @"driver_id";
static NSString * const coderTaskIDsKey = @"tasks";
static NSString * const coderVehicleTypeKey = @"vehicle_type";
static NSString * const coderHasOrderedTasksKey = @"has_ordered_tasks";
static NSString * const coderAutoEndKey = @"is_auto_ended";
static NSString * const coderTripIDKey = @"trip_id";

@implementation HTTripParams

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hasOrderedTasks = NO;
        self.autoEnd = YES;
    }
    
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params ht_setNilSafeObject:self.driverID forKey:@"driver_id"];
    
    if (self.taskIDs.count > 0) {
        [params ht_setNilSafeObject:self.taskIDs forKey:@"tasks"];
    }
    
    if (self.vehicleType > HTDriverVehicleTypeDefault) {
        [params ht_setNilSafeObject:[HTVehicleType stringValueForVehicleType:self.vehicleType] forKey:@"vehicle_type"];
    }
    
    [params ht_setNilSafeObject:self.tripID forKey:@"trip_id"];
    [params ht_setNilSafeObject:@(self.hasOrderedTasks) forKey:@"has_ordered_tasks"];
    [params ht_setNilSafeObject:@(self.autoEnd) forKey:@"is_auto_ended"];

    return params;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Driver ID: %@, Tasks: %@", self.driverID, self.taskIDs];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.driverID = [aDecoder decodeObjectForKey:coderDriverIDKey];
        self.taskIDs = [aDecoder decodeObjectForKey:coderTaskIDsKey];
        self.vehicleType = [aDecoder decodeIntegerForKey:coderVehicleTypeKey];
        self.hasOrderedTasks = [aDecoder decodeBoolForKey:coderHasOrderedTasksKey];
        self.autoEnd = [aDecoder decodeBoolForKey:coderAutoEndKey];
        self.tripID = [aDecoder decodeObjectForKey:coderTripIDKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.driverID forKey:coderDriverIDKey];
    [aCoder encodeObject:self.taskIDs forKey:coderTaskIDsKey];
    [aCoder encodeInteger:self.vehicleType forKey:coderVehicleTypeKey];
    [aCoder encodeBool:self.hasOrderedTasks forKey:coderHasOrderedTasksKey];
    [aCoder encodeBool:self.autoEnd forKey:coderAutoEndKey];
    [aCoder encodeObject:self.tripID forKey:coderTripIDKey];
}

@end
