//
//  HTLocationService.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 02/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTCommon.h>

#import "HTTransmitterConstants.h"
#import "HTLocationManager.h"
#import "HTLocationBatchManager.h"
#import "HTMotionActivityManager.h"
#import "HTSDKControlsManager.h"
#import "HTDriverStatsCollector.h"
#import "HTSDKControls.h"
#import "HTLocationDataSource.h"
#import "HTNetworkRequestManager.h"
#import "HTNetworkRequest.h"
#import "HTJobScheduler.h"
#import "HTActiveDriver.h"
#import "NSError+HTTransmitterClient.h"

#import "HTLocationService.h"

NSString * const HTLocationServiceDidTerminate = @"io.hypertrack.lib:HTLocationServiceDidTerminate";
static NSString * const HTLocationServiceLastActiveDriverKey = @"io.hypertrack.lib:HTLocationServiceActiveDriver";

const NSInteger DefaultRequestID = -1;

@interface HTLocationService ()

@property (nonatomic, readwrite) BOOL active;
@property (nonatomic) HTActiveDriver *driver;

@property (nonatomic, assign) HTLocationRequestID requestID;
@property (nonatomic, assign) HTJobID jobID;

@property (nonatomic, assign) CLLocationDistance minimumDisplacement;
@property (nonatomic, assign) NSTimeInterval minimumDuration;

@property (nonatomic, nullable, strong) HTLocationManager *locationManager;
@property (nonatomic, nullable, strong) HTLocationBatchManager *batchManager;
@property (nonatomic, nullable, strong) HTMotionActivityManager *motionActivityManager;
@property (nonatomic, nullable, strong) HTSDKControlsManager *sdkControlsManager;
@property (nonatomic, nullable, strong) HTDriverStatsCollector *statsCollector;
@property (nonatomic, nullable, strong) HTReachability *reachability;
@property (nonatomic, nullable, strong) HTNetworkRequestManager *networkManager;
@property (nonatomic, nullable, strong) HTJobScheduler *jobScheduler;
@property (nonatomic, nullable, strong) id<HTLoggerProtocol> logger;

@end

@interface HTSDKControls (HTLocationManager)

@property (nonatomic, readonly) CLLocationAccuracy accuracy;

@end

@implementation HTLocationService

#pragma mark - Init Methods

- (instancetype)initWithLocationManager:(HTLocationManager *)locationManager
                             dataSource:(id<HTLocationDataSourceProtocol>)dataSource
                  networkRequestManager:(HTNetworkRequestManager *)networkRequestManager
                           reachability:(HTReachability *)reachability
                              scheduler:(HTJobScheduler *)jobScheduler
                                 logger:(id<HTLoggerProtocol>)logger {
    self = [super init];
    if (self) {
        self.locationManager = locationManager;
        self.reachability = reachability;
        self.networkManager = networkRequestManager;
        self.batchManager = [[HTLocationBatchManager alloc] initWithDataStore:dataSource];
        self.sdkControlsManager = [[HTSDKControlsManager alloc] initWithSDKControls:[HTSDKControls defaultControls]];
        self.jobScheduler = jobScheduler;
        self.logger = logger;
        self.motionActivityManager = [[HTMotionActivityManager alloc] init];
        self.statsCollector = [[HTDriverStatsCollector alloc] init];
        self.requestID = DefaultRequestID;
        [self subscribeToSDKControlEvents];
    }
    
    return self;
}

#pragma mark - Job Scheduling Methods

- (void)handleJobScheduling {
    [self.logger info:@"Handling Job Scheduling for location service"];
    [self.logger debug:@"Flusing current locations"];
    [self.batchManager flushCurrentLocations:^(HTLocationBatchManager *batchManager, NSArray<HTLocation *> *locations) {
        [self.logger info:@"Flushed current locations. Count : %@", @(locations.count)];
    
        if (locations.count > 0) {
            [self postCurrentLocations:locations];
        }
        [self publishDriverHealth];
    }];
}

#pragma mark - Location Methods

- (void)postCurrentLocations:(NSArray <HTLocation *> *)locations {
    [self.logger info:@"Posting current locations"];
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost
                                                                   APIString:@"api/v1/gps/bulk/"
                                                                      params:[self paramsForLocations:locations]
                                                                    callback:^(id  _Nullable responseObject, HTNetworkRequestStatus status, NSError * _Nullable error) {
                                                                        if (status != HTNetworkRequestStatusProcessed) {
                                                                            [self.logger warn:@"Couldn't process request. Adding locations to database. Status : %@", @(status)];
                                                                            [self.batchManager addLocations:locations block:nil];
                                                                        }
                                                                    }];
    
    request.parallel = YES;
    request.hasTimeout = NO;
    request.cached = NO;
    request.type = HTNetworkRequestTypeMQTT;
    request.topic = [NSString stringWithFormat:@"GPSLog/%@", self.driverID];
    
    [self.networkManager processRequest:request];
}

