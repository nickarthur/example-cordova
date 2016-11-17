//
//  HTTask.m
//  HTConsumer
//
//  Created by Ulhas Mandrawadkar on 11/03/16.
//  Copyright © 2016 Ulhas Mandrawadkar. All rights reserved.
//

#import "HTUtility.h"
#import "HTPlace.h"
#import "HTDriver.h"
#import "NSDate+Extention.h"
#import "HTLocation.h"
#import "HTTaskDisplay.h"

#import "HTTask.h"

static NSString * const taskIDKey = @"id";
static NSString * const orderIDKey = @"order_id";
static NSString * const statusKey = @"status";
static NSString * const actionKey = @"action";

static NSString * const etaKey = @"eta";
static NSString * const initialETAKey = @"initial_eta";
static NSString * const committedETAKey = @"committed_eta";
static NSString * const startTimeKey = @"start_time";
static NSString * const completionTimeKey = @"completion_time";

static NSString * const driver = @"driver";

static NSString * const startLocationKey = @"start_location";
static NSString * const destinationKey = @"destination";
static NSString * const completionLocationKey = @"completion_location";

static NSString * const encodedPolylineKey = @"encoded_polyline";
static NSString * const distanceKey = @"distance";

static NSString * const vehicleTypeKey = @"vehicle_type";
static NSString * const connectionStatusKey = @"connection_status";
static NSString * const trackingURLKey = @"tracking_url";
static NSString * const displayKey = @"display";
static NSString * const startAddressKey = @"start_address";
static NSString * const completionAddressKey = @"completion_address";

NSString * const HTTaskStatusNotStarted = @"not_started";
NSString * const HTTaskStatusDispatching = @"dispatching";
NSString * const HTTaskStatusDriverOnTheWay = @"on_the_way";
NSString * const HTTaskStatusDriverArriving = @"arriving";
NSString * const HTTaskStatusDriverArrived = @"arrived";
NSString * const HTTaskStatusCompleted = @"completed";
NSString * const HTTaskStatusCanceled = @"canceled";
NSString * const HTTaskStatusAborted = @"aborted";
NSString * const HTTaskStatusSuspended = @"suspended";
NSString * const HTTaskStatusAutoEnded = @"auto_ended";

@interface HTTask ()

@property (copy, nonatomic, readwrite, nullable) NSString *taskID;
@property (copy, nonatomic, readwrite, nullable) NSString *orderID;
@property (copy, nonatomic, readwrite, nullable) NSString *status;
@property (copy, nonatomic, readwrite, nullable) NSString *action;

@property (strong, nonatomic, readwrite, nullable) NSDate *ETA;
@property (strong, nonatomic, readwrite, nullable) NSDate *initialETA;
@property (strong, nonatomic, readwrite, nullable) NSDate *committedETA;
@property (strong, nonatomic, readwrite, nullable) NSDate *startTime;
@property (strong, nonatomic, readwrite, nullable) NSDate *completionTime;

@property (strong, nonatomic, readwrite, nullable) HTDriver *driver;

@property (strong, nonatomic, readwrite, nullable) HTPlace *startPlace;
@property (strong, nonatomic, readwrite, nullable) HTPlace *destination;
@property (strong, nonatomic, readwrite, nullable) HTLocation *completionLocation;

@property (copy, nonatomic, readwrite, nullable) NSString *encodedPolyline;
@property (copy, nonatomic, readwrite, nullable) NSNumber *distance;

@property (copy, nonatomic, readwrite, nullable) NSString *trackingURL;
@property (copy, nonatomic, readwrite, nullable) NSString *startAddress;
@property (copy, nonatomic, readwrite, nullable) NSString *completionAddress;

@property (assign, nonatomic, readwrite) HTDriverVehicleType vehicleType;
@property (assign, nonatomic, readwrite) HTDriverConnectionStatus connectionStatus;
@property (strong, nonatomic, readwrite, nullable) HTTaskDisplay *display;

@end

@implementation HTTask

- (instancetype)init {
    return [self initWithResponseObject:nil];
}

- (instancetype)initWithTaskID:(NSString *)taskID {
    self = [self init];

    if (self) {
        self.taskID = taskID;
    }

    return self;
}

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject {
    self = [super init];

    if (self) {
        [self updateWithResponseObject:responseObject];
    }

    return self;
}

