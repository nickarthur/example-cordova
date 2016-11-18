//
//  HTNetworkJobScheduler.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTJobScheduler.h"

@interface HTNetworkJobScheduler : HTJobScheduler

- (instancetype)initWithReachability:(HTReachability *)reachability logger:(id<HTLoggerProtocol>)logger NS_DESIGNATED_INITIALIZER;

@end
