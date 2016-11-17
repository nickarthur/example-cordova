//
//  HTTripParams.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 10/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <HTCommon/HTCommon.h>

/**
 *  `HTTripParams` is representation of the parameters required to start a trip.
 */
@interface HTTripParams : NSObject <NSCoding>

/**
 *  The driver ID number for the driver who is starting the trip.
 */
@property (nonatomic, copy, nullable) NSString *driverID;

/**
 *  The list of IDs of tasks that are going to be tracked in the trip.
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *taskIDs;

/**
 *  Vehicle type for the trip
 */
@property (nonatomic) HTDriverVehicleType vehicleType;

/**
 *  Boolean to specify if the trip has ordered tasks
 */
@property (nonatomic) BOOL hasOrderedTasks;

/**
 *  Boolean to specify if the trip should auto end when last task completes
 */
@property (nonatomic) BOOL autoEnd;

/**
 *  Dictionary value of the object. Will be used in API calls as parameter.
 */
@property (nonatomic, readonly, nullable) NSDictionary *dictionaryValue;

@end