- (void)updateWithResponseObject:(NSDictionary *)responseObject {
    if (!responseObject
        || responseObject.count == 0) {
        return;
    }

    self.taskID = objc_dynamic_cast(NSString, responseObject[taskIDKey]);
    self.orderID = objc_dynamic_cast(NSString, responseObject[orderIDKey]);
    self.action = objc_dynamic_cast(NSString, responseObject[actionKey]);
    self.status = objc_dynamic_cast(NSString, responseObject[statusKey]);

    self.ETA = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[etaKey])];
    self.initialETA = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[initialETAKey])];
    self.committedETA = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[committedETAKey])];
    self.startTime = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[startTimeKey])];
    self.completionTime = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[completionTimeKey])];

    self.driver = [[HTDriver alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[driver])];

    HTLocation *startLocation = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[startLocationKey])];
    self.startPlace = [[HTPlace alloc] initWithLocation:startLocation];

    self.destination = [[HTPlace alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[destinationKey])];
    self.completionLocation = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[completionLocationKey])];

    self.encodedPolyline = objc_dynamic_cast(NSString, responseObject[encodedPolylineKey]);
    self.distance = objc_dynamic_cast(NSNumber, responseObject[distanceKey]);

    self.trackingURL = objc_dynamic_cast(NSString, responseObject[trackingURLKey]);
    self.startAddress = objc_dynamic_cast(NSString, responseObject[startAddressKey]);
    self.completionAddress = objc_dynamic_cast(NSString, responseObject[completionAddressKey]);

    self.vehicleType = [HTVehicleType vehicleTypeForStringValue:objc_dynamic_cast(NSString, responseObject[vehicleTypeKey])];
    self.connectionStatus = [HTConnectionStatus connectionStatusForStringValue:objc_dynamic_cast(NSString, responseObject[connectionStatusKey])];
    self.trackingURL = objc_dynamic_cast(NSString, responseObject[trackingURLKey]);
    self.display = [[HTTaskDisplay alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[displayKey])];
}

- (void)updateWithTask:(HTTask *)task {
    self.taskID = task.taskID;
    self.orderID = task.orderID;
    self.status = task.status;
    self.action = task.action;
    self.ETA = task.ETA;
    self.initialETA = task.initialETA;
    self.committedETA = task.committedETA;
    self.startTime = task.startTime;
    self.completionTime = task.completionTime;
    self.driver = task.driver;
    self.startPlace = task.startPlace;
    self.destination = task.destination;
    self.completionLocation = task.completionLocation;
    self.encodedPolyline = task.encodedPolyline;
    self.distance = task.distance;
    self.trackingURL = task.trackingURL;
    self.vehicleType = task.vehicleType;
    self.connectionStatus = task.connectionStatus;
    self.display = task.display;
    self.startAddress = task.startAddress;
    self.completionAddress = task.completionAddress;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ID : %@, Status : %@, ETA : %@", self.taskID, self.status, self.ETA];
}

- (BOOL)complete {
    if (self.display.showSummary) {
        return self.display.showSummary.boolValue;
    }
    
    return ([self.status isEqualToString:HTTaskStatusCompleted]
            || [self.status isEqualToString:HTTaskStatusCanceled]
            || [self.status isEqualToString:HTTaskStatusSuspended]
            || [self.status isEqualToString:HTTaskStatusAutoEnded]);
}

- (BOOL)inTransit {
    return ([self.status isEqualToString:HTTaskStatusDispatching]
            || [self.status isEqualToString:HTTaskStatusDriverOnTheWay]
            || [self.status isEqualToString:HTTaskStatusDriverArriving]
            || [self.status isEqualToString:HTTaskStatusDriverArrived]);
}

- (BOOL)canceled {
    return [self.status isEqualToString:HTTaskStatusCanceled];
}

- (NSNumber *)duration {
    if (!self.complete) {
        return nil;
    }

    if (!self.startTime || !self.display.lastUpdatedAt) {
        return nil;
    }

    return @([self.display.lastUpdatedAt timeIntervalSinceDate:self.startTime]);
}

- (NSNumber *)durationInMinutes {
    return @(ceilf(self.duration.floatValue /60.f));
}

- (NSNumber *)distanceInKMs {
    return @(self.distance.floatValue / 1000);
}

- (NSTimeInterval)etaDurationInSeconds {
    NSTimeInterval duration = [self.ETA timeIntervalSinceNow];
    return duration > 0.0f ? duration : 0.0f;
}

- (void)updateWithTrackingURL:(NSString *)trackingURL {
    self.trackingURL = trackingURL;
}

- (NSString *)displayStartAddress {
    if (self.startAddress && self.startAddress.length > 0) {
        return self.startAddress;
    }
    
    return self.startPlace.displayString;
}

- (NSString *)displayDestinationAddress {
    if (self.completionAddress && self.completionAddress.length > 0) {
        return self.completionAddress;
    }
    
    return self.destination.displayString;
}

@end
