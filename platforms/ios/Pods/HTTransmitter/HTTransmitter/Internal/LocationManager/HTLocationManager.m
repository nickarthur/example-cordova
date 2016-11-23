//
//  HTLocationManager.m
//  HyperTrack
//
//  Created by Ulhas Mandrawadkar on 12/11/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTCommon.h>
#import "HTLocationRequest.h"
#import "NSError+HTLocationManager.h"

#import "HTLocationManager.h"

@interface HTLocationManager () <CLLocationManagerDelegate, HTLocationRequestDelegate>

@property (nonatomic, strong, nullable) CLLocationManager *locationManager;
@property (nonatomic, strong, nullable) CLLocation *currentLocation;
@property (nonatomic) BOOL isUpdatingLocation;
@property (nonatomic) BOOL updateFailed;
@property (nonatomic, strong, nullable) id<HTLoggerProtocol> logger;

@property (nonatomic, strong) NSArray <HTLocationRequest *> *locationRequests;

@end

NSString * const HTLocationUpdateNotification = @"io.hypertrack.notification.task.status.changed";

const NSTimeInterval minimumTimeInterval = 1.0f;

@implementation HTLocationManager

- (instancetype)initWithLogger:(id<HTLoggerProtocol>)logger {
    self = [super init];
    if (self) {
        self.locationManager = [self getHyperTrackLocationManager];
        self.locationRequests = @[];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithLogger:nil];
}

- (CLLocationManager *)getHyperTrackLocationManager {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.pausesLocationUpdatesAutomatically = NO;
    
    NSArray *backgroundModes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
    if ([backgroundModes containsObject:@"location"]) {
        if ([locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
            locationManager.allowsBackgroundLocationUpdates = YES;
        }
    }
    
    return locationManager;
}

+ (HTLocationServicesState)locationServicesState {
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return HTLocationServicesStateDisabled;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return HTLocationServicesStateNotDetermined;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return HTLocationServicesStateDenied;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return HTLocationServicesStateRestricted;
    }
    
    return HTLocationServicesStateAvailable;
}

#pragma mark - Authorization

+ (BOOL)isLocationAuthorized {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    return ((status == kCLAuthorizationStatusAuthorizedWhenInUse) ||
            (status == kCLAuthorizationStatusAuthorizedAlways) ||
            (status == kCLAuthorizationStatusNotDetermined)) && [CLLocationManager locationServicesEnabled];
}

+ (BOOL)locationEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)permissionEnabled {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return !(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusNotDetermined);
}

+ (BOOL)isAuthorizationDenied {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return (status == kCLAuthorizationStatusDenied) || (status == kCLAuthorizationStatusRestricted);
}

+ (BOOL)canStartLocationServices:(NSError *__autoreleasing *)error {
    
    if (![CLLocationManager locationServicesEnabled]) {
        if (error != NULL) {
            *error = [NSError ht_locationServicesDisabledError];
        }
        
        return NO;
    }
    
    if ([self isAuthorizationDenied]) {
        if (error != NULL) {
            *error = [NSError ht_locationAuthorizationError];
        }
        
        return NO;
    }
    
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] == nil
        && [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] == nil) {
        if (error != NULL) {
            *error = [NSError ht_infoDictionaryMissingKeyError];
        }
        
        return NO;
    }
    
    return YES;
}

- (HTLocationRequestID)requestLocationWithTimeout:(NSTimeInterval)timeout block:(HTLocationRequestBlock)block {
    HTLocationRequest *request = [[HTLocationRequest alloc] initWithType:HTLocationRequestTypeSingle];
    request.delegate = self;
    request.timeout = timeout;
    request.block = block;
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined) {
        [request startTimeoutTimerIfNeeded];
    }
    
    [self addLocationRequest:request];
    
    return request.requestID;
}

- (void)addLocationRequest:(HTLocationRequest *)locationRequest {
    HTLocationServicesState locationServicesState = [HTLocationManager locationServicesState];
    if (locationServicesState == HTLocationServicesStateDisabled ||
        locationServicesState == HTLocationServicesStateDenied ||
        locationServicesState == HTLocationServicesStateRestricted) {
        // No need to add this location request, because location services are turned off device-wide, or the user has denied this app permissions to use them
        [self completeLocationRequest:locationRequest];
        return;
    }
    
    [self startUpdatingLocationIfNeeded];
    
    NSMutableArray <HTLocationRequest *> *newLocationRequests = [NSMutableArray arrayWithArray:self.locationRequests];
    [newLocationRequests addObject:locationRequest];
    self.locationRequests = newLocationRequests;
    [self.logger info:@"Location Request added with ID: %ld", (long)locationRequest.requestID];
    
    // Process all location requests now, as we may be able to immediately complete the request just added above
    // if a location update was recently received (stored in self.currentLocation) that satisfies its criteria.
    [self processLocationRequests];
}

