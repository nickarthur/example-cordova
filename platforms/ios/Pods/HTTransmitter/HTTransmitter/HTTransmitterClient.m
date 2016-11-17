//
//  HyperTrackTransmitterClient.m
//  HyperTrack
//
//  Created by Ulhas Mandrawadkar on 12/11/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTCommon.h>

#import "HTTrip.h"
#import "HTLocationManager.h"
#import "HTTripParams.h"
#import "HTTransmitterConstants.h"
#import "HTTaskParams.h"
#import "HTLocationService.h"
#import "NSError+HTTransmitterClient.h"
#import "HTShiftParams.h"
#import "HTSQLiteDatabase+HTTransmitterClient.h"
#import "HTNetworkRequestManager.h"
#import "HTLocationDataSource.h"
#import "HTNetworkRequestDataSource.h"
#import "HTNetworkRequest.h"
#import "HTResponse_Private.h"
#import "HTNetworkJobScheduler.h"
#import "HTDatabaseDataSource.h"
#import "HTTransmitterJobSchedulerListener.h"
#import "HTMQTTClient.h"
#import "HTReachability.h"
#import "HTDispatchQueue.h"

#import "HTTransmitterClient.h"

static HTTransmitterClient * _sharedInstance = nil;
static const NSTimeInterval locationRequestTimeout = 30.0f;

@interface HTTransmitterClient ()

@property (nonatomic, nullable, strong) HTLocationManager *locationManager;
@property (nonatomic, nullable, strong) HTLocationService *locationService;
@property (nonatomic, nullable, strong) HTNetworkRequestManager *requestManager;
@property (nonatomic, nullable, strong) HTReachability *reachability;
@property (nonatomic, nullable, strong) HTJobScheduler *jobScheduler;
@property (nonatomic, nullable, strong) id <HTLoggerProtocol> logger;
@property (nonatomic, nullable, strong) HTTransmitterJobSchedulerListener *listener;

@end

@implementation HTTransmitterClient

+ (nonnull instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerForApplicationLifeCycleNotification];
        self.reachability = [HTReachability reachabilityWithHostName:HTTransmitterHTTPHost];
        [self.reachability startNotifier];
        
        HTSQLiteDatabase *database = [HTSQLiteDatabase databaseForTransmitterClient];
        HTDatabaseDataSource *logDataSource = [[HTDatabaseDataSource alloc] initWithDatabase:database]; 
        self.logger = [[HTLogger alloc] initWithDataSource:logDataSource userAgent:HTTransmitterUserAgent];
        
        self.jobScheduler = [[HTNetworkJobScheduler alloc] initWithReachability:self.reachability logger:self.logger];
        self.locationManager = [[HTLocationManager alloc] initWithLogger:self.logger];
        
        HTRestClient *restClient = [[HTRestClient alloc] initWithBaseURL:[NSString stringWithFormat:@"https://%@/", HTTransmitterHTTPHost] andUserAgent:HTTransmitterUserAgent];
        HTMQTTClient *mqttClient = [[HTMQTTClient alloc] initWithHost:HTTransmitterMQTTHost
                                                               prefix:HTTransmitterTopicPrefix
                                                            userAgent:HTTransmitterUserAgent
                                                               logger:self.logger
                                                         reachability:self.reachability
                                                        dispatchQueue:[HTDispatchQueue threadSafeConcurrentQueueForClass:[HTMQTTClient class]]];
        
        HTNetworkRequestDataSource *requestDataSource = [[HTNetworkRequestDataSource alloc] initWithDatabase:database];
        self.requestManager = [[HTNetworkRequestManager alloc] initWithDataSource:requestDataSource
                                                                     reachability:self.reachability
                                                                       restClient:restClient
                                                                     socketClient:mqttClient
                                                                           logger:self.logger];
        
        HTLocationDataSource *locationDataSource = [[HTLocationDataSource alloc] initWithDatabase:database];
        self.locationService = [[HTLocationService alloc] initWithLocationManager:self.locationManager
                                                                       dataSource:locationDataSource
                                                            networkRequestManager:self.requestManager
                                                                     reachability:self.reachability
                                                                        scheduler:self.jobScheduler
                                                                           logger:self.logger];
        
        self.listener = [[HTTransmitterJobSchedulerListener alloc] initWithJobScheduler:self.jobScheduler
                                                                                 logger:self.logger
                                                                         networkManager:self.requestManager
                                                                          logDatasource:logDataSource];
    }
    
    return self;
}

