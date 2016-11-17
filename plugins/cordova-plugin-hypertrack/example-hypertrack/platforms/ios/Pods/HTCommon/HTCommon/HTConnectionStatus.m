//
//  HTConnectionStatus.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 26/07/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTConnectionStatus.h"

NSString * const HTDriverConnectionStatusHealthyString = @"connection_healthy";
NSString * const HTDriverConnectionStatusLostString = @"connection_lost";

@implementation HTConnectionStatus

+ (NSString *)stringValueForConnectionStatus:(HTDriverConnectionStatus)connectionStatus {
    NSString *connectionStatusString;
    
    switch (connectionStatus) {
        case HTDriverConnectionStatusHealthy:
            connectionStatusString = HTDriverConnectionStatusHealthyString;
            break;
            
        case HTDriverConnectionStatusLost:
            connectionStatusString = HTDriverConnectionStatusLostString;
            break;
    }
    
    return connectionStatusString;
}

+ (HTDriverConnectionStatus)connectionStatusForStringValue:(NSString *)connectionTypeString {
    HTDriverConnectionStatus connectionStatus = HTDriverConnectionStatusHealthy;
    
    if ([connectionTypeString isEqualToString:HTDriverConnectionStatusLostString]) {
        connectionStatus = HTDriverConnectionStatusLost;
    }
    
    return connectionStatus;
}

@end
