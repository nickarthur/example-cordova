//
//  HTMotionActivityManager.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 14/04/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMMotionActivity;

@interface HTMotionActivityManager : NSObject

@property (nonatomic, strong, readonly) CMMotionActivity *currentActivity;

+ (BOOL)isActivityAvailable;

- (void)startMotionActivityUpdates;
- (void)stopMotionActivityUpdates;

@end

@interface HTMotionActivityManager (HTLocation)

@property (nonatomic, readonly) NSArray <NSString *> *activities;
@property (nonatomic, readonly) NSUInteger activityConfidence;

@end
