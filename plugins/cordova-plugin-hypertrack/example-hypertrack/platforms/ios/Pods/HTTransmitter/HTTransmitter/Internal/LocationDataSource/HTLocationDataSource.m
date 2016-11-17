//
//  HTLocationDataSource.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 18/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTLocation.h>
#import <HTCommon/HTError.h>

#import "HTSQLiteDatabase.h"
#import "HTLocationTable.h"

#import "HTLocationDataSource.h"

@interface HTLocationDataSource ()

@property (nonatomic, strong) HTSQLiteDatabase *database;

@end

@implementation HTLocationDataSource

- (instancetype)initWithDatabase:(HTSQLiteDatabase *)database {
    self = [super init];
    if (self) {
        self.database = database;
        [self.database openWithBlock:nil];
    }
    
    return self;
}

- (void)addLocations:(NSArray<HTLocation *> *)locations driverID:(NSString *)driverID block:(HTErrorBlock)block {
    if (!locations) {
        InvokeBlock(block, [self errorForDatabaseWithMessage:@"Attempt to add nil locations."]);
        return;
    }
    
    if (locations.count == 1) {
        [HTLocationTable addLocation:locations.firstObject database:self.database driverID:driverID block:block];
    } else {
        [HTLocationTable addLocations:locations database:self.database driverID:driverID block:block];
    }
}

- (void)resetLocationsWithBlock:(HTErrorBlock)block {
    [HTLocationTable dropTableIfExistsForDatabase:self.database block:^(NSError * _Nullable error) {
        if (error) {
            InvokeBlock(block, error);
            return;
        }
        
        [HTLocationTable createTableForDatabase:self.database block:block];
    }];
}

- (void)locationsForDriverID:(NSString *)driverID block:(HTLocationDataSourceLocationsBlock)block {
    [HTLocationTable locationsForDriverID:driverID database:self.database block:block];
}

- (void)deleteAllLocationsForDriverID:(NSString *)driverID block:(HTErrorBlock)block {
    [HTLocationTable deleteLocationsForDriverID:driverID database:self.database block:block];
}

- (NSError *)errorForDatabaseWithMessage:(NSString *)message {
    return [NSError ht_errorForType:HTDatabaseError
                            message:message
                          parameter:nil
                          errorCode:HTSQLiteDatabaseInvalidSQL
                    devErrorMessage:@"Database error. Please try again."];
}

- (void)flushLocationBatchForDriverID:(NSString *)driverID block:(HTLocationDataSourceLocationsBlock)block {
    [HTLocationTable locationBatchForDriverID:driverID database:self.database block:^(NSArray<HTLocation *> *locations, NSArray<NSNumber *> *locationIDs, NSError *error) {
        if (error) {
            InvokeBlock(block, nil, error);
            return;
        }
        
        [HTLocationTable deleteLocations:locationIDs database:self.database block:^(NSError * _Nullable error) {
            InvokeBlock(block, locations, error);
        }];
    }];
}

@end
