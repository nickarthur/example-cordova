//
//  HTJobIDGenerator.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTJobIDGenerator.h"

static HTJobID _nextJobID = 0;

@implementation HTJobIDGenerator

+ (HTJobID)getUniqueJobID {
    _nextJobID++;
    return _nextJobID;
}

@end