- (void)completeLocationRequest:(HTLocationRequest *)locationRequest {
    if (locationRequest == nil) {
        return;
    }
    
    [locationRequest complete];
    [self removeLocationRequest:locationRequest];
    
    HTLocationStatus status = [self statusForLocationRequest:locationRequest];
    CLLocation *currentLocation = self.currentLocation;
    
    // HTLocationManager is not thread safe and should only be called from the main thread, so we should already be executing on the main thread now.
    // dispatch_async is used to ensure that the completion block for a request is not executed before the request ID is returned, for example in the
    // case where the user has denied permission to access location services and the request is immediately completed with the appropriate error.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (locationRequest.block) {
            locationRequest.block(currentLocation, status);
        }
    });
    
    [self.logger info:@"Location Request completed with ID: %ld, currentLocation: %@, status: %lu", (long)locationRequest.requestID, currentLocation, (unsigned long)status];
}

- (void)removeLocationRequest:(HTLocationRequest *)locationRequest {
    NSMutableArray <HTLocationRequest *> *newLocationRequests = [NSMutableArray arrayWithArray:self.locationRequests];
    [newLocationRequests removeObject:locationRequest];
    self.locationRequests = newLocationRequests;
            
    [self stopUpdatingLocationIfPossible];
}

- (void)processLocationRequests {
    CLLocation *mostRecentLocation = self.currentLocation;
    
    for (HTLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.hasTimedOut) {
            // Non-recurring request has timed out, complete it
            [self completeLocationRequest:locationRequest];
            continue;
        }
        
        if (mostRecentLocation != nil) {
            if (locationRequest.isRecurring) {
                // This is a subscription request, which lives indefinitely (unless manually canceled) and receives every location update we get
                [self processRecurringRequest:locationRequest];
                continue;
            } else {
                // This is a regular one-time location request
                NSTimeInterval currentLocationTimeSinceUpdate = fabs([mostRecentLocation.timestamp timeIntervalSinceNow]);
                CLLocationAccuracy currentLocationHorizontalAccuracy = mostRecentLocation.horizontalAccuracy;
                NSTimeInterval staleThreshold = [locationRequest updateTimeStaleThreshold];
                CLLocationAccuracy horizontalAccuracyThreshold = [locationRequest horizontalAccuracyThreshold];
                if (currentLocationTimeSinceUpdate <= staleThreshold &&
                    currentLocationHorizontalAccuracy <= horizontalAccuracyThreshold) {
                    // The request's desired accuracy has been reached, complete it
                    [self completeLocationRequest:locationRequest];
                    continue;
                }
            }
        }
    }
}

- (void)processRecurringRequest:(HTLocationRequest *)locationRequest {
    NSAssert(locationRequest.isRecurring, @"This method should only be called for recurring location requests.");
    
    HTLocationStatus status = [self statusForLocationRequest:locationRequest];
    CLLocation *currentLocation = self.currentLocation;
    
    // HTLocationManager is not thread safe and should only be called from the main thread, so we should already be executing on the main thread now.
    // dispatch_async is used to ensure that the completion block for a request is not executed before the request ID is returned.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (locationRequest.block) {
            locationRequest.block(currentLocation, status);
        }
    });
}

- (void)startUpdatingLocationIfNeeded {
    [self requestAuthorizationIfNeeded];
    
    NSArray *locationRequests = self.locationRequests;
    if (locationRequests.count == 0) {
        [self.locationManager startUpdatingLocation];
        if (!self.isUpdatingLocation) {
            [self.logger debug:@"Location services updates have started."];
        }
        self.isUpdatingLocation = YES;
    }
}

- (void)stopUpdatingLocationIfPossible {
    NSArray *locationRequests = self.locationRequests;
    if (locationRequests.count == 0) {
        [self.locationManager stopUpdatingLocation];
        if (self.isUpdatingLocation) {
            [self.logger debug:@"Location services updates have stopped."];
        }
        self.isUpdatingLocation = NO;
    }
}

- (void)requestAuthorizationIfNeeded {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    // As of iOS 8, apps must explicitly request location services permissions. HTLocationManager supports both levels, "Always" and "When In Use".
    // HTLocationManager determines which level of permissions to request based on which description key is present in your app's Info.plist
    // If you provide values for both description keys, the more permissive "Always" level is requested.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
        BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
        if (hasAlwaysKey) {
            [self.locationManager requestAlwaysAuthorization];
        } else if (hasWhenInUseKey) {
            [self.locationManager requestWhenInUseAuthorization];
        } else {
            // At least one of the keys NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription MUST be present in the Info.plist file to use location services on iOS 8+.
            NSAssert(hasAlwaysKey || hasWhenInUseKey, @"To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.");
        }
    }
