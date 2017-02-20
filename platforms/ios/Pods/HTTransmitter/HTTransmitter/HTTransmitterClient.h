//
//  HyperTrackTransmitterClient.h
//  HyperTrack
//
//  Created by Ulhas Mandrawadkar on 12/11/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTCommon.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "HTResponse.h"

@class HTTask;
@class HTTrip;
@class HTShift;

/**-----------------------------------------------------------------------------
 * @name Blocks
 * -----------------------------------------------------------------------------
 */

/**
 *  A C block, passed as a paramater to the methods which has `trip` specific callbacks. The block has no return value and takes two arguments: response, and error object.
 *
 *  @param response HyperTrack trip response. Will be nil if an error occurs.
 *  @param error    Error returned from the response, or nil in one occurs.
 *
 *  @since  v0.1.1
 */
typedef void(^ _Nullable HTTripBlock)(HTResponse <HTTrip *> * _Nullable response, NSError * _Nullable error);

/**
 *  A C block, passed as a paramater to the methods which has `task` specific callbacks. The block has no return value and takes two arguments: response, and error object.
 *
 *  @param  response    HyperTrack task response. Will be nil if an error occurs.
 *  @param  error   Error object in case of failure
 *
 */
typedef void(^ _Nullable HTTaskBlock)(HTResponse <HTTask *> * _Nullable response, NSError * _Nullable error);

/**
 *  A C block, passed as a paramater to the methods which has `shift` specific callbacks. The block has no return value and takes two arguments: response, and error object.
 *
 *  @param response HyperTrack shift response. Will be nil if an error occurs.
 *  @param error    Error returned from the response, or nil in one occurs.
 *
 *  @since  v0.12.5
 */
typedef void(^ _Nullable HTShiftBlock)(HTResponse <HTShift *> * _Nullable response, NSError * _Nullable error);

/**
 *  Posted immediately after the location service is terminated.
 */
FOUNDATION_EXPORT NSString * const _Nonnull HTLocationServiceDidTerminate;

@class HTTripParams;
@class HTTaskParams;
@class HTShiftParams;

/**
 *  HTTransmitterClient. TransmitterClient is a class with convinience methods to start/stop trips, mark task as complete.
 *
 *  @warning    Use sharedClient for a desired behavior. Do not create new instance of this class.
 */
@interface HTTransmitterClient : NSObject

///--------------------------------------
/// @name Shared Client
///--------------------------------------

/**
 *  A shared singleton Transmitter client. This client should be used to call the instance method.
 *
 *  @return Shared singleton `HTTransmitterClient`.
 *  @warning Not using shared client can lead to unexpected results.
 *
 *  @since  v0.1.1
 */
+ (nonnull instancetype)sharedClient;

/**
 *  Default initializer made unavailable
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 *  Default new method made unavailable
 */
+ (nonnull instancetype)new NS_UNAVAILABLE;

///--------------------------------------
/// @name Properties
///--------------------------------------

/**
 *  Returns true if any trip/shift is currenly active. and if the location is active.
 *
 *  @since  v0.10.0
 */
@property (nonatomic, readonly) BOOL transmitingLocation;

/**
 *  Returns ID of the Driver currently active
 *
 *  @since  v0.10.0
 */
@property (nonatomic, readonly, nullable) NSString *activeDriverID;

///--------------------------------------
/// @name Trip Management
///--------------------------------------

/**
 *  Starts trip on HyperTrack given trip parameters.
 *
 *  @param tripParams   `HTTripParams` object
 *  @param completion  Code to run when the start trip has been attempted.
 *
 *  @see -endTripWithCompletion:
 *
 *  @since  v0.1.1
 */
- (void)startTripWithTripParams:(nonnull HTTripParams *)tripParams
                     completion:(HTTripBlock)completion NS_SWIFT_NAME(startTrip(params:completion:));

/**
 *  End HyperTrack trip for give `tripID`
 *
 *  @param  tripID  HyperTrack TripID which needs to be ended.
 *  @param completion  Code to run when the end trip has been attempted.
 *
 *  @see -startTripWithTripParams:completion:
 *
 *  @since  v0.10.0
 */
