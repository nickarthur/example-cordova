//
//  HTActiveDriver.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 08/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTActiveDriver.h"

static NSString * const coderDriverIDKey = @"driverID";
static NSString * const coderActiveKey = @"location";

@interface HTActiveDriver ()

@property (copy, nonatomic, readwrite) NSString *driverID;
@property (assign, nonatomic, readwrite) BOOL active;

@end

@implementation HTActiveDriver

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.driverID forKey:coderDriverIDKey];
    [aCoder encodeBool:self.active forKey:coderActiveKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.driverID = [aDecoder decodeObjectForKey:coderDriverIDKey];
        self.active = [aDecoder decodeBoolForKey:coderActiveKey];
    }
    
    return self;
}

+ (HTActiveDriver *)activeDriverWithDriverID:(NSString *)driverID {
    HTActiveDriver *driver = [[HTActiveDriver alloc] init];
    driver.driverID = driverID;
    driver.active = YES;
    return driver;
}

+ (HTActiveDriver *)inactiveDriverWithDriverID:(NSString *)driverID {
    HTActiveDriver *driver = [[HTActiveDriver alloc] init];
    driver.driverID = driverID;
    driver.active = NO;
    return driver;
}

@end
