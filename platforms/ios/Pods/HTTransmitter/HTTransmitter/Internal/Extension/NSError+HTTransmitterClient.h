//
//  NSError+HTTransmitterClient.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 11/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLocationManagerDefines.h"

@interface NSError (HTTransmitterClient)

+ (NSError *)driverIDMissingError;
+ (NSError *)driverIDActiveError;
+ (NSError *)locationServiceActiveForDifferentDriverError;
+ (NSError *)errorForLocationStatus:(HTLocationStatus)status;
+ (NSError *)noActiveShiftError;
+ (NSError *)noActiveTripError;

@end
