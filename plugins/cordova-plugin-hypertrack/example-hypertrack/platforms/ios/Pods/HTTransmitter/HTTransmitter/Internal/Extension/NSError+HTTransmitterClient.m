//
//  NSError+HTTransmitterClient.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 11/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "NSError+HTTransmitterClient.h"
#import <HTCommon/HTError.h>

@implementation NSError (HTTransmitterClient)

+ (NSError *)driverIDMissingError {
    NSError *error = [NSError ht_errorForType:HTUsageError
                                      message:nil
                                    parameter:nil
                                    errorCode:HTInvalidState
                              devErrorMessage:@"DriverID is required. Please provide a driverID before continuing."];
    
    return error;
}

+ (NSError *)locationServiceActiveForDifferentDriverError {
    NSError *error = [NSError ht_errorForType:HTLocationError
                                      message:nil
                                    parameter:nil
                                    errorCode:HTInvalidState
                              devErrorMessage:@"Trips/Tasks are active for a different driver. Please end active trips/tasks before continuing."];
    
    return error;
}

+ (NSError *)locationServiceTimeoutError {
    NSError *error = [NSError ht_errorForType:HTLocationError
                                      message:nil
                                    parameter:nil
                                    errorCode:HTLocationServiceTimedout
                              devErrorMessage:@"Location service timed out. Try again."];
    
    return error;
}

+ (NSError *)locationStatusError {
    NSError *error = [NSError ht_errorForType:HTLocationError
                                      message:nil
                                    parameter:nil
                                    errorCode:HTLocationServiceUnkownError
                              devErrorMessage:@"Location service unknown error. Try again."];
    
    return error;
}

+ (NSError *)noActiveShiftError {
    NSError *error = [NSError ht_errorForType:HTUsageError
                                      message:nil
                                    parameter:nil
                                    errorCode:HTInvalidState
                              devErrorMessage:@"No shift is active. Cannot end shift."];
    
    return error;
}

+ (NSError *)noActiveTripError {
    NSError *error = [NSError ht_errorForType:HTUsageError
                                      message:nil
                                    parameter:nil
                                    errorCode:HTInvalidState
                              devErrorMessage:@"No trip is active. Cannot end trip."];
    
    return error;
}

+ (NSError *)errorForLocationStatus:(HTLocationStatus)status {
    NSError *error;
    
    switch (status) {
        case HTLocationStatusTimedOut:
            error = [NSError locationServiceTimeoutError];
            break;
            
        default:
            error = [NSError locationStatusError];
            break;
    }
    
    return error;
}

@end
