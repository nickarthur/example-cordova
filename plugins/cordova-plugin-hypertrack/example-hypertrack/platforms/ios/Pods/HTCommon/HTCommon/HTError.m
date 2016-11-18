//
//  HTError.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 11/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import "NSDictionary+Extension.h"
#import "HTError.h"

NSString * const HTErrorDomain = @"io.hypertrack.lib";

NSString * const HTErrorCodeKey = @"io.hypertrack.lib:ErrorCodeKey";
NSString * const HTErrorMessageKey = @"io.hypertrack.lib:ErrorMessageKey";
NSString * const HTErrorParameterKey = @"io.hypertrack.lib:ErrorParameterKey";

NSString * const HTInvalidState = @"io.hypertrack.lib:InvalidState";
NSString * const HTInvalidCoordinate = @"io.hypertrack.lib:InvalidCoordinate";
NSString * const HTLocationServiceDisabled = @"io.hypertrack.lib:LocationServicesDisabled";
NSString * const HTLocationAuthorizationDenied = @"io.hypertrack.lib:LocationAuthorizationDenied";
NSString * const HTLocationInfoDictionaryKeyMissing = @"io.hypertrack.lib:LocationInfoDictionaryKeyMissing";
NSString * const HTLocationServiceTimedout = @"io.hypertrack.lib:LocationServiceTimedout";
NSString * const HTLocationServiceUnkownError = @"io.hypertrack.lib:LocationServiceUnknownError";
NSString * const HTSQLiteDatabaseInvalidSQL = @"io.hypertrack.lib:HTSQLiteDatabaseInvalidSQL";
NSString * const HTNetworkRequestTimedOut = @"io.hypertrack.lib:HTNetworkRequestTimedOut";
NSString * const HTNetworkNotReachable = @"io.hypertrack.lib:HTNetworkNotReachable";

@implementation NSError (HyperTrack)

+ (NSError *)ht_errorForType:(HTErrorCode)type
                     message:(NSString *)userMessage
                   parameter:(NSString *)parameter
                   errorCode:(NSString *)errorCode
             devErrorMessage:(NSString *)devMessage {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo ht_setNilSafeObject:userMessage forKey:NSLocalizedDescriptionKey];
    [userInfo ht_setNilSafeObject:parameter forKey:HTErrorParameterKey];
    [userInfo ht_setNilSafeObject:errorCode forKey:HTErrorCodeKey];
    [userInfo ht_setNilSafeObject:devMessage forKey:HTErrorMessageKey];
    
    if (userInfo.count == 0) {
        userInfo = nil;
    }
    
    return [[NSError alloc] initWithDomain:HTErrorDomain
                                      code:type
                                  userInfo:userInfo];
}

- (BOOL)isNetworkError {
    if (![self.domain isEqualToString:NSURLErrorDomain]) {
        return NO;
    }
    
    return (self.code == NSURLErrorNotConnectedToInternet
            || self.code == NSURLErrorInternationalRoamingOff
            || self.code == NSURLErrorCallIsActive
            || self.code == NSURLErrorDataNotAllowed);
}

@end
