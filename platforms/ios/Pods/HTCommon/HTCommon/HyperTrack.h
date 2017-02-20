//
//  HyperTrack.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 18/11/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTConstants.h"

///--------------------------------------
/// @name Version
///--------------------------------------

static NSString *const _Nonnull HTSDKVersion = @"0.12.6";

@interface HyperTrack : NSObject

///--------------------------------------
/// @name Publishable Key
///--------------------------------------

/**
 *  Set your HyperTrack API key with this method. API calls to the HyperTrack backend will use this value. You should call this method as early as
 *  possible in your application's lifecycle, preferably in your AppDelegate.
 *
 *  @param   publishableKey Your publishable key
 *  @warning Make sure not to ship your test API keys to the App Store! This will log a warning if you use your test key in a release build. `apiKey` must not be `nil`.
 */
+ (void)setPublishableAPIKey:(nonnull NSString *)publishableKey;

/**
 *  The current publishable key
 */
+ (nullable NSString *)publishableKey;

///--------------------------------------
/// @name Logging
///--------------------------------------

/**
 *  @abstract Sets the level of logging to display.
 *
 *  @discussion By default it is set to <HTLogLevelWarning>
 *
 *  @param logLevel <HTLogLevel> to set.
 *  @see HTLogLevel
 */
+ (void)setLogLevel:(HTLogLevel)logLevel;

/**
 *  @abstract Log level that will be displayed.
 *
 *  @discussion By default it is set to <HTLogLevelWarning>
 *
 *  @return A <HTLogLevel> value.
 *  @see HTLogLevel
 */
+ (HTLogLevel)logLevel;

@end
