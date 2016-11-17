//
//  HTShiftParams.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 11/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/NSDictionary+Extension.h>
#import "HTShiftParams.h"

static NSString * const coderDriverIDKey = @"driver_id";

@implementation HTShiftParams

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params ht_setNilSafeObject:self.driverID forKey:@"driver_id"];
    
    return params;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Driver ID: %@", self.driverID];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.driverID = [aDecoder decodeObjectForKey:coderDriverIDKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.driverID forKey:coderDriverIDKey];
}

@end
