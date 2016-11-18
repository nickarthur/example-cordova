//
//  HTConstants.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 19/10/15.
//  Copyright © 2015 HyperTrack Inc. All rights reserved.
//

#ifndef HTConstants_h
#define HTConstants_h

#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>

#define HT_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
#define HT_DEVICE_MODEL [[UIDevice currentDevice] model]
#define HT_DEVICE_NAME [[UIDevice currentDevice] systemName]
#define HT_IDENTIFIER_FOR_VENDOR [[UIDevice currentDevice].identifierForVendor UUIDString]

///--------------------------------------
/// @name Logging Levels
///--------------------------------------

/**
 *  `HTLogLevel` enum specifies different levels of logging that could be used to limit or display more messages in logs.
 *
 *  @see [HyperTrack setLogLevel:]
 *  @see [HyperTrack logLevel]
 */
typedef NS_ENUM(uint8_t, HTLogLevel) {
    /**
     *  Log level for assert
     */
    HTLogLevelAssert = 0,
    /**
     *  Log level that disables all logging.
     */
    HTLogLevelNone = 1,
    /**
     *  Log level that if set is going to output error messages to the log.
     */
    HTLogLevelError = 2,
    /**
     *  Log level that if set is going to output the following messages to log:
     *  - Errors
     *  - Warnings
     */
    HTLogLevelWarning = 3,
    /**
     *  Log level that if set is going to output the following messages to log:
     *  - Errors
     *  - Warnings
     *  - Informational messages
     */
    HTLogLevelInfo = 4,
    /*!
     *  Log level that if set is going to output the following messages to log:
     *  - Errors
     *  - Warnings
     *  - Informational messages
     *  - Debug messages
     */
    HTLogLevelDebug = 5
};

#endif /* HTConstants_h */
