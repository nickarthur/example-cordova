//
//  HTJobScheduler_Private.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTJobScheduler.h"

@interface HTJobScheduler ()

@property (nonatomic, strong) id <HTLoggerProtocol> logger;

- (void)processJobs;
- (void)startSchedulerIfNeeded;
- (void)invalidateTimer;

@end