- (void)endTripWithTripID:(nonnull NSString*)tripID completion:(HTTripBlock)completion NS_SWIFT_NAME(endTrip(tripID:completion:));
    
    
/**
*  End all live HyperTrack trips
*
*  @param completion  Code to run when the end all trips has been attempted.
*
*  @see -endTripWithTripID:completion:
*
*  @since  v0.12.0
*/
- (void)endAllTripsWithCompletion:(HTErrorBlock)completion NS_SWIFT_NAME(endAllTrips(completion:));

/**
 *  Refresh Current HyperTrack Trip
 *
 *  @param  tripID  HyperTrack TripID which needs to be refreshed.
 *  @param completion  Code to run when the end trip has been attempted.
 *
 *  @see -startTripWithTripParams:completion:
 *
 *  @since  v0.7.0
 */
- (void)refreshTripWithTripID:(nonnull NSString *)tripID completion:(HTTripBlock)completion NS_SWIFT_NAME(refreshTrip(tripID:completion:));

///--------------------------------------
/// @name Task Management
///--------------------------------------

/**
 *  Complete HyperTrack Task
 *
 *  @param taskID   HyperTrack Task ID
 *  @param completion  Code to run when the complete task has been attempted.
 *
 *  @since  v0.5.0
 */
- (void)completeTaskWithTaskID:(nonnull NSString *)taskID completion:(HTTaskBlock)completion NS_SWIFT_NAME(completeTask(taskID:completion:));

/**
 *  Refresh HyperTrack Task
 *
 *  @param  taskID  TaskID for the task to refresh
 *  @param completion  A C block, passed as a paramater to the methods which has `task` specific callbacks. The block has no return value and takes two arguments: the task object, and error object
 *
 *
 *  @since  v0.6.14
 */
- (void)refreshTaskWithTaskID:(nonnull NSString *)taskID completion:(HTTaskBlock)completion NS_SWIFT_NAME(refreshTask(taskID:completion:));

///--------------------------------------
/// @name Shift Management
///--------------------------------------

/**
 *  Start HyperTrack Shift
 *
 *  @param shiftParams   `HTShiftParams` object
 *  @param completion  Code to run when the start trip has been attempted.
 *
 *  @see -endShiftWithCompletion:
 *
 *  @since  v0.7.0
 */
- (void)startShiftWithShiftParams:(nonnull HTShiftParams *)shiftParams
                       completion:(HTShiftBlock)completion NS_SWIFT_NAME(startShift(params:completion:));

/**
 *  End HyperTrack Shift
 *
 *  @param completion  Code to run when the end shift has been attempted.
 *
 *  @see -startShiftWithShiftParams:completion:
 *
 *  @since  v0.7.0
 */
- (void)endShiftWithCompletion:(HTShiftBlock)completion NS_SWIFT_NAME(endShift(completion:));

///--------------------------------------
/// @name Location Service Management
///--------------------------------------

/**
 *  Starts HyperTrack location service for a given driverID
 *
 *  @param  driverID  HyperTrack DriverID to start the service
 *  @param completion  A C block, passed as a paramater to the methods which has network callbacks. The block has no return value and takes one argument: error object
 *
 *
 *  @since  v0.6.14
 */
- (void)startServiceForDriverID:(nonnull NSString *)driverID completion:(HTErrorBlock)completion NS_SWIFT_NAME(start(driverID:completion:));

/**
*  Connects a driver to HyperTrack backend. Once the driver is connected, trips or shift can be started and stopped from the backend. 
*
*  @param  driverID  HyperTrack DriverID to connect to HyperTrack backend
*  @param completion  A C block, passed as a paramater to the methods which has network callbacks. The block has no return value and takes one argument: error object
*
*
*  @since  v0.12.0
*/
- (void)connectDriverWithDriverID:(nonnull NSString *)driverID completion:(HTErrorBlock)completion NS_SWIFT_NAME(connect(driverID:completion:));

///--------------------------------------
/// @name State Management
///--------------------------------------

/**
 *  An initializer for the transmitter client. Restores state. The method will run only once. The subsequent calls will be no-op.
 *
 *  @since  v0.10.0
 */
+ (void)initClient;

@end