- (void)locationManagerDidReceiveLocation:(CLLocation *)currentLocation {
    HTLocation *location = [[HTLocation alloc] initWithLocation:currentLocation];
    if (self.motionActivityManager.currentActivity != nil) {
        [location updateWithActivities:self.motionActivityManager.activities
                         andConfidence:self.motionActivityManager.activityConfidence];
    }
    
    if ([self validLocation:self.batchManager.lastLocation currentLocation:currentLocation]) {
        WEAK(self);
        [self.batchManager addLocations:@[location] block:^(HTLocationBatchManager *batchManager, NSArray<HTLocation *> *locations, NSError *error) {
            STRONG(self);
            if (locations.count >= LOCATION_BATCH_LIMIT) {
                [self.logger info:@"Crossed batch limit"];
                [self.batchManager flushLocationBatchWithBlock:^(HTLocationBatchManager *batchManager, NSArray<HTLocation *> *locations) {
                    [self postLocationBatch:locations];
                }];
            }
        }];
    }
}

- (BOOL)validLocation:(CLLocation *)lastLocation currentLocation:(CLLocation *)location {
    return (!lastLocation
            || ([lastLocation distanceFromLocation:location] >= self.minimumDisplacement
                && [location.timestamp timeIntervalSinceDate:lastLocation.timestamp] >= self.minimumDuration));
}

- (void)postLocationBatch:(NSArray<HTLocation *> *)locations {
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost
                                                                   APIString:@"api/v1/gps/bulk/"
                                                                      params:[self paramsForLocations:locations]
                                                                    callback:nil];
    
    request.parallel = YES;
    request.hasTimeout = NO;
    request.cached = YES;
    request.type = HTNetworkRequestTypeMQTT;
    request.topic = [NSString stringWithFormat:@"GPSLog/%@", self.driverID];
    
    [self.logger info:@"Adding locations to network request"];
    WEAK(self);
    [self.networkManager addRequest:request block:^(HTNetworkRequestStatus status) {
        STRONG(self);
        if (status == HTNetworkRequestStatusError) {
            [self.logger error:@"Failed adding request to database"];
            [self.batchManager addLocations:locations block:nil];
        }
    }];
}

- (void)postLocations:(HTVoidBlock)block {
    [self.batchManager flushLocationBatchWithBlock:^(HTLocationBatchManager *batchManager, NSArray<HTLocation *> *locations) {
        if (locations.count > 0) {
            [self postLocationBatch:locations];
        }
        
        InvokeBlock(block);
    }];
}

- (id)paramsForLocations:(NSArray <HTLocation *> *)locations {
    NSMutableArray *gpsLocations = [NSMutableArray array];
    for (HTLocation *location in locations) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:location.locationDictionaryValue];
        [params ht_setNilSafeObject:self.driverID forKey:@"driver_id"];
        [gpsLocations addObject:params];
    }
    
    return gpsLocations;
}

#pragma mark - SDKControls Methods

- (void)postDriverHealthViaMQTT:(BOOL)mqtt {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.logger info:@"Updating SDK Controls. MQTT : %@", @(mqtt)];
        NSArray <HTDriverStats *> *stats = [self.statsCollector flushDriverStats];
        HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithMethodType:HTNetworkRequestMethodTypePost
                                                                       APIString:[NSString stringWithFormat:@"api/v1/drivers/%@/health/", self.driverID]
                                                                          params:[self.statsCollector paramsForDriverStats:stats]
                                                                        callback:^(id  _Nullable responseObject, HTNetworkRequestStatus status,NSError * _Nullable error) {
                                                                            
                                                                            [self.sdkControlsManager didReceiveSDKControls:responseObject error:error completion:^(HTSDKControls *sdkControls, HTSDKControlsUpdate *update, NSError *error) {
                                                                                
                                                                                if (error) {
                                                                                    [self.logger warn:@"Couldn't fetch SDK controls"];
                                                                                    [self.logger error:@"Fetch SDK controls Error : %@", error];
                                                                                    [self.statsCollector addStats:stats];
                                                                                    return;
                                                                                }
                                                                                
                                                                                [self updateWithSDKControls:sdkControls updated:update];
                                                                            }];
                                                                        }];
        
        request.parallel = YES;
        request.hasTimeout = YES;
        request.cached = YES;
        
        if (mqtt) {
            request.type = HTNetworkRequestTypeMQTT;
            request.topic = [NSString stringWithFormat:@"DeviceHealth/%@", self.driverID];
        }
        
        [self.networkManager processRequest:request];
    });
}