- (void)dealloc {
    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForApplicationLifeCycleNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.logger debug:@"Application became active"];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.logger debug:@"Application resign active"];
    }];
}

#pragma mark - Init Methods

+ (void)initClient {
    static dispatch_once_t initializeToken;
    dispatch_once(&initializeToken, ^{
        [[HTTransmitterClient sharedClient] initialize];
    });
}

- (void)initialize {
    [self.locationService startServiceIfNeeded];
}

#pragma mark - Trip Management Methods

- (void)startTripWithTripParams:(HTTripParams *)tripParams
                     completion:(HTTripBlock)completion {
    [self.logger info:@"Trying to start trip"];
    
    NSAssert(tripParams != nil, @"'tripParams' is required to start a trip");
    NSAssert(completion != nil, @"'completion' is required to use the trip that is created after start trip");
    NSAssert(tripParams.driverID != nil, @"'driverID' is required to start a trip");
    
    [self.logger debug:@"Trip Params : %@", tripParams];
    
    if (tripParams.driverID == nil || tripParams.driverID.length == 0) {
        [self.logger warn:@"Cannot start trip. DriverID is missing."];
        InvokeBlock(completion, nil, [NSError driverIDMissingError]);
        return;
    }
    
    NSError *error;
    if (![HTLocationManager canStartLocationServices:&error]) {
        [self.logger warn:@"Cannot start location service."];
        [self.logger debug:@"Location service error : %@", error.localizedDescription];
        
        InvokeBlock(completion, nil, error);
        return;
    }
    
    if (![self.locationService canStartServiceForDriverID:tripParams.driverID]) {
        [self.logger warn:@"Cannot start trip for a different driver ID."];
        InvokeBlock(completion, nil, [NSError locationServiceActiveForDifferentDriverError]);
        return;
    }
    
    [self.locationManager requestLocationWithTimeout:locationRequestTimeout
                                               block:^(CLLocation *currentLocation, HTLocationStatus status) {
                                                   [self startTripWithTripParams:tripParams location:currentLocation completion:completion];
                                               }];
}

- (void)startTripWithTripParams:(HTTripParams *)tripParams location:(CLLocation *)location completion:(HTTripBlock)completion {
    [self.logger warn:@"Start BL : %@", @([HTUtility batteryLevel])];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tripParams.dictionaryValue];
    if (location) {
        HTLocation *startLocation = [[HTLocation alloc] initWithLocation:location];
        [params ht_setNilSafeObject:startLocation.dictionaryValue forKey:@"start_location"];
    }
    
    [params ht_setNilSafeObject:[NSDate date].ht_stringValue forKey:@"start_time"];
    
    NSString *tripAPIString = @"api/v1/trips/";
    if (tripParams.tripID && tripParams.tripID.length > 0) {
        tripAPIString = [NSString stringWithFormat:@"api/v1/trips/%@/start/", tripParams.tripID];
    }
    
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost
                                                                   APIString:tripAPIString
                                                                      params:params
                                                                    callback:^(id responseObject, HTNetworkRequestStatus status, NSError *error) {
                                                                        if (error && !error.networkError) {
                                                                            [self.logger warn:@"Trip not started: %@", error.localizedDescription];
                                                                            [self.logger debug:@"Trip not started error : %@", error.localizedDescription];
                                                                            
                                                                            InvokeBlock(completion, nil, error);
                                                                            return;
                                                                        }
                                                                        
                                                                        [self.locationService startForDriverID:tripParams.driverID];
                                                                        [self.locationService updateSDKControls];
                                                                        
                                                                        [self.logger info:@"Trip Started!"];
                                                                        HTTrip *trip = [[HTTrip alloc] initWithResponseObject:responseObject];
                                                                        [self.logger debug:@"Trip Started Reponse Object : %@", trip];
                                                                        HTResponse <HTTrip *> *response = [[HTResponse <HTTrip *> alloc] initWithResult:trip offline:error.networkError];
                                                                        InvokeBlock(completion, response, nil);
                                                                    }];
    
    request.cached = YES;
    request.parallel = NO;
    request.hasTimeout = YES;
    
    [self.requestManager processRequest:request];
}

