//
//  HTTaskDisplay.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 14/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTUtility.h"
#import "NSDate+Extention.h"
#import "NSDictionary+Extension.h"

#import "HTTaskDisplay.h"

static NSString * const showSummaryKey = @"show_summary";
static NSString * const durationRemainingKey = @"duration_remaining";
static NSString * const statusKey = @"status";
static NSString * const subStatusKey = @"sub_status";
static NSString * const subStatusDurationKey = @"sub_status_duration";
static NSString * const subStatusTextKey = @"sub_status_text";
static NSString * const statusTextKey = @"status_text";
static NSString * const progressKey = @"progress";
static NSString * const lastUpdatedAtKey = @"last_updated_at";

NSString * const HTTaskDisplayStatusNotStarted = @"not_started";
NSString * const HTTaskDisplayStatusDispatching = @"dispatching";
NSString * const HTTaskDisplayStatusOnTheWay = @"on_the_way";
NSString * const HTTaskDisplayStatusArriving = @"arriving";
NSString * const HTTaskDisplayStatusArrived = @"arrived";
NSString * const HTTaskDisplayStatusCompleted = @"completed";
NSString * const HTTaskDisplayStatusConnectionLost = @"connection_lost";
NSString * const HTTaskDisplayStatusLocationLost = @"location_lost";
NSString * const HTTaskDisplayStatusAborted = @"aborted";
NSString * const HTTaskDisplayStatusSuspended = @"suspended";
NSString * const HTTaskDisplayStatusCanceled = @"canceled";


@interface HTTaskDisplay ()

@property (copy, nonatomic, readwrite, nullable) NSNumber *showSummary;
@property (copy, nonatomic, readwrite, nullable) NSNumber *durationRemaining;
@property (copy, nonatomic, readwrite, nullable) NSString *status;
@property (copy, nonatomic, readwrite, nullable) NSString *subStatus;
@property (copy, nonatomic, readwrite, nullable) NSNumber *subStatusDuration;
@property (copy, nonatomic, readwrite, nullable) NSString *subStatusText;
@property (copy, nonatomic, readwrite, nullable) NSString *statusText;
@property (copy, nonatomic, readwrite, nullable) NSNumber *progress;
@property (copy, nonatomic, readwrite, nullable) NSDate *lastUpdatedAt;

@end

@implementation HTTaskDisplay

- (instancetype)init {
    return [self initWithResponseObject:nil];
}

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject {
    self = [super init];
    if (self) {
        [self updateWithResponseObject:responseObject];
    }
    
    return self;
}

- (void)updateWithResponseObject:(NSDictionary *)responseObject {
    if (!responseObject || responseObject.count == 0) {
        return;
    }
    
    self.showSummary = objc_dynamic_cast(NSNumber, responseObject[showSummaryKey]);
    self.durationRemaining = objc_dynamic_cast(NSNumber, responseObject[durationRemainingKey]);
    self.status = objc_dynamic_cast(NSString, responseObject[statusKey]);
    self.subStatus = objc_dynamic_cast(NSString, responseObject[subStatusKey]);
    self.subStatusDuration = objc_dynamic_cast(NSNumber, responseObject[subStatusDurationKey]);
    self.subStatusText = objc_dynamic_cast(NSString, responseObject[subStatusTextKey]);
    self.statusText = objc_dynamic_cast(NSString, responseObject[statusTextKey]);
    self.progress = objc_dynamic_cast(NSNumber, responseObject[progressKey]);
    self.lastUpdatedAt = [NSDate ht_dateFromString:objc_dynamic_cast(NSString, responseObject[lastUpdatedAtKey])];
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary ht_setNilSafeObject:self.showSummary forKey:showSummaryKey];
    [dictionary ht_setNilSafeObject:self.durationRemaining forKey:durationRemainingKey];
    [dictionary ht_setNilSafeObject:self.status forKey:statusKey];
    [dictionary ht_setNilSafeObject:self.subStatus forKey:subStatusKey];
    [dictionary ht_setNilSafeObject:self.subStatusDuration forKey:subStatusDurationKey];
    [dictionary ht_setNilSafeObject:self.statusText forKey:statusTextKey];
    [dictionary ht_setNilSafeObject:self.progress forKey:progressKey];
    [dictionary ht_setNilSafeObject:self.lastUpdatedAt.ht_stringValue forKey:lastUpdatedAtKey];
    
    return dictionary;
}

- (NSString *)localizedStatus {
    NSString *status;
    
    if ([self.status isEqualToString:HTTaskDisplayStatusNotStarted]) {
        status = HTTaskDisplayStatusNotStartedLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusDispatching]) {
        status = HTTaskDisplayStatusDispatchingLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusOnTheWay]) {
        status = HTTaskDisplayStatusOnTheWayLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusArriving]) {
        status = HTTaskDisplayStatusArrivingLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusArrived]) {
        status = HTTaskDisplayStatusArrivedLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusCompleted]) {
        status = HTTaskDisplayStatusCompletedLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusConnectionLost]) {
        status = HTTaskDisplayStatusConnectionLostLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusLocationLost]) {
        status = HTTaskDisplayStatusLocationLostLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusAborted]) {
        status = HTTaskDisplayStatusAbortedLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusSuspended]) {
        status = HTTaskDisplayStatusSuspendedLocalizedText;
    } else if ([self.status isEqualToString:HTTaskDisplayStatusCanceled]) {
        status = HTTaskDisplayStatusCanceledLocalizedText;
    } else {
        status = self.statusText;
    }
    
    return status;
}

@end
