//
//  HTTask.h
//  HTConsumer
//
//  Created by Ulhas Mandrawadkar on 11/03/16.
//  Copyright © 2016 Ulhas Mandrawadkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTVehicleType.h"
#import "HTConnectionStatus.h"

#import "HTVehicleType.h"
#import "HTConnectionStatus.h"

@class HTPlace;
@class HTDriver;
@class HTLocation;
@class HTTaskDisplay;

FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusNotStarted;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusDispatching;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusDriverOnTheWay;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusDriverArriving;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusDriverArrived;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusCompleted;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusCanceled;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusAborted;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusSuspended;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskStatusAutoEnded;

@interface HTTask : NSObject

@property (copy, nonatomic, readonly, nullable) NSString *taskID;
@property (copy, nonatomic, readonly, nullable) NSString *orderID;
@property (copy, nonatomic, readonly, nullable) NSString *status;
@property (copy, nonatomic, readonly, nullable) NSString *action;

@property (strong, nonatomic, readonly, nullable) NSDate *ETA;
@property (strong, nonatomic, readonly, nullable) NSDate *initialETA;
@property (strong, nonatomic, readonly, nullable) NSDate *committedETA;
@property (strong, nonatomic, readonly, nullable) NSDate *startTime;
@property (strong, nonatomic, readonly, nullable) NSDate *completionTime;
@property (strong, nonatomic, readonly, nullable) HTDriver *driver;

@property (strong, nonatomic, readonly, nullable) HTPlace *startPlace;
@property (strong, nonatomic, readonly, nullable) HTPlace *destination;
@property (strong, nonatomic, readonly, nullable) HTLocation *completionLocation;
@property (assign, nonatomic, readonly) HTDriverConnectionStatus connectionStatus;
@property (strong, nonatomic, readonly, nullable) HTTaskDisplay *display;

@property (copy, nonatomic, readonly, nullable) NSString *encodedPolyline;
@property (copy, nonatomic, readonly, nullable) NSNumber *distance;
@property (copy, nonatomic, readonly, nullable) NSString *timedEncodedPolyline;

@property (copy, nonatomic, readonly, nullable) NSString *trackingURL;
@property (copy, nonatomic, readonly, nullable) NSString *startAddress;
@property (copy, nonatomic, readonly, nullable) NSString *completionAddress;

@property (assign, nonatomic, readonly) HTDriverVehicleType vehicleType;

@property (nonatomic, readonly) BOOL complete;
@property (nonatomic, readonly) BOOL inTransit;
@property (nonatomic, readonly) BOOL canceled;

@property (nonatomic, readonly, nullable) NSNumber *distanceInKMs;
@property (nonatomic, readonly, nullable) NSNumber *duration;
@property (nonatomic, readonly, nullable) NSNumber *durationInMinutes;
@property (nonatomic, readonly) NSTimeInterval etaDurationInSeconds;
@property (nonatomic, readonly, nullable) NSString *displayStartAddress;
@property (nonatomic, readonly, nullable) NSString *displayDestinationAddress;

@property (nonatomic, readonly, nonnull) NSDictionary *dictionaryValue;
    
- (instancetype _Nullable)initWithTaskID:(NSString * _Nonnull)taskID;
- (instancetype _Nullable)initWithResponseObject:(NSDictionary * _Nullable)responseObject NS_DESIGNATED_INITIALIZER;

- (void)updateWithResponseObject:(NSDictionary * _Nullable)responseObject;
- (void)updateWithTrackingURL:(NSString * _Nullable)trackingURL;
- (void)updateWithTask:(HTTask * _Nullable)task;

@end
