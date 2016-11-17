//
//  HTSDKControls.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 11/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTCommon.h>
#import "HTSDKControls.h"

static NSString * const minimumDurationKey = @"minimum_duration";
static NSString * const batchDurationKey = @"batch_duration";
static NSString * const minimumDisplacementKey = @"minimum_displacement";
static NSString * const accuracyLevelKey = @"accuracy_level";
static NSString * const isActiveKey = @"is_active";
static NSString * const healthDurationKey = @"health_duration";

const NSTimeInterval defaultMinimumDuration = 5;
const NSTimeInterval defaultBatchDuration = 60;
const NSTimeInterval defaultHealthDuration = 30;
const NSTimeInterval defaultMinimumDisplacement = 30;

@interface HTSDKControls ()

@property (nonatomic, copy, readwrite) NSNumber *isActive;
@property (nonatomic, copy, readwrite) NSNumber *minimumDuration;
@property (nonatomic, copy, readwrite) NSNumber *batchDuration;
@property (nonatomic, copy, readwrite) NSNumber *healthDuration;
@property (nonatomic, copy, readwrite) NSNumber *minimumDisplacement;
@property (nonatomic, readwrite) HTSDKControlsAccuracyLevel accuracyLevel;

@end

@implementation HTSDKControls

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject {
    self = [super init];
    if (self) {
        [self updateWithResponseObject:responseObject];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithResponseObject:nil];
}

- (void)updateWithResponseObject:(NSDictionary *)responseObject {
    if (!responseObject
        || responseObject.count == 0) {
        return;
    }
    
    self.isActive = objc_dynamic_cast(NSNumber, responseObject[isActiveKey]);
    self.minimumDuration = objc_dynamic_cast(NSNumber, responseObject[minimumDurationKey]);
    self.batchDuration = objc_dynamic_cast(NSNumber, responseObject[batchDurationKey]);
    self.healthDuration = objc_dynamic_cast(NSNumber, responseObject[healthDurationKey]);
    self.minimumDisplacement = objc_dynamic_cast(NSNumber, responseObject[minimumDisplacementKey]);
    self.accuracyLevel = [[self class] accuracyForString:objc_dynamic_cast(NSString, responseObject[accuracyLevelKey])];
}

+ (HTSDKControls *)defaultControls {
    HTSDKControls *controls = [[HTSDKControls alloc] init];
    
    controls.isActive = @(YES);
    controls.minimumDuration = @(defaultMinimumDuration);
    controls.batchDuration = @(defaultBatchDuration);
    controls.healthDuration = @(defaultHealthDuration);
    controls.minimumDisplacement = @(defaultMinimumDisplacement);
    controls.accuracyLevel = HTSDKControlsAccuracyLevelHigh;
    
    return controls;
}

+ (HTSDKControlsAccuracyLevel)accuracyForString:(NSString *)accuracyString {
    HTSDKControlsAccuracyLevel accuracy = HTSDKControlsAccuracyLevelHigh;
    
    if ([accuracyString isEqualToString:@"low"]) {
        accuracy = HTSDKControlsAccuracyLevelLow;
    } else if ([accuracyString isEqualToString:@"medium"]) {
        accuracy = HTSDKControlsAccuracyLevelMedium;
    }
    
    return accuracy;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Active: %@, Minimum Duration : %@, Batch Duration : %@, Health Duration: %@, Accuracy Level: %@", self.isActive, self.minimumDuration, self.batchDuration, self.healthDuration, @(self.accuracyLevel)];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.isActive = [aDecoder decodeObjectForKey:isActiveKey];
        self.minimumDuration = [aDecoder decodeObjectForKey:minimumDurationKey];
        self.batchDuration = [aDecoder decodeObjectForKey:batchDurationKey];
        self.healthDuration = [aDecoder decodeObjectForKey:healthDurationKey];
        self.minimumDisplacement = [aDecoder decodeObjectForKey:minimumDisplacementKey];
        self.accuracyLevel = [aDecoder decodeIntegerForKey:accuracyLevelKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.isActive forKey:isActiveKey];
    [aCoder encodeObject:self.minimumDuration forKey:minimumDurationKey];
    [aCoder encodeObject:self.batchDuration forKey:batchDurationKey];
    [aCoder encodeObject:self.healthDuration forKey:healthDurationKey];
    [aCoder encodeObject:self.minimumDisplacement forKey:minimumDisplacementKey];
    [aCoder encodeInteger:self.accuracyLevel forKey:accuracyLevelKey];
}

@end
