//
//  HyperTrack.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 18/11/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import "HTLogger.h"
//#import "HTLogging.h"

#import "HyperTrack.h"

static NSString * const HTPublishableKeyUserDefaultKey = @"io.hypertrack.lib:HTPublishableKey";

@implementation HyperTrack

///--------------------------------------
#pragma mark - Publishale Key
///--------------------------------------

+ (void)setPublishableAPIKey:(NSString *)publishableKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:publishableKey forKey:HTPublishableKeyUserDefaultKey];
    [userDefaults synchronize];
}

+ (NSString *)publishableKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:HTPublishableKeyUserDefaultKey];
}

///--------------------------------------
#pragma mark - Logging
///--------------------------------------

+ (void)setLogLevel:(HTLogLevel)logLevel {
    [HTLogger setLogLevel:logLevel];
}

+ (HTLogLevel)logLevel {
    return [HTLogger logLevel];
}

@end