- (void)endTripWithTripID:(NSString *)tripID completion:(HTTripBlock)completion {
    [self.logger info:@"Trying to end trip"];
    
    NSAssert(completion != nil, @"'completion' is required to use the trip that is created after end trip");
    NSAssert(tripID != nil, @"'tripID' is required to end a trip");
    
    [self.locationService postLocations:^{
        [self.locationManager requestLocationWithTimeout:locationRequestTimeout
                                                   block:^(CLLocation *currentLocation, HTLocationStatus status) {
                                                       [self endTripWithTripID:tripID
                                                                      location:currentLocation
                                                                    completion:completion];
                                                   }];
    }];
}

- (void)endTripWithTripID:(NSString *)tripID location:(CLLocation *)location completion:(HTTripBlock)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (location) {
        HTLocation *htLocation = [[HTLocation alloc] initWithCoordinate:location.coordinate];
        [params ht_setNilSafeObject:htLocation.dictionaryValue forKey:@"end_location"];
    }
    [params ht_setNilSafeObject:[NSDate date].ht_stringValue forKey:@"ended_at"];
    
    
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost
                                                                   APIString:[NSString stringWithFormat:@"api/v1/trips/%@/end/", tripID]
                                                                      params:params
                                                                    callback:^(id responseObject, HTNetworkRequestStatus status, NSError *error) {
                                                                        if (error && !error.networkError) {
                                                                            [self.logger warn:@"Error ending trip : %@, Error :%@", tripID, error.localizedDescription];
                                                                            [self.logger debug:@"End trip error : %@", error.localizedDescription];
                                                                            
                                                                            InvokeBlock(completion, nil, error);
                                                                            return;
                                                                        }
                                                                            
                                                                        [self.logger info:@"Trip ended successfully for tripID :%@", tripID];
                                                                        [self.locationService updateSDKControls];
                                                                        HTTrip *trip = [[HTTrip alloc] initWithResponseObject:responseObject];
                                                                        HTResponse <HTTrip *> *response = [[HTResponse <HTTrip *> alloc] initWithResult:trip offline:error.networkError];
                                                                        InvokeBlock(completion, response, nil);
                                                                    }];
    request.cached = YES;
    request.parallel = NO;
    request.hasTimeout = YES;
    
    [self.requestManager processRequest:request];
}

- (void)endAllTripsWithCompletion:(HTErrorBlock)completion {
    [self.logger info:@"Trying to end all trips"];
    
    NSAssert(completion != nil, @"'completion' is required to use the response that is created after ending all trip");
    
    NSString *driverID = self.locationService.driverID;
    if (!self.locationService.active || !driverID) {
        [self.logger warn:@"No active driver. Cannot end trips"];
        InvokeBlock(completion, [NSError noActiveTripError]);
        return;
    }
    
    [self.locationService postLocations:^{
        [self.locationManager requestLocationWithTimeout:locationRequestTimeout
                                                   block:^(CLLocation *currentLocation, HTLocationStatus status) {
                                                       [self endAllTripsForDriverID:driverID
                                                                           location:currentLocation
                                                                         completion:completion];
                                                   }];
    }];
}
    
- (void)endAllTripsForDriverID:(NSString *)driverID location:(CLLocation *)location completion:(HTErrorBlock)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (location) {
        HTLocation *htLocation = [[HTLocation alloc] initWithCoordinate:location.coordinate];
        [params ht_setNilSafeObject:htLocation.dictionaryValue forKey:@"end_location"];
    }
    [params ht_setNilSafeObject:[NSDate date].ht_stringValue forKey:@"ended_at"];
    
    
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost
                                                                   APIString:[NSString stringWithFormat:@"api/v1/drivers/%@/end_trip/", driverID]
                                                                      params:params
                                                                    callback:^(id responseObject, HTNetworkRequestStatus status, NSError *error) {
                                                                        if (error && !error.networkError) {
                                                                            [self.logger warn:@"Error ending all trips : %@, Error : %@", driverID, error.localizedDescription];
                                                                            InvokeBlock(completion, error);
                                                                            return;
                                                                        }
                                                                        
                                                                        [self.logger info:@"Trips ended successfully for driverID :%@", driverID];
                                                                        [self.locationService updateSDKControls];
                                                                        InvokeBlock(completion, nil);
                                                                    }];
    request.cached = YES;
    request.parallel = NO;
    request.hasTimeout = YES;
    
    [self.requestManager processRequest:request];
}

