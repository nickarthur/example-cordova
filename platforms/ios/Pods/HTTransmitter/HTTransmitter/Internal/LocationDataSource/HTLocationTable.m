//
//  HTLocationTable.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 18/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTSQLiteDatabase.h"
#import "HTSQLiteDatabaseResult.h"

#import "HTLocationTable.h"
#import "HTTransmitterConstants.h"

static NSString * const TABLE_NAME = @"location";

static NSString * const COLUMN_ID = @"_id";
static NSString * const COLUMN_DRIVER_ID = @"driver_id";
static NSString * const COLUMN_GPS_LOCATION = @"gps_location";

static NSString * const CREATE_TABLE_QUERY = @"CREATE TABLE %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ BLOB NOT NULL);";
static NSString * const DROP_TABLE_QUERY = @"DROP TABLE IF EXISTS %@";
static NSString * const INSERT_LOCATION_QUERY = @"INSERT INTO %@ (%@, %@) VALUES (?, ?);";
static NSString * const GET_LOCATIONS_QUERY = @"SELECT * FROM %@ WHERE driver_id='%@'";
static NSString * const DELETE_LOCATIONS_QUERY = @"DELETE FROM %@ WHERE driver_id='%@'";
static NSString * const GET_LOCATIONS_LIMIT_QUERY = @"SELECT * FROM %@ WHERE driver_id='%@' LIMIT %ld";
static NSString * const DELETE_LOCATION_ID_QUERY = @"DELETE FROM %@ WHERE %@ IN (%@);";


@implementation HTLocationTable

+ (NSString *)createTableQuery {
    return [NSString stringWithFormat:CREATE_TABLE_QUERY, TABLE_NAME, COLUMN_ID, COLUMN_DRIVER_ID, COLUMN_GPS_LOCATION];
}

+ (NSString *)dropTableQuery {
    return [NSString stringWithFormat:DROP_TABLE_QUERY, TABLE_NAME];
}

+ (NSString *)insertLocationQuery {
    return [NSString stringWithFormat:INSERT_LOCATION_QUERY, TABLE_NAME, COLUMN_DRIVER_ID, COLUMN_GPS_LOCATION];
}

+ (void)createTableForDatabase:(HTSQLiteDatabase *)database block:(HTErrorBlock)block {
    [database executeQuery:[self createTableQuery]
      withArgumentsInArray:nil
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

+ (void)addLocation:(HTLocation *)location database:(HTSQLiteDatabase *)database driverID:(NSString *)driverID block:(HTErrorBlock)block {
    NSString *insertQuery = [self insertLocationQuery];
    NSData *locationBlob = [NSKeyedArchiver archivedDataWithRootObject:location];
    
    [database executeQuery:insertQuery
      withArgumentsInArray:@[driverID, locationBlob]
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

+ (void)locationsForDriverID:(NSString *)driverID database:(HTSQLiteDatabase *)database block:(HTLocationQueryBlock)block {
    NSString *query = [NSString stringWithFormat:GET_LOCATIONS_QUERY, TABLE_NAME, driverID];
    
    [database executeCachedQuery:query withArgumentsInArray:nil block:^(HTSQLiteDatabaseResult *result, NSError *error) {
        if (error) {
            InvokeBlock(block, nil, error);
            return;
        }
        
        NSMutableArray <HTLocation *> *mutableLocations = [NSMutableArray array];
        while ([result next]) {
            NSData *locationBlob = [result dataForColumn:COLUMN_GPS_LOCATION];
            HTLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:locationBlob];
            [mutableLocations addObject:location];
        }
        
        InvokeBlock(block, mutableLocations, nil);
    }];
}

+ (void)deleteLocationsForDriverID:(NSString *)driverID database:(HTSQLiteDatabase *)database block:(HTErrorBlock)block {
    NSString *query = [NSString stringWithFormat:DELETE_LOCATIONS_QUERY, TABLE_NAME, driverID];
    
    [database executeQuery:query
      withArgumentsInArray:nil
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

+ (void)dropTableIfExistsForDatabase:(HTSQLiteDatabase *)database block:(HTErrorBlock)block {
    [database executeQuery:[self dropTableQuery]
      withArgumentsInArray:nil
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

+ (void)addLocations:(NSArray<HTLocation *> *)locations database:(HTSQLiteDatabase *)database driverID:(NSString *)driverID block:(HTErrorBlock)block {
    [database beginTransactionWithBlock:^(HTSQLiteDatabaseResult *result, NSError *error) {
        if (error) {
            InvokeBlock(block, error);
            return;
        }
        
        for (HTLocation *location in locations) {
            [self addLocation:location database:database driverID:driverID block:^(NSError * _Nullable error) {
                if (error) {
                    InvokeBlock(block, error);
                    [database rollbackWithBlock:nil];
                    return;
                }
            }];
        }
        
        [database commitWithBlock:^(HTSQLiteDatabaseResult *result, NSError *error) {
            InvokeBlock(block, error);
        }];
    }];
}

+ (void)locationBatchForDriverID:(NSString *)driverID database:(HTSQLiteDatabase *)database block:(HTLocationQueryWithIDBlock)block {
    NSString *query = [NSString stringWithFormat:GET_LOCATIONS_LIMIT_QUERY, TABLE_NAME, driverID, (long)LOCATION_BATCH_LIMIT];
    [database executeCachedQuery:query withArgumentsInArray:nil block:^(HTSQLiteDatabaseResult *result, NSError *error) {
        if (error) {
            InvokeBlock(block, nil, nil, error);
            return;
        }
        
        NSMutableArray <HTLocation *> *mutableLocations = [NSMutableArray array];
        NSMutableArray <NSNumber *> *locationIDs = [NSMutableArray array];
        while ([result next]) {
            NSData *locationBlob = [result dataForColumn:COLUMN_GPS_LOCATION];
            HTLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:locationBlob];
            [mutableLocations addObject:location];
            [locationIDs addObject:@([result intForColumnIndex:0])];
        }
        
        InvokeBlock(block, mutableLocations, locationIDs, nil);
    }];
}

+ (void)deleteLocations:(NSArray <NSNumber *> *)locationIDs database:(HTSQLiteDatabase *)database block:(HTErrorBlock)block {
    NSString *args = [locationIDs componentsJoinedByString:@", "];
    NSString *query = [NSString stringWithFormat:DELETE_LOCATION_ID_QUERY, TABLE_NAME, COLUMN_ID, args];
    
    [database executeQuery:query withArgumentsInArray:nil block:^(HTSQLiteDatabaseResult *result, NSError *error) {
        InvokeBlock(block, error);
    }];
}

@end
