//
//  HTShift.h
//  HTTransmitter
//
//  Created by Piyush on 26/11/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLocation;

/**
 *  HTShift. HyperTrack shift object. This class has properties related to the HyperTrack shift object. When a shift has been started, properties of this class will be populated.
 */
@interface HTShift : NSObject

/*
 *  ShiftID of the HyperTrack shift.
 */
@property (copy, nonatomic, readonly, nonnull) NSString *shiftID;

/**
 *  DriverID for the shift that has been started for tracking
 */
@property (copy, nonatomic, readonly, nullable) NSString *driverID;

/**
 *  Start location for the shift
 */
@property (strong, nonatomic, readonly, nullable) HTLocation *startLocation;

/**
 *  End location for the shift
 */
@property (strong, nonatomic, readonly, nullable) HTLocation *endLocation;

/**
 *  Start time for the shift
 */
@property (strong, nonatomic, readonly, nullable) NSDate *startedAt;

/**
 *  End time for the shift
 */
@property (strong, nonatomic, readonly, nullable) NSDate *endedAt;

/**
 *  Dictionary value for the shift
 */
@property (nonatomic, readonly, nonnull) NSDictionary *dictionaryValue;

/**
 *  Creates and returns a `HTShift` object for the json dictionary passed as a parameter
 *
 *  @param  responseObject  JSON response object received from HyperTrack server
 */
- (instancetype _Nullable)initWithResponseObject:(NSDictionary * _Nullable)responseObject NS_DESIGNATED_INITIALIZER;

/**
 *  Updates the shift object with the json dictionary passed as a parameter
 *
 *  @param  responseObject  JSON response object received from HyperTrack server
 */
- (void)updateWithResponseObject:(NSDictionary * _Nullable)responseObject;

@end
