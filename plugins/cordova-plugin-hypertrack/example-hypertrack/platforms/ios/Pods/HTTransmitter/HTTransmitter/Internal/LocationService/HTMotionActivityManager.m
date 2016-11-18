//
//  HTMotionActivityManager.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 14/04/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

#import "HTMotionActivityManager.h"

@interface HTMotionActivityManager ()

@property (nonatomic, strong) CMMotionActivityManager *activityManager;
@property (nonatomic, strong, readwrite) CMMotionActivity *currentActivity;

@end

@implementation HTMotionActivityManager

+ (BOOL)isActivityAvailable {
    return [CMMotionActivityManager isActivityAvailable];
}

- (void)startMotionActivityUpdates {
    
    if (![CMMotionActivityManager isActivityAvailable]) {
        return;
    }
    
    if (self.activityManager) {
        return;
    }
    
    self.activityManager = [[CMMotionActivityManager alloc] init];
    [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                          withHandler:^(CMMotionActivity * _Nullable activity) {
                                              self.currentActivity = activity;
                                          }];
}

- (void)stopMotionActivityUpdates {
    [self.activityManager stopActivityUpdates];
    self.activityManager = nil;
}

@end

NSString * const ACTIVITY_TYPE_UNKNOWN = @"unknown";
NSString * const ACTIVITY_TYPE_STATIONARY = @"stationary";
NSString * const ACTIVITY_TYPE_WALKING = @"walking";
NSString * const ACTIVITY_TYPE_RUNNING = @"running";
NSString * const ACTIVITY_TYPE_AUTOMOTIVE = @"automotive";
NSString * const ACTIVITY_TYPE_CYCLING = @"cycling";

@implementation HTMotionActivityManager (HTLocation)

- (NSArray <NSString *> *)activities {
    
    NSMutableArray <NSString *> *activities = [NSMutableArray array];
    
    if (self.currentActivity.unknown) {
        [activities addObject:ACTIVITY_TYPE_UNKNOWN];
    }
    
    if (self.currentActivity.stationary) {
        [activities addObject:ACTIVITY_TYPE_STATIONARY];
    }
    
    if (self.currentActivity.walking) {
        [activities addObject:ACTIVITY_TYPE_WALKING];
    }
    
    if (self.currentActivity.running) {
        [activities addObject:ACTIVITY_TYPE_RUNNING];
    }
    
    if (self.currentActivity.automotive) {
        [activities addObject:ACTIVITY_TYPE_AUTOMOTIVE];
    }
    
    if ([self.currentActivity respondsToSelector:@selector(cycling)]
        && self.currentActivity.cycling) {
        [activities addObject:ACTIVITY_TYPE_CYCLING];
    }
    
    return activities;
}

- (NSUInteger)activityConfidence {
    NSUInteger confidence = 30;
    
    if (self.currentActivity.confidence == CMMotionActivityConfidenceMedium) {
        confidence = 60;
    }
    
    if (self.currentActivity.confidence == CMMotionActivityConfidenceHigh) {
        confidence = 90;
    }
    
    return confidence;
}

@end
