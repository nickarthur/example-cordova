//
//  HTMQTTDefines.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 06/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTMQTTDefines_h
#define HTMQTTDefines_h

#import <Foundation/Foundation.h>

typedef void(^HTSocketMessageBlock)(id responseObject, NSError *error);

/** A unique ID that corresponds to one mqtt subscription. */
typedef NSInteger HTMQTTSubscriptionID;

#endif /* HTMQTTDefines_h */