- (void)refreshTripWithTripID:(NSString *)tripID completion:(HTTripBlock)completion {
    NSAssert(completion != nil, @"'completion' is required to use the trip that is created after start trip");
    NSAssert(tripID != nil, @"'tripID' is required to use the refresh the trip");
    [self.logger info:@"Trying to refresh trip : %@", tripID];
    
    NSString *refreshTripAPIString = [NSString stringWithFormat:@"api/v1/trips/%@/", tripID];
    HTNetworkRequest *networkRequest = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypeGet
                                                                          APIString:refreshTripAPIString
                                                                             params:nil
                                                                           callback:^(id responseObject, HTNetworkRequestStatus status, NSError *error) {
                                                                               if (error) {
                                                                                   InvokeBlock(completion, nil, error);
                                                                                   return;
                                                                               }
                                                                               
                                                                               HTTrip *trip = [[HTTrip alloc] initWithResponseObject:responseObject];
                                                                               HTResponse <HTTrip *> *response = [[HTResponse <HTTrip *> alloc] initWithResult:trip offline:NO];
                                                                               InvokeBlock(completion, response, nil);
                                                                           }];
    
    networkRequest.cached = NO;
    networkRequest.hasTimeout = YES;
    networkRequest.parallel = NO;
    
    [self.requestManager processRequest:networkRequest];
}

#pragma mark - Task Methods

- (void)completeTaskWithTaskID:(NSString *)taskID completion:(HTTaskBlock)completion {
    [self.logger info:@"Trying to complete task : %@", taskID];
    NSAssert(taskID != nil, @"'taskID' is required to mark task completed");
    
    [self.locationService postLocations:^{
        [self.locationManager requestLocationWithTimeout:locationRequestTimeout
                                                   block:^(CLLocation *currentLocation, HTLocationStatus status) {
                                                       [self completeTaskWithTaskID:taskID location:currentLocation completion:completion];
                                                   }];
    }];
}

- (void)completeTaskWithTaskID:(NSString *)taskID location:(CLLocation *)location completion:(HTTaskBlock)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (location) {
        HTLocation *htLocation = [[HTLocation alloc] initWithCoordinate:location.coordinate];
        [params ht_setNilSafeObject:htLocation.dictionaryValue forKey:@"completion_location"];
    }
    
    [params ht_setNilSafeObject:[NSDate date].ht_stringValue forKey:@"completion_time"];
    
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost
                                                                   APIString:[NSString stringWithFormat:@"api/v1/tasks/%@/completed/", taskID]
                                                                      params:params
                                                                    callback:^(id responseObject, HTNetworkRequestStatus status, NSError *error) {
                                                                        if (error && !error.networkError) {
                                                                            [self.logger warn:@"Error completing taskID : %@, Error :%@", taskID, error.localizedDescription];
                                                                            [self.logger debug:@"Complete tasks error : %@", error.localizedDescription];
                                                                            InvokeBlock(completion, nil, error);
                                                                            return;
                                                                        }
                                                                        
                                                                        [self.logger info:@"TaskID :%@ completed successfully.", taskID];
                                                                        [self.locationService updateSDKControls];
                                                                        
                                                                        HTTask *task = [[HTTask alloc] initWithResponseObject:responseObject];
                                                                        HTResponse <HTTask *> *response = [[HTResponse <HTTask *> alloc] initWithResult:task offline:error.networkError];
                                                                        InvokeBlock(completion, response, nil);
                                                                    }];
    
    request.cached = YES;
    request.parallel = NO;
    request.hasTimeout = YES;
    
    [self.requestManager processRequest:request];
}

