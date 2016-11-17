//
//  HTNetworkJobScheduler.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTLoggerProtocol.h>

#import "HTReachability.h"
#import "HTNetworkJobScheduler.h"
#import "HTJobScheduler_Private.h"

@interface HTNetworkJobScheduler ()

@property (nonatomic, strong) HTReachability *reachability;

@end

@implementation HTNetworkJobScheduler

- (instancetype)initWithLogger:(id<HTLoggerProtocol>)logger {
    return [self initWithReachability:nil logger:nil];
}

- (instancetype)initWithReachability:(HTReachability *)reachability logger:(id<HTLoggerProtocol>)logger {
    self = [super initWithLogger:logger];
    if (self) {
        self.reachability = reachability;
    }
    
    return self;
}

@end
