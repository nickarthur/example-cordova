//
//  HTMQTTSubscriptionIDGenerator.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 06/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMQTTDefines.h"

@interface HTMQTTSubscriptionIDGenerator : NSObject

+ (HTMQTTSubscriptionID)getUniqueSubscriptionID;

@end
