//
//  HTTaskDisplay.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 14/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusNotStarted;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusDispatching;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusOnTheWay;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusArriving;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusArrived;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusCompleted;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusConnectionLost;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusLocationLost;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusAborted;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusSuspended;
FOUNDATION_EXPORT NSString * const _Nonnull HTTaskDisplayStatusCanceled;

#define HTTaskDisplayStatusNotStartedLocalizedText NSLocalizedString(@"Yet to start", @"HTTaskDisplayStatusNotStarted")
#define HTTaskDisplayStatusDispatchingLocalizedText NSLocalizedString(@"Leaving now", @"HTTaskDisplayStatusDispatching")
#define HTTaskDisplayStatusOnTheWayLocalizedText NSLocalizedString(@"On the way", @"HTTaskDisplayStatusOnTheWay")
#define HTTaskDisplayStatusArrivingLocalizedText NSLocalizedString(@"Arriving", @"HTTaskDisplayStatusArriving")
#define HTTaskDisplayStatusArrivedLocalizedText NSLocalizedString(@"Arrived", @"HTTaskDisplayStatusArrived")
#define HTTaskDisplayStatusCompletedLocalizedText NSLocalizedString(@"Completed", @"HTTaskDisplayStatusCompleted")
#define HTTaskDisplayStatusConnectionLostLocalizedText NSLocalizedString(@"Lost network connectivity", @"HTTaskDisplayStatusConnectionLost")
#define HTTaskDisplayStatusLocationLostLocalizedText NSLocalizedString(@"Lost GPS connectivity", @"HTTaskDisplayStatusLocationLost")
#define HTTaskDisplayStatusAbortedLocalizedText NSLocalizedString(@"Aborted", @"HTTaskDisplayStatusAborted")
#define HTTaskDisplayStatusSuspendedLocalizedText NSLocalizedString(@"Suspended", @"HTTaskDisplayStatusSuspended")
#define HTTaskDisplayStatusCanceledLocalizedText NSLocalizedString(@"Canceled", @"HTTaskDisplayStatusCanceled")

@interface HTTaskDisplay : NSObject

@property (copy, nonatomic, readonly, nullable) NSNumber *showSummary;
@property (copy, nonatomic, readonly, nullable) NSNumber *durationRemaining;
@property (copy, nonatomic, readonly, nullable) NSString *status;
@property (copy, nonatomic, readonly, nullable) NSString *subStatus;
@property (copy, nonatomic, readonly, nullable) NSNumber *subStatusDuration;
@property (copy, nonatomic, readonly, nullable) NSString *subStatusText;
@property (copy, nonatomic, readonly, nullable) NSString *statusText;
@property (copy, nonatomic, readonly, nullable) NSNumber *progress;
@property (copy, nonatomic, readonly, nullable) NSDate *lastUpdatedAt;

@property (nonatomic, readonly, nullable) NSString *localizedStatus;

@property (nonatomic, readonly, nullable) NSDictionary *dictionaryValue;

- (instancetype _Nullable)initWithResponseObject:(NSDictionary * _Nullable)responseObject NS_DESIGNATED_INITIALIZER;

@end