- (void)publishDriverHealth {
    [self postDriverHealthViaMQTT:YES];
}

- (void)updateSDKControls {
    [self postDriverHealthViaMQTT:NO];
}

- (void)updateWithSDKControls:(HTSDKControls *)sdkControls updated:(HTSDKControlsUpdate *)update {
    [self.logger info:@"SDK Controls updated"];
    
    if (update.activeStatusChanged && sdkControls.isActive) {
        [self.logger info:@"Driver active changed"];
        BOOL active = sdkControls.isActive.boolValue;
        if (!active) {
            [self.logger info:@"Stopping location service"];
            [self stopService];
            [[NSNotificationCenter defaultCenter] postNotificationName:HTLocationServiceDidTerminate object:nil];
            return;
        } else {
            [self.logger info:@"Starting location service"];
            [self startForDriverID:self.driver.driverID];
        }
    }
    
    if (update.batchDurationUpdated && sdkControls.batchDuration) {
        [self.logger info:@"Updating batch duration to %@", sdkControls.batchDuration];
        [self.jobScheduler update:sdkControls.batchDuration.doubleValue];
    }
    
    if (update.healthDurationUpdated && sdkControls.healthDuration) {
        [self.logger info:@"Updating stats collection to %@", sdkControls.healthDuration];
        [self.statsCollector updateTimeInterval:sdkControls.healthDuration.doubleValue];
    }
    
    if (update.accuracyUpdated) {
        [self.logger info:@"Updating accuracy to %@", @(sdkControls.accuracyLevel)];
        [self.locationManager updateLocationAccuracy:sdkControls.accuracy];
    }
    
    if (update.minimumDisplacementUpdated && sdkControls.minimumDisplacement) {
        [self.logger info:@"Updating displacement to %@", sdkControls.minimumDisplacement];
        self.minimumDisplacement = sdkControls.minimumDisplacement.doubleValue;
    }
    
    if (update.minimumDurationUpdated && sdkControls.minimumDuration) {
        [self.logger info:@"Updating duration to %@", sdkControls.minimumDuration];
        self.minimumDuration = sdkControls.minimumDuration.doubleValue;
    }
}

#pragma mark - Start/Stop Service Methods

- (void)startForDriverID:(NSString *)driverID {
    [self.logger info:@"Trying to start location service. DriverID : %@", driverID];
    
    if (self.active) {
        [self.logger debug:@"Location service is active. Aborting."];
        return;
    }
    
    [self.logger info:@"Location service started for driverID : %@", driverID];
    [self unsubscribeFromSDKControlEventsForDriverID:self.driverID];
    self.driver = [HTActiveDriver activeDriverWithDriverID:driverID];
    
    [self start];
}

- (void)start {
    self.active = YES;
    
    HTSDKControls *sdkControls = self.sdkControlsManager.sdkControls;
    self.minimumDisplacement = sdkControls.minimumDisplacement.doubleValue;
    self.minimumDuration = sdkControls.minimumDuration.doubleValue;
    [self.batchManager resetWithDriverID:self.driverID];
    
    [self.motionActivityManager startMotionActivityUpdates];
    self.requestID = [self.locationManager subscribeToLocationWithBlock:^(CLLocation *currentLocation, HTLocationStatus status) {
        switch (status) {
            case HTLocationStatusSuccess: {
                [self locationManagerDidReceiveLocation:currentLocation];
            }
                break;
                
            default:
                break;
        }
    }];
    
    [self.statsCollector startCollectingStatsForDriverID:self.driverID
                                            timeInterval:sdkControls.healthDuration.doubleValue
                                            reachability:self.reachability];
    
    [self.logger info:@"Subscribing to Job Scheduler"];
    self.jobID = [self.jobScheduler subscribe:^(id<HTJobProtocol> job) {
        [self handleJobScheduling];
    }];
    [self.jobScheduler update:self.sdkControlsManager.sdkControls.batchDuration.doubleValue];
    
    [self subscribeToSDKControlEvents];
}

- (void)stopService {
    self.driver = [HTActiveDriver inactiveDriverWithDriverID:self.driver.driverID];
    self.active = NO;
    
    [self.locationManager cancelLocationRequest:self.requestID];
    self.requestID = DefaultRequestID;
    
    [self.batchManager clear];
    [self.motionActivityManager stopMotionActivityUpdates];
    [self.statsCollector stopCollectingStats];
    [self.jobScheduler complete:self.jobID];
    [self.jobScheduler resetSchedule];
}

