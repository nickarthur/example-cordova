//
//  HTTaskParams.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 13/07/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTCommon/HTCommon.h>

@class CLLocation;

/**
 *  `HTTaskParams` is representation of the parameters required to start a task.
 */
@interface HTTaskParams : NSObject <NSCoding>

/**
 *  HyperTrack TaskID of the HyperTrack Task to be tracked
 */
@property (nonatomic, copy, nullable) NSString *taskID;

/**
 *  HyperTrack DriverID for the driver who is starting the task
 */
@property (nonatomic, copy, nullable) NSString *driverID;

/**
 *  Vehicle type for the task
 */
@property (nonatomic) HTDriverVehicleType vehicleType;

/**
 *  Dictionary value of the object. Will be used in API calls as parameter.
 */
@property (nonatomic, readonly, nullable) NSDictionary *dictionaryValue;

@end
