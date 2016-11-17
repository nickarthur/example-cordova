//
//  NSDateFormatter+HTExtension.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 14/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import "NSDateFormatter+HTExtension.h"

static NSDateFormatter *longISOFormatter = nil;
static NSDateFormatter *shortISOFormatter = nil;

static NSDateFormatter *remoteLoggerFormatter = nil;

@implementation NSDateFormatter (HTExtension)

+ (NSDateFormatter *)ht_longISOFormatter {
    static dispatch_once_t onceLongFormatterToken;
    dispatch_once(&onceLongFormatterToken, ^{
        longISOFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [longISOFormatter setLocale:enUSPOSIXLocale];
        [longISOFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [longISOFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    });
    
    return longISOFormatter;
}

+ (NSDateFormatter *)ht_shortISOFormatter {
    static dispatch_once_t onceShortFormatterToken;
    dispatch_once(&onceShortFormatterToken, ^{
        shortISOFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [shortISOFormatter setLocale:enUSPOSIXLocale];
        [shortISOFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [shortISOFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    });
    
    return shortISOFormatter;
}

+ (NSDateFormatter *)ht_remoteLoggerFormatter {
    static dispatch_once_t onceRemoteLoggerToken;
    dispatch_once(&onceRemoteLoggerToken, ^{
        remoteLoggerFormatter = [[NSDateFormatter alloc] init];
        [remoteLoggerFormatter setDateFormat:@"MMM dd HH:mm:ss"];
        [remoteLoggerFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        remoteLoggerFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    });
    
    return remoteLoggerFormatter;
}

@end
