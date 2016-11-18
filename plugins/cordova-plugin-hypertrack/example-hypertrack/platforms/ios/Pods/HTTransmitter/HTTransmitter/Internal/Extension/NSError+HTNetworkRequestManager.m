//
//  NSError+HTNetworkRequestManager.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 18/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTError.h>

#import "NSError+HTNetworkRequestManager.h"

@implementation NSError (HTNetworkRequestManager)

+ (NSError *)errorForRequestTimeout {
    NSError *error = [NSError ht_errorForType:HTConnectionError
                                      message:nil
                                    parameter:nil
                                    errorCode:HTNetworkRequestTimedOut
                              devErrorMessage:@"Request Timed out."];
    
    return error;
}

+ (NSError *)errorForNetworkOutage {
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
    return error;
}

@end
