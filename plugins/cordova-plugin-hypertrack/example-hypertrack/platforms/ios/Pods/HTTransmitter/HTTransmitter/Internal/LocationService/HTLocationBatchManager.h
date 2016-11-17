//
//  HTTripLocationBatchManager.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 17/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLocationBatchManager;
@class HTLocation;
@protocol HTLocationDataSourceProtocol;

typedef void(^HTLocationBatchBlock)(HTLocationBatchManager *batchManager, NSArray <HTLocation *> *locations);
typedef void(^HTLocationAddBlock)(HTLocationBatchManager *batchManager, NSArray <HTLocation *> *locations, NSError *error);

@interface HTLocationBatchManager : NSObject

- (instancetype)initWithDataStore:(id<HTLocationDataSourceProtocol>)dataSource;

@property (nonatomic, readonly) CLLocation *lastLocation;

- (void)addLocations:(NSArray <HTLocation *> *)locations block:(HTLocationAddBlock)block;
- (void)flushLocationBatchWithBlock:(HTLocationBatchBlock)block;
- (void)flushCurrentLocations:(HTLocationBatchBlock)block;

- (void)resetWithDriverID:(NSString *)driverID;
- (void)clear;

@end
