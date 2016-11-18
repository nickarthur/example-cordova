//
//  HTLocationDataSourceProtocol.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 18/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTLocationDataSourceProtocol_h
#define HTLocationDataSourceProtocol_h

#import <HTCommon/HTBlocks.h>

@class HTLocation;

typedef void(^HTLocationDataSourceLocationsBlock)(NSArray <HTLocation *> *locations, NSError *error);
typedef void(^HTLocationDataSourceCountBlock)(NSUInteger count, NSError *error);

@protocol HTLocationDataSourceProtocol <NSObject>

- (void)addLocations:(NSArray <HTLocation *> *)locations driverID:(NSString *)driverID block:(HTErrorBlock)block;
- (void)deleteAllLocationsForDriverID:(NSString *)driverID block:(HTErrorBlock)block;
- (void)locationsForDriverID:(NSString *)driverID block:(HTLocationDataSourceLocationsBlock)block;
- (void)resetLocationsWithBlock:(HTErrorBlock)block;
- (void)flushLocationBatchForDriverID:(NSString *)driverID block:(HTLocationDataSourceLocationsBlock)block;

@end

#endif /* HTLocationDataSourceProtocol_h */
