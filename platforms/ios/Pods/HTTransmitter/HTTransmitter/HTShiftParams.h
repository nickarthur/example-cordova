//
//  HTShiftParams.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 11/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  `HTShiftParams` is representation of the parameters required to start a shift.
 */
@interface HTShiftParams : NSObject <NSCoding>

/**
 *  The driver ID number for the driver who is starting the shift.
 */
@property (nonatomic, copy, nullable) NSString *driverID;

/**
 *  Dictionary value of the object. Will be used in API calls as parameter.
 */
@property (nonatomic, readonly, nullable) NSDictionary *dictionaryValue;

@end