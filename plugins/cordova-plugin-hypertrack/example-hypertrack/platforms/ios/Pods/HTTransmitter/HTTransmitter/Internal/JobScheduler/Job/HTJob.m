//
//  HTJob.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTJob.h"
#import "HTJobIDGenerator.h"

@implementation HTJob

@synthesize jobID = _jobID;
@synthesize block = _block;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.jobID = [HTJobIDGenerator getUniqueJobID];
    }
    
    return self;
}

@end
