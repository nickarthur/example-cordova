//
//  HTLocationTable.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 18/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTBlocks.h>
#import <Foundation/Foundation.h>

@class HTLocation;
@class HTSQLiteDatabase;

typedef void(^HTLocationQueryBlock)(NSArray <HTLocation *> *locations, NSError *error);
typedef void(^HTLocationCountBlock)(NSUInteger count, NSError *error);
typedef void(^HTLocationQueryWithIDBlock)(NSArray <HTLocation *> *locations, NSArray <NSNumber *> *locationIDs, NSError *error);

@interface HTLocationTable : NSObject

+ (void)createTableForDatabase:(HTSQLiteDatabase *)database block:(HTErrorBlock)block;
+ (void)dropTableIfExistsForDatabase:(HTSQLiteDatabase *)database block:(HTErrorBlock)block;
+ (void)addLocation:(HTLocation *)location database:(HTSQLiteDatabase *)database driverID:(NSString *)driverID block:(HTErrorBlock)block;
+ (void)locationsForDriverID:(NSString *)driverID database:(HTSQLiteDatabase *)database block:(HTLocationQueryBlock)block;
+ (void)deleteLocationsForDriverID:(NSString *)driverID database:(HTSQLiteDatabase *)database block:(HTErrorBlock)block;
+ (void)addLocations:(NSArray <HTLocation *> *)locations database:(HTSQLiteDatabase *)database driverID:(NSString *)driverID block:(HTErrorBlock)block;
+ (void)locationBatchForDriverID:(NSString *)driverID database:(HTSQLiteDatabase *)database block:(HTLocationQueryWithIDBlock)block;
+ (void)deleteLocations:(NSArray <NSNumber *> *)locationIDs database:(HTSQLiteDatabase *)database block:(HTErrorBlock)block;

@end