#endif /* __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 */
}

- (HTLocationStatus)statusForLocationRequest:(HTLocationRequest *)locationRequest {
    HTLocationServicesState locationServicesState = [HTLocationManager locationServicesState];
    
    if (locationServicesState == HTLocationServicesStateDisabled) {
        return HTLocationStatusServicesDisabled;
    }
    else if (locationServicesState == HTLocationServicesStateNotDetermined) {
        return HTLocationStatusServicesNotDetermined;
    }
    else if (locationServicesState == HTLocationServicesStateDenied) {
        return HTLocationStatusServicesDenied;
    }
    else if (locationServicesState == HTLocationServicesStateRestricted) {
        return HTLocationStatusServicesRestricted;
    }
    else if (self.updateFailed) {
        return HTLocationStatusError;
    }
    else if (locationRequest.hasTimedOut) {
        return HTLocationStatusTimedOut;
    }
    
    return HTLocationStatusSuccess;
}

- (CLLocation *)lastLocation {
    return self.locationManager.location;
}

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Received update successfully, so clear any previous errors
    self.updateFailed = NO;
    
    CLLocation *mostRecentLocation = [locations lastObject];
    self.currentLocation = mostRecentLocation;
    
    // Process the location requests using the updated location
    [self processLocationRequests];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.logger error:@"Location services error: %@", [error localizedDescription]];
    self.updateFailed = YES;
    
    for (HTLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.isRecurring) {
            // Keep the recurring request alive
            [self processRecurringRequest:locationRequest];
        } else {
            // Fail any non-recurring requests
            [self completeLocationRequest:locationRequest];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self.logger info:@"Location authorization changed"];
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        // Clear out any active location requests (which will execute the blocks with a status that reflects
        // the unavailability of location services) since we now no longer have location services permissions
        [self.logger warn:@"Location authorization changed to denied/restricted : %@.", @(status)];
        [self.logger info:@"Completing all non recurring requests"];
        [self completeAllNonRecurringLocationRequests];
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.logger info:@"Authorization Changed to active"];
        [self.logger debug:@"Authorization Changed to %@", @(status)];
        // Start the timeout timer for location requests that were waiting for authorization
        for (HTLocationRequest *locationRequest in self.locationRequests) {
            [locationRequest startTimeoutTimerIfNeeded];
        }
    }
}

- (void)completeAllNonRecurringLocationRequests {
    NSArray <HTLocationRequest *> *locationRequests = [self.locationRequests copy];
    for (HTLocationRequest *locationRequest in locationRequests) {
        if (locationRequest.isRecurring) {
            continue;
        }
        
        [self completeLocationRequest:locationRequest];
    }
    [self.logger info:@"Finished completing all location requests."];
}

- (void)forceCompleteLocationRequest:(HTLocationRequestID)requestID {
    NSAssert([NSThread isMainThread], @"HTLocationManager should only be called from the main thread.");
    
    for (HTLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.requestID == requestID) {
            if (locationRequest.isRecurring) {
                // Recurring requests can only be canceled
                [self cancelLocationRequest:requestID];
            } else {
                [locationRequest forceTimeout];
                [self completeLocationRequest:locationRequest];
            }
            break;
        }
    }
}

- (void)cancelLocationRequest:(HTLocationRequestID)requestID {
    NSAssert([NSThread isMainThread], @"HTLocationManager should only be called from the main thread.");
    
    for (HTLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.requestID == requestID) {
            [locationRequest cancel];
            [self.logger info:@"Location Request canceled with ID: %ld", (long)locationRequest.requestID];
            [self removeLocationRequest:locationRequest];
            break;
        }
    }
}

- (HTLocationRequestID)subscribeToLocationWithBlock:(HTLocationRequestBlock)block {
    NSAssert([NSThread isMainThread], @"HTLocationManager should only be called from the main thread.");
    
    HTLocationRequest *locationRequest = [[HTLocationRequest alloc] initWithType:HTLocationRequestTypeSubscription];
    locationRequest.block = block;
    
    [self addLocationRequest:locationRequest];
    return locationRequest.requestID;
}

#pragma mark - Location Request Delegate Method

- (void)locationRequestDidTimeout:(HTLocationRequest *)locationRequest {
    // For robustness, only complete the location request if it is still active (by checking to see that it hasn't been removed from the locationRequests array).
    for (HTLocationRequest *activeLocationRequest in self.locationRequests) {
        if (activeLocationRequest.requestID == locationRequest.requestID) {
            [self completeLocationRequest:locationRequest];
            break;
        }
    }
}

- (void)updateLocationAccuracy:(CLLocationAccuracy)accuracy {
    self.locationManager.desiredAccuracy = accuracy;
}

@end
