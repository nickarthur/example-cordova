//
//  HTLocationRequest.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 10/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTLocationRequest.h"
#import "HTLocationRequestIDGenerator.h"

@interface HTLocationRequest ()

@property (nonatomic, readwrite) HTLocationRequestID requestID;
@property (nonatomic, readwrite) HTLocationRequestType type;
@property (nonatomic, readwrite) BOOL isRecurring;
@property (nonatomic, readwrite) HTLocationStatus status;

@property (nonatomic, assign, readwrite) BOOL hasTimedOut;
@property (nonatomic, strong) NSDate *requestStartTime;
@property (nonatomic, strong) NSTimer *timeoutTimer;

@end

static const CLLocationAccuracy kHTLocationRequestAccuracyThreshold = 2000.0f;
static const NSTimeInterval kHTLocationRequestStaleTimeThreshold = 900.0f;

@implementation HTLocationRequest

- (instancetype)initWithType:(HTLocationRequestType)type {
    self = [super init];
    if (self) {
        self.requestID = [HTLocationRequestIDGenerator getUniqueRequestID];
        self.type = type;
        self.hasTimedOut = NO;
    }
    return self;
}

- (void)startTimeoutTimerIfNeeded {
    if (self.timeout > 0 && !self.timeoutTimer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.requestStartTime = [NSDate date];
            self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(timeoutTimerFired:) userInfo:nil repeats:NO];
        });
    }
}

- (void)timeoutTimerFired:(NSTimer *)timer {
    self.hasTimedOut = YES;
    [self.delegate locationRequestDidTimeout:self];
}

- (void)complete {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    self.requestStartTime = nil;
}

- (BOOL)isRecurring {
    return self.type == HTLocationRequestTypeSubscription;
}

- (NSTimeInterval)updateTimeStaleThreshold {
    return kHTLocationRequestStaleTimeThreshold;
}

- (CLLocationAccuracy)horizontalAccuracyThreshold {
    return kHTLocationRequestAccuracyThreshold;
}

- (void)forceTimeout {
    if (self.isRecurring == NO) {
        self.hasTimedOut = YES;
    } else {
        NSAssert(self.isRecurring == NO, @"Only single location requests (not recurring requests) should ever be considered timed out.");
    }
}

- (void)cancel {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    self.requestStartTime = nil;
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    if (((HTLocationRequest *)object).requestID == self.requestID) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return [[NSString stringWithFormat:@"%ld", (long)self.requestID] hash];
}

- (void)dealloc
{
    [self.timeoutTimer invalidate];
}

@end
