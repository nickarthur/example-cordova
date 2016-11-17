//
//  HTUtility.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 28/08/15.
//  Copyright (c) 2015 HyperTrack Inc. All rights reserved.
//

#ifndef HyperTrack_iOS_SDK_HTUtility_h
#define HyperTrack_iOS_SDK_HTUtility_h

// This is a rough equivalent of dynamic_cast in C++.
// Use this when you're not sure if value is of type NSType.
// Returns nil if the type does not cast-able.
#define objc_dynamic_cast(NSType, value)								\
(((value) == nil) || [(value) isKindOfClass:[NSType class]] ? (NSType*)(value) : nil)

#endif

#import <UIKit/UIDevice.h>
#import <Foundation/Foundation.h>

@interface HTUtility : NSObject

+ (float)batteryLevel;
+ (UIDeviceBatteryState)batteryState;
+ (NSString *)deviceModel;

@end
