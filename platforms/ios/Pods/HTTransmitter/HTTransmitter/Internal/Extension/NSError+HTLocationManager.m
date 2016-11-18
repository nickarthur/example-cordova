//
//  NSError+HTLocationManager.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 13/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTError.h>

#import "NSError+HTLocationManager.h"

@implementation NSError (HTLocationManager)

+ (NSError *)ht_locationServicesDisabledError {
    return [NSError ht_errorForType:HTLocationError
                            message:HTLocationServicesDisabledUserMessage
                          parameter:@"locationServicesEnabled"
                          errorCode:HTLocationServiceDisabled
                    devErrorMessage:@"cannot track a trip when location services are disabled. enable location services before tracking a trip. if a trip is already started, location update for the trip will be resumed once location services are enabled."];
}

+ (NSError *)ht_locationAuthorizationError {
    return [NSError ht_errorForType:HTLocationError
                            message:HTLocationAuthorizationDeniedUserMessage
                          parameter:@"authorizationStatus"
                          errorCode:HTLocationAuthorizationDenied
                    devErrorMessage:@"cannot track a trip if location authorization is denied or restricted. authorize location before tracking a trip. if a trip is already started, location update for the trip will be resumed once location is set to proper authority."];
}

+ (NSError *)ht_infoDictionaryMissingKeyError {
    return [NSError ht_errorForType:HTLocationError
                            message:nil
                          parameter:nil
                          errorCode:HTLocationInfoDictionaryKeyMissing
                    devErrorMessage:@"cannot start trip without adding 'always usage description' or 'when is use usage description' in info.plist. Please add value for this key NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription in your info.plist"];
}

@end
