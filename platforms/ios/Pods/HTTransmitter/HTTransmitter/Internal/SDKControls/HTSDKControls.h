//
//  HTSDKControls.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 11/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTSDKControlsAccuracyLevel) {
    HTSDKControlsAccuracyLevelLow,
    HTSDKControlsAccuracyLevelMedium,
    HTSDKControlsAccuracyLevelHigh
};

@interface HTSDKControls : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSNumber *isActive;
@property (nonatomic, copy, readonly) NSNumber *minimumDuration;
@property (nonatomic, copy, readonly) NSNumber *batchDuration;
@property (nonatomic, copy, readonly) NSNumber *healthDuration;
@property (nonatomic, copy, readonly) NSNumber *minimumDisplacement;
@property (nonatomic, readonly) HTSDKControlsAccuracyLevel accuracyLevel;

+ (HTSDKControls *)defaultControls;

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject NS_DESIGNATED_INITIALIZER;

@end
