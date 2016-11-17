//
//  HTLogger.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 14/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import "HTConstants.h"
#import "NSDate+Extention.h"
#import "NSDateFormatter+HTExtension.h"
#import "HyperTrack.h"
#import "HTLogDataSource.h"

#import "HTLogger.h"

static HTLogLevel LogLevel = HTLogLevelWarning;

@interface HTLogger ()

@property (strong, nonatomic) id <HTLogDataSource> dataSource;
@property (strong, nonatomic) NSString *userAgent;

@end

@implementation HTLogger

///--------------------------------------
#pragma mark - Class
///--------------------------------------

+ (NSString *)_descriptionForLogLevel:(HTLogLevel)logLevel {
    NSString *description = nil;
    switch (logLevel) {
        case HTLogLevelNone:
            description = @"NONE";
            break;
        case HTLogLevelDebug:
            description = @"DEBUG";
            break;
        case HTLogLevelError:
            description = @"ERROR";
            break;
        case HTLogLevelWarning:
            description = @"WARN";
            break;
        case HTLogLevelInfo:
            description = @"INFO";
            break;
        case HTLogLevelAssert:
            description = @"ASSERT";
            break;
    }
    return description;
}

+ (void)setLogLevel:(HTLogLevel)logLevel {
    LogLevel = logLevel;
}

+ (HTLogLevel)logLevel {
    return LogLevel;
}

///--------------------------------------
#pragma mark - Init
///--------------------------------------

- (instancetype)init {
    return [self initWithDataSource:nil userAgent:@"HyperTrackSDK"];
}

- (instancetype)initWithDataSource:(id<HTLogDataSource>)dataSource userAgent:(NSString *)userAgent {
    self = [super init];
    if (self) {
        signal(SIGPIPE, SIG_IGN);
        self.dataSource = dataSource;
        self.userAgent = userAgent;
    }
    
    return self;
}

///--------------------------------------
#pragma mark - Logging Messages
///--------------------------------------

- (void)logMessageWithLevel:(HTLogLevel)level
                     format:(NSString *)format
                       args:(va_list)args {
    if (!format) {
        return;
    }
    
    NSMutableString *message = [NSMutableString stringWithFormat:@"[%@]", [[self class] _descriptionForLogLevel:level]];
    [message appendFormat:@": %@", format];
    NSString *formattedMessage = [[NSString alloc] initWithFormat:message arguments:args];
    
    NSString *logMessage = [self formattedMessage:formattedMessage];
    [self.dataSource logMessage:logMessage];
    
    if (level > LogLevel || level <= HTLogLevelNone) {
        return;
    }
    
    NSLog(@"%@", formattedMessage);
}

- (NSString *)formattedMessage:(NSString *)message {
    NSString *device = [HT_DEVICE_MODEL stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *osVersion = HT_SYSTEM_VERSION;
    
    NSString *publishableKey = [HyperTrack publishableKey];
    if (!publishableKey || publishableKey.length == 0) {
        publishableKey = @"NONE";
    }
    
    NSString *deviceUUID = HT_IDENTIFIER_FOR_VENDOR;
    NSString *timestamp = [[NSDateFormatter ht_remoteLoggerFormatter] stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%@ %@/%@ %@: %@-%@ | %@ | %@", timestamp, self.userAgent, HTSDKVersion, publishableKey, device, osVersion, deviceUUID, message];
}

///--------------------------------------
#pragma mark - Logger Protocol Messages
///--------------------------------------

- (void)assert:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);
    [self logMessageWithLevel:HTLogLevelAssert format:format args:args];
    va_end(args);
}

- (void)error:(NSString * _Nullable)format, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);
    [self logMessageWithLevel:HTLogLevelError format:format args:args];
    va_end(args);
}

- (void)warn:(NSString * _Nullable)format, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);
    [self logMessageWithLevel:HTLogLevelWarning format:format args:args];
    va_end(args);
}

- (void)info:(NSString * _Nullable)format, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);
    [self logMessageWithLevel:HTLogLevelInfo format:format args:args];
    va_end(args);
}

- (void)debug:(NSString * _Nullable)format, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);
    [self logMessageWithLevel:HTLogLevelDebug format:format args:args];
    va_end(args);
}

@end
