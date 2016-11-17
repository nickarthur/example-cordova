//
//  HTError.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 11/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  `HTErrorCode` enum specifies different types of error codes that NSError in `HTErrorDomain` can have.
 *
 */
typedef NS_ENUM(NSUInteger, HTErrorCode) {
    /**
     *  Trouble connecting to HyperTrack.
     */
    HTConnectionError = 10,
    /**
     *  Your request had invalid parameters.
     */
    HTInvalidRequestError = 20,
    /**
     *  General-purpose API error (should be rare).
     */
    HTAPIError = 30,
    /**
     *  Something was wrong with location (most common).
     */
    HTLocationError = 40,
    /**
     *  Something was wrong with usage of the SDK.
     */
    HTUsageError = 50,
    /**
     *  Something was wrong with usage of the SDK.
     */
    HTDatabaseError = 60,
};

FOUNDATION_EXPORT NSString * const _Nonnull HTErrorDomain;

// A developer-friendly error message that explains what went wrong. You probably
// shouldn't show this to your users, but might want to use it yourself.
FOUNDATION_EXPORT NSString * _Nonnull const HTErrorMessageKey;

// What went wrong with your API call (e.g., HTInvalidTripID. See below for full list).
FOUNDATION_EXPORT NSString * _Nonnull const HTErrorCodeKey;

// Which parameter in the API had an error (e.g., "orderID"). Useful for marking up the
// right UI element.
FOUNDATION_EXPORT NSString * _Nonnull const HTErrorParameterKey;

// (Usually determined locally)
FOUNDATION_EXPORT NSString * _Nonnull const HTInvalidState;
FOUNDATION_EXPORT NSString * _Nonnull const HTInvalidCoordinate;
FOUNDATION_EXPORT NSString * _Nonnull const HTLocationServiceDisabled;
FOUNDATION_EXPORT NSString * _Nonnull const HTLocationAuthorizationDenied;
FOUNDATION_EXPORT NSString * _Nonnull const HTLocationInfoDictionaryKeyMissing;
FOUNDATION_EXPORT NSString * _Nonnull const HTLocationServiceTimedout;
FOUNDATION_EXPORT NSString * _Nonnull const HTLocationServiceUnkownError;
FOUNDATION_EXPORT NSString * _Nonnull const HTSQLiteDatabaseInvalidSQL;
FOUNDATION_EXPORT NSString * _Nonnull const HTNetworkRequestTimedOut;
FOUNDATION_EXPORT NSString * _Nonnull const HTNetworkNotReachable;

#pragma mark Strings

#define HTLocationServicesDisabledUserMessage NSLocalizedString(@"Please verify location services. Have you enabled location services?", @"Error when the location services of the phone/app is disabled")
#define HTLocationAuthorizationDeniedUserMessage NSLocalizedString(@"Please verify the location authorization. Have you authorized the application to use location services.", @"Error when the location authorization of the app is denied")


@interface NSError (HyperTrack)

@property (nonatomic, assign, readonly, getter=isNetworkError) BOOL networkError;

+ (NSError * _Nonnull)ht_errorForType:(HTErrorCode)type
                              message:(NSString * _Nullable)userMessage
                            parameter:(NSString * _Nullable)parameter
                            errorCode:(NSString * _Nullable)errorCode
                      devErrorMessage:(NSString * _Nullable)devMessage;

@end
