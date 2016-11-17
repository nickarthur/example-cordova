//
//  HTTaskParams.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 13/07/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTLocation.h>

#import "HTTaskParams.h"

static NSString * const coderDriverIDKey = @"driver_id";
static NSString * const coderVehicleTypeKey = @"vehicle_type";
static NSString * const codertaskIDKey = @"task_id";

@implementation HTTaskParams

- (NSDictionary *)dictionaryValue {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (self.driverID) {
        [params setObject:self.driverID forKey:@"driver_id"];
    }
    
    if (self.vehicleType > HTDriverVehicleTypeDefault) {
        [params ht_setNilSafeObject:[HTVehicleType stringValueForVehicleType:self.vehicleType] forKey:@"vehicle_type"];
    }
    
    return params;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Driver ID: %@", self.driverID];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.driverID = [aDecoder decodeObjectForKey:coderDriverIDKey];
        self.taskID = [aDecoder decodeObjectForKey:codertaskIDKey];
        self.vehicleType = [aDecoder decodeIntegerForKey:coderVehicleTypeKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.driverID forKey:coderDriverIDKey];
    [aCoder encodeObject:self.taskID forKey:codertaskIDKey];
    [aCoder encodeInteger:self.vehicleType forKey:coderVehicleTypeKey];
}

@end
