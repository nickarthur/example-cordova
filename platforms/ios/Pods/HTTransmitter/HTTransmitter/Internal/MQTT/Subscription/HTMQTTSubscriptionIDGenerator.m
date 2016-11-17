//
//  HTMQTTSubscriptionIDGenerator.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 06/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTMQTTSubscriptionIDGenerator.h"

static HTMQTTSubscriptionID _nextSubscriptionID = 0;

@implementation HTMQTTSubscriptionIDGenerator

+ (HTMQTTSubscriptionID)getUniqueSubscriptionID {
    _nextSubscriptionID++;
    return _nextSubscriptionID;
}

@end
