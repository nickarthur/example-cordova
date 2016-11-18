//
//  HTResponse.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 25/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  `HTResponse` is the representation of the response received when making an API call from `HTTransmitterClient`
 */
@interface HTResponse <T> : NSObject

/**
 *  Represents if the response is returned when the network was offline. The request will be queued and tried whenever the network comes back online.
 **/
@property (nonatomic, readonly, assign) BOOL offline;

/**
 *  Represents the binding for the type of object returned from the API call.
 **/
@property (nonatomic, readonly, strong) T result;

@end

