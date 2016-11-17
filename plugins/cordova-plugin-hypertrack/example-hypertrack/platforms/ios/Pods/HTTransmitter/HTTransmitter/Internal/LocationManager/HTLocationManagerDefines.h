//
//  HTLocationManagerDefines.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 10/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTLocationManagerDefines_h
#define HTLocationManagerDefines_h

#import <CoreLocation/CoreLocation.h>

/** The possible states that location services can be in. */
typedef NS_ENUM(NSInteger, HTLocationServicesState) {
    /** User has already granted this app permissions to access location services, and they are enabled and ready for use by this app.
     Note: this state will be returned for both the "When In Use" and "Always" permission levels. */
    HTLocationServicesStateAvailable,
    /** User has not yet responded to the dialog that grants this app permission to access location services. */
    HTLocationServicesStateNotDetermined,
    /** User has explicitly denied this app permission to access location services. (The user can enable permissions again for this app from the system Settings app.) */
    HTLocationServicesStateDenied,
    /** User does not have ability to enable location services (e.g. parental controls, corporate policy, etc). */
    HTLocationServicesStateRestricted,
    /** User has turned off location services device-wide (for all apps) from the system Settings app. */
    HTLocationServicesStateDisabled
};

/** A status that will be passed in to the completion block of a location request. */
typedef NS_ENUM(NSInteger, HTLocationStatus) {
    // These statuses will accompany a valid location.
    /** Got a location and desired accuracy level was achieved successfully. */
    HTLocationStatusSuccess = 0,
    /** Got a location, but the desired accuracy level was not reached before timeout. (Not applicable to subscriptions.) */
    HTLocationStatusTimedOut,
    
    // These statuses indicate some sort of error, and will accompany a nil location.
    /** User has not yet responded to the dialog that grants this app permission to access location services. */
    HTLocationStatusServicesNotDetermined,
    /** User has explicitly denied this app permission to access location services. */
    HTLocationStatusServicesDenied,
    /** User does not have ability to enable location services (e.g. parental controls, corporate policy, etc). */
    HTLocationStatusServicesRestricted,
    /** User has turned off location services device-wide (for all apps) from the system Settings app. */
    HTLocationStatusServicesDisabled,
    /** An error occurred while using the system location services. */
    HTLocationStatusError
};

typedef void(^HTLocationRequestBlock)(CLLocation *currentLocation, HTLocationStatus status);


/** A unique ID that corresponds to one location request. */
typedef NSInteger HTLocationRequestID;

#endif /* HTLocationManagerDefines_h */
