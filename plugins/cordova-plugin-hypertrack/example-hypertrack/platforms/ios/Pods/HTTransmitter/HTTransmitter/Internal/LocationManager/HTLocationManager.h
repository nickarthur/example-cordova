//
//  HTLocationManager.h
//  HyperTrack
//
//  Created by Ulhas Mandrawadkar on 12/11/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HTLocationManagerDefines.h"

/*
 * Based on LocationManager from
 * https://github.com/intuit/LocationManager/
 */

@protocol HTLoggerProtocol;

@interface HTLocationManager : NSObject

- (instancetype)initWithLogger:(id<HTLoggerProtocol>)logger NS_DESIGNATED_INITIALIZER;

+ (BOOL)isLocationAuthorized;
+ (BOOL)isAuthorizationDenied;
+ (BOOL)canStartLocationServices:(NSError **)error;

+ (BOOL)locationEnabled;
+ (BOOL)permissionEnabled;

+ (HTLocationServicesState)locationServicesState;

- (HTLocationRequestID)requestLocationWithTimeout:(NSTimeInterval)timeout block:(HTLocationRequestBlock)block;
- (HTLocationRequestID)subscribeToLocationWithBlock:(HTLocationRequestBlock)block;

- (void)forceCompleteLocationRequest:(HTLocationRequestID)requestID;
- (void)cancelLocationRequest:(HTLocationRequestID)requestID;
- (void)updateLocationAccuracy:(CLLocationAccuracy)accuracy;

@end