- (void)refreshTaskWithTaskID:(NSString *)taskID completion:(HTTaskBlock)completion {
    NSAssert(completion != nil, @"'completion' is required to use the task that is created after start task");
    NSAssert(taskID != nil, @"'taskID' is required to use the refresh the task");
    [self.logger info:@"Trying to refresh task : %@", taskID];
    
    NSString *refreshTaskAPIString = [NSString stringWithFormat:@"api/v1/tasks/%@/", taskID];
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypeGet
                                                                   APIString:refreshTaskAPIString
                                                                      params:nil
                                                                    callback:^(id responseObject, HTNetworkRequestStatus status, NSError *error) {
                                                                        if (error) {
                                                                            InvokeBlock(completion, nil, error);
                                                                            return;
                                                                        }
                                                                        
                                                                        HTTask *task = [[HTTask alloc] initWithResponseObject:responseObject];
                                                                        HTResponse <HTTask *> *response = [[HTResponse <HTTask *> alloc] initWithResult:task offline:NO];
                                                                        InvokeBlock(completion, response, nil);
                                                                    }];
    
    request.cached = NO;
    request.hasTimeout = YES;
    request.parallel = NO;
    
    [self.requestManager processRequest:request];
}

#pragma mark - Shift Methods

- (void)startShiftWithShiftParams:(HTShiftParams *)shiftParams completion:(HTResponseBlock)completion {
    [self.logger info:@"Trying to start shift"];
    [self.logger debug:@"Shift Params : %@", shiftParams];
    
    NSAssert(shiftParams != nil, @"'shiftParams' is required to start a shift");
    NSAssert(completion != nil, @"'completion' is required to use the trip that is created after start trip");
    
    NSError *error;
    if (![HTLocationManager canStartLocationServices:&error]) {
        [self.logger warn:@"Cannot start location service."];
        [self.logger debug:@"Location service error : %@", error.localizedDescription];
        
        InvokeBlock(completion, nil, error);
        return;
    }
    
    if (![self.locationService canStartServiceForDriverID:shiftParams.driverID]) {
        [self.logger warn:@"Cannot start shift for a different driver ID."];
        InvokeBlock(completion, nil, [NSError locationServiceActiveForDifferentDriverError]);
        return;
    }
    
    [self.locationManager requestLocationWithTimeout:locationRequestTimeout
                                               block:^(CLLocation *currentLocation, HTLocationStatus status) {
                                                   [self startShiftWithShiftParams:shiftParams location:currentLocation completion:completion];
                                               }];
}

- (void)startShiftWithShiftParams:(HTShiftParams *)shiftParams location:(CLLocation *)location completion:(HTResponseBlock)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (location) {
        HTLocation *startLocation = [[HTLocation alloc] initWithLocation:location];
        [params ht_setNilSafeObject:startLocation.dictionaryValue forKey:@"start_location"];
    }
    
    [params ht_setNilSafeObject:[NSDate date].ht_stringValue forKey:@"start_time"];
    
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost
                                                                   APIString:[NSString stringWithFormat:@"api/v1/drivers/%@/start_shift/", shiftParams.driverID]
                                                                      params:params
                                                                    callback:^(id responseObject, HTNetworkRequestStatus status, NSError *error) {
                                                                        if (error && !error.networkError) {
                                                                            [self.logger warn:@"Shift not started : %@", error.localizedDescription];
                                                                            [self.logger debug:@"Shift not started error : %@", error.localizedDescription];
                                                                            
                                                                            InvokeBlock(completion, nil, error);
                                                                            return;
                                                                        }
                                                                        
                                                                        [self.logger info:@"Shift Started for driverID : %@!", shiftParams.driverID];
                                                                        [self.locationService startForDriverID:shiftParams.driverID];
                                                                        [self.locationService updateSDKControls];
                                                                        HTResponse *response = [[HTResponse alloc] initWithResult:responseObject offline:error.networkError];
                                                                        InvokeBlock(completion, response, nil);
                                                                    }];
    request.cached = YES;
    request.parallel = NO;
    request.hasTimeout = YES;
    
    [self.requestManager processRequest:request];
}