- (BOOL)canStartServiceForDriverID:(NSString *)driverID {
    if (!self.driverID) {
        return YES;
    }
    
    return [self.driverID isEqualToString:driverID];
}

- (void)startServiceIfNeeded {
    [self.logger info:@"Starting service if needed"];
    
    if (self.driver.active) {
        [self.logger info:@"Driver is active. Starting service"];
        [self start];
        [self updateSDKControls];
    }
}

#pragma mark - Active Driver Methods

- (NSString *)driverID {
    HTActiveDriver *driver = self.driver;
    if (!driver) {
        return nil;
    }
    
    return driver.driverID;
}

- (void)setDriver:(HTActiveDriver *)driver {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (!driver) {
        [userDefaults removeObjectForKey:HTLocationServiceLastActiveDriverKey];
    } else {
        NSData *archivedDriver = [NSKeyedArchiver archivedDataWithRootObject:driver];
        [userDefaults setObject:archivedDriver forKey:HTLocationServiceLastActiveDriverKey];
    }
    
    [userDefaults synchronize];
}

- (HTActiveDriver *)driver {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:HTLocationServiceLastActiveDriverKey];
    
    if (!data) {
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - Event subscription
    
- (void)subscribeToSDKControlEvents {
    if (self.driver) {
        [self processRequestForSubscribingDriverID:self.driver.driverID toSDKControlEventsWithCompletion:nil];
    }
}

- (void)subscribeDriverID:(NSString *)driverID toSDKControlEventsWithCompletion:(HTErrorBlock)completion {
    [self unsubscribeFromSDKControlEventsForDriverID:self.driverID];
    self.driver = [HTActiveDriver inactiveDriverWithDriverID:driverID];
    [self processRequestForSubscribingDriverID:driverID toSDKControlEventsWithCompletion:completion];
}
    
- (void)processRequestForSubscribingDriverID:(NSString *)driverID toSDKControlEventsWithCompletion:(HTErrorBlock)completion {
    if (!driverID) {
        InvokeBlock(completion, [NSError driverIDMissingError]);
        return;
    }
    
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithTopic:[NSString stringWithFormat:@"Push/SDKControls/%@", self.driver.driverID]
                                                         messageHandler:^(id responseObject, NSError *error) {
                                                             [self.logger info:@"Received SDK Controls Event"];
                                                             if (error) {
                                                                 [self.logger error:@"SDK Controls Event Error : %@", error];
                                                                 return;
                                                             }
                                                             
                                                             [self.sdkControlsManager didReceiveSDKControls:responseObject error:error completion:^(HTSDKControls *sdkControls, HTSDKControlsUpdate *update, NSError *error) {
                                                                 if (error) {
                                                                     [self.logger error:@"Did Recive SDK Controls. Error : %@", error];
                                                                     return;
                                                                 }
                                                                 
                                                                 [self updateWithSDKControls:sdkControls updated:update];
                                                             }];
                                                         } callback:^(id responseObject, HTNetworkRequestStatus status, NSError *error) {
                                                             if (error || status == HTNetworkRequestStatusError) {
                                                                 [self.logger error:@"Error subscribing to sdk controls. Error : %@", error];
                                                                 InvokeBlock(completion, error);
                                                                 return;
                                                             }
                                                             
                                                             [self.logger info:@"Subscribed to SDK Controls. DriverID : %@", self.driverID];
                                                             InvokeBlock(completion, nil);
                                                         }];
    
    [self.networkManager processRequest:request];
}

- (void)unsubscribeFromSDKControlEventsForDriverID:(NSString *)driverID {
    if (!driverID) {
        return;
    }
    
    HTNetworkRequest *request = [[HTNetworkRequest alloc] initWithTopicToDelete:[NSString stringWithFormat:@"Push/SDKControls/%@", driverID]];
    [self.networkManager processRequest:request];
}

@end

@implementation HTSDKControls (HTLocationManager)

- (CLLocationAccuracy)accuracy {
    CLLocationAccuracy accuracy;
    
    switch (self.accuracyLevel) {
        case HTSDKControlsAccuracyLevelLow:
            accuracy = kCLLocationAccuracyKilometer;
            break;
            
        case HTSDKControlsAccuracyLevelMedium:
            accuracy = kCLLocationAccuracyNearestTenMeters;
            break;
            
        default:
            accuracy = kCLLocationAccuracyBestForNavigation;
            break;
    }
    
    return accuracy;
}

@end
