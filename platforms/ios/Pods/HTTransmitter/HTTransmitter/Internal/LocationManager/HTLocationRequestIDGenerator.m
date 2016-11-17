//
//  HTLocationRequestIDGenerator.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 10/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTLocationRequestIDGenerator.h"

static HTLocationRequestID _nextRequestID = 0;

@implementation HTLocationRequestIDGenerator

+ (HTLocationRequestID)getUniqueRequestID {
    _nextRequestID++;
    return _nextRequestID;
}

@end
