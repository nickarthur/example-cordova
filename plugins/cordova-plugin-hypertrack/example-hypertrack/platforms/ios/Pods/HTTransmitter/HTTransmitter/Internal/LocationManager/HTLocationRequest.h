//
//  HTLocationRequest.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 10/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLocationManagerDefines.h"

@class HTLocationRequest;

typedef NS_ENUM(NSInteger, HTLocationRequestType) {
    HTLocationRequestTypeSingle,
    HTLocationRequestTypeSubscription
};

@protocol HTLocationRequestDelegate <NSObject>

- (void)locationRequestDidTimeout:(HTLocationRequest *)locationRequest;

@end

@interface HTLocationRequest : NSObject

@property (nonatomic, readonly) HTLocationRequestID requestID;
@property (nonatomic, weak) id<HTLocationRequestDelegate> delegate;
@property (nonatomic, readonly) HTLocationRequestType type;
@property (nonatomic, readonly) BOOL isRecurring;
@property (nonatomic, readonly) HTLocationStatus status;
@property (nonatomic, copy) HTLocationRequestBlock block;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign, readonly) BOOL hasTimedOut;

- (instancetype)initWithType:(HTLocationRequestType)type;
- (void)startTimeoutTimerIfNeeded;
- (void)complete;
- (void)forceTimeout;
- (void)cancel;

- (NSTimeInterval)updateTimeStaleThreshold;
- (CLLocationAccuracy)horizontalAccuracyThreshold;

@end