- (void)endShiftWithCompletion:(HTResponseBlock)completion {
    NSString *driverID = self.locationService.driverID;
    if (!self.locationService.active || !driverID) {
        [self.logger warn:@"No active driver. Cannot end shift"];
        InvokeBlock(completion, nil, [NSError noActiveShiftError]);
        return;
    }
    
    [self.locationService postLocations:^{
        [self.locationManager requestLocationWithTimeout:locationRequestTimeout
                                                   block:^(CLLocation *currentLocation, HTLocationStatus status) {
                                                       [self endShiftForDriverID:driverID
                                                                        location:currentLocation
                                                                      completion:completion];
                                                   }];
    }];
}

- (void)endShiftForDriverID:(NSString *)driverID location:(CLLocation *)location completion:(HTResponseBlock)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (location) {
        HTLocation *htLocation = [[HTLocation alloc] initWithCoordinate:location.coordinate];
        [params ht_setNilSafeObject:htLocation.dictionaryValue forKey:@"end_location"];
    }
    [params ht_setNilSafeObject:[NSDate date].ht_stringValue forKey:@"ended_at"];
    
    
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost
                                                                   APIString:[NSString stringWithFormat:@"api/v1/drivers/%@/end_shift/", driverID]
                                                                      params:params
                                                                    callback:^(id responseObject, HTNetworkRequestStatus status, NSError *error) {
                                                                        if (error && !error.networkError) {
                                                                            [self.logger warn:@"Error ending Shift : %@, Error :%@", driverID, error.localizedDescription];
                                                                            [self.logger debug:@"End Shift error : %@", error.localizedDescription];
                                                                            
                                                                            InvokeBlock(completion, nil, error);
                                                                            return;
                                                                        }
                                                                        
                                                                        [self.logger info:@"Shift ended successfully for driverID :%@", driverID];
                                                                        [self.locationService updateSDKControls];
                                                                        HTResponse *response = [[HTResponse alloc] initWithResult:responseObject offline:error.networkError];
                                                                        InvokeBlock(completion, response, nil);
                                                                    }];
    request.cached = YES;
    request.parallel = NO;
    request.hasTimeout = YES;
    
    [self.requestManager processRequest:request];
}

#pragma mark - Location Service Methods

- (void)startServiceForDriverID:(NSString *)driverID completion:(HTErrorBlock)completion {
    NSError *error;
    if (![HTLocationManager canStartLocationServices:&error]) {
        [self.logger warn:@"Cannot start location service."];
        [self.logger debug:@"Location service error : %@", error.localizedDescription];
        
        InvokeBlock(completion, error);
        return;
    }
    
    if (![self.locationService canStartServiceForDriverID:driverID]) {
        [self.logger warn:@"Cannot start trip for a different driver ID."];
        InvokeBlock(completion, [NSError locationServiceActiveForDifferentDriverError]);
        return;
    }
    
    if (self.locationService.active && ![self.locationService.driverID isEqualToString:driverID]) {
        NSError *error = [NSError ht_errorForType:HTUsageError
                                          message:nil
                                        parameter:nil
                                        errorCode:HTInvalidState
                                  devErrorMessage:@"Cannot start location service when a service is running for different driver"];
        
        [self.logger warn:@"Cannot start location service."];
        [self.logger debug:@"Location service error : %@", error.localizedDescription];
        
        InvokeBlock(completion, error);
        return;
    }
    
    [self.locationService startForDriverID:driverID];
    InvokeBlock(completion, nil);
}
    
- (void)connectDriverWithDriverID:(NSString *)driverID completion:(HTErrorBlock)completion {
    if (self.locationService.active) {
        NSError *error = nil;
        if(![driverID isEqualToString:self.locationService.driverID]) {
            error = [NSError driverIDActiveError];
        }
        
        InvokeBlock(completion, error);
        return;
    }
    
    [self.locationService subscribeDriverID:driverID toSDKControlEventsWithCompletion:completion];
}

- (BOOL)transmitingLocation {
    return self.locationService.active;
}

- (NSString *)activeDriverID {
    return self.locationService.driverID;
}

@end
