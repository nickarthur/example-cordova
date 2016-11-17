//
//  HTTripLocationBatchManager.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 17/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTCommon.h>
#import <HTCommon/HTWeakStrongMacros.h>

#import "HTLocationDataSourceProtocol.h"
#import "HTLocationBatchManager.h"

@interface HTLocationBatchManager ()

@property (nonatomic, strong) id<HTLocationDataSourceProtocol> dataSource;
@property (nonatomic, copy) NSString *driverID;

@property (nonatomic, strong) HTLocation *lastAddedLocation;

@end

@implementation HTLocationBatchManager

- (instancetype)initWithDataStore:(id<HTLocationDataSourceProtocol>)dataSource {
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
    }
    
    return self;
}

- (void)resetWithDriverID:(NSString *)driverID{
    self.driverID = driverID;
    [self.dataSource resetLocationsWithBlock:nil];
}

- (void)clear {
    [self clearLocations];
    self.driverID = nil;
}

- (void)clearLocations {
    [self.dataSource deleteAllLocationsForDriverID:self.driverID block:nil];
}

- (void)addLocations:(NSArray <HTLocation *> *)locations block:(HTLocationAddBlock)block {
    if (locations == nil || locations.count == 0) {
        InvokeBlock(block, self, nil, nil);
        return;
    }
    
    WEAK(self);
    [self.dataSource addLocations:locations driverID:self.driverID block:^(NSError * _Nullable error) {
        STRONG(self);
        if (!error) {
            self.lastAddedLocation = locations.lastObject;
        }
        
        [self.dataSource locationsForDriverID:self.driverID block:^(NSArray<HTLocation *> *locations, NSError *error) {
            InvokeBlock(block, self, locations, error);
        }];
    }];
}

- (void)removeLocations {
    [self.dataSource deleteAllLocationsForDriverID:self.driverID block:nil];
}

- (void)flushCurrentLocations:(HTLocationBatchBlock)block {
    WEAK(self);
    [self.dataSource locationsForDriverID:self.driverID block:^(NSArray<HTLocation *> *locations, NSError *error) {
        STRONG(self)
        if (error) {
            InvokeBlock(block, self, nil);
        }
        
        InvokeBlock(block, self, locations);
        [self removeLocations];
    }];
}

- (void)flushLocationBatchWithBlock:(HTLocationBatchBlock)block {
    WEAK(self);
    [self.dataSource flushLocationBatchForDriverID:self.driverID block:^(NSArray<HTLocation *> *locations, NSError *error) {
        STRONG(self)
        if (error) {
            InvokeBlock(block, self, nil);
        }
        
        InvokeBlock(block, self, locations);
    }];
}

- (CLLocation *)lastLocation {
    return self.lastAddedLocation.location;
}

@end
