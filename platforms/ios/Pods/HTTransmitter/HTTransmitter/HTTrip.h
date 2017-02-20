//
//  HTTrip.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 19/01/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLocation;

/**
 *  HTTrip. HyperTrack trip object. This class has properties related to the HyperTrack trip object. When a trip has been started, properties of this class will be populated.
 */
@interface HTTrip : NSObject

/*
 *  TripID of the HyperTrack trip.
 */
@property (copy, nonatomic, readonly, nonnull) NSString *tripID;

/**
 *  DriverID for the trip that has been started for tracking
 */
@property (copy, nonatomic, readonly, nullable) NSString *driverID;

/**
 *  Live state of the trip that has been started for tracking
 */
@property (strong, nonatomic, readonly, nullable) NSNumber *isLive;

/**
 *  Initial ETA for the trip
 */
@property (strong, nonatomic, readonly, nullable) NSDate *initialETA;

/**
 *  Current ETA for the trip
 */
@property (strong, nonatomic, readonly, nullable) NSDate *ETA;

/**
 *  Current Status of the trip
 */
@property (copy, nonatomic, readonly, nullable) NSString *status;

/**
 *  Current Connection Status of the trip
 */
@property (copy, nonatomic, readonly, nullable) NSString *connectionStatus;

/**
 *  Distance covered in the trip
 */
@property (strong, nonatomic, readonly, nullable) NSNumber *distance;

/**
 *  Encoded polyline for the location being traced in the trip
 */
@property (strong, nonatomic, readonly, nullable) NSString *encodedPolyline;

/**
 *  Encoded TimeAware polyline for the location being traced in the trip
 */
@property (strong, nonatomic, readonly, nullable) NSString *timeAwarePolyline;

/**
 *  Start location for the trip
 */
@property (strong, nonatomic, readonly, nullable) HTLocation *startLocation;

/**
 *  End location for the trip
 */
@property (strong, nonatomic, readonly, nullable) HTLocation *endLocation;

/**
 *  Start time for the trip
 */
@property (strong, nonatomic, readonly, nullable) NSDate *startedAt;

/**
 *  End time for the trip
 */
@property (strong, nonatomic, readonly, nullable) NSDate *endedAt;

/**
 *  List of taskIDs being tracked in the trip
 */
@property (strong, nonatomic, readonly, nullable) NSArray<NSString *> *taskIDs;

/**
 *  Bool to indicate whether current Trip has Ordered tasks
 */
@property (strong, nonatomic, readonly, nullable) NSNumber *hasOrderedTasks;

/**
 *  Vehicle type used for the trip
 */
@property (nonatomic, readonly) HTDriverVehicleType vehicleType;

/**
 *  Distance covered in the trip in KMs
 */
@property (nonatomic, readonly, nullable) NSNumber *distanceInKMs;

/**
 *  Current duration for the trip
 */
@property (nonatomic, readonly, nullable) NSNumber *duration;

/**
 *  Current duration of the trip in minutes
 */
@property (nonatomic, readonly, nullable) NSNumber *durationInMinutes;

/**
 *  Dictionary value for the trip
 */
@property (nonatomic, readonly, nonnull) NSDictionary *dictionaryValue;

/**
 *  Creates and returns a `HTTrip` object for the json dictionary passed as a parameter
 *
 *  @param  responseObject  JSON response object received from HyperTrack server
 */
- (instancetype _Nullable)initWithResponseObject:(NSDictionary * _Nullable)responseObject NS_DESIGNATED_INITIALIZER;

/**
 *  Updates the trip object with the json dictionary passed as a parameter
 *
 *  @param  responseObject  JSON response object received from HyperTrack server
 */
- (void)updateWithResponseObject:(NSDictionary * _Nullable)responseObject;

@end
