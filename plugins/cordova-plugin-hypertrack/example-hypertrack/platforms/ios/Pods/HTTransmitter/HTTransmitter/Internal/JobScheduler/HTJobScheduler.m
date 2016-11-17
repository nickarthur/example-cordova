//
//  HTJobScheduler.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTLoggerProtocol.h>
#import <HTCommon/HTBlocks.h>

#import "HTJobScheduler_Private.h"
#import "HTJobScheduler.h"
#import "HTJob.h"

@interface HTJobScheduler ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval schedule;
@property (nonatomic, assign) BOOL scheduled;

@property (nonatomic, strong) NSDictionary <NSNumber *, id<HTJobProtocol>> *jobs;

@end

const NSTimeInterval DefaultSchedule = 60.0f;

@implementation HTJobScheduler

- (instancetype)initWithLogger:(id<HTLoggerProtocol>)logger {
    self = [super init];
    if (self) {
        self.jobs = @{};
        self.schedule = DefaultSchedule;
        self.logger = logger;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithLogger:nil];
}

- (HTJobID)subscribe:(HTJobBlock)block {
    [self.logger info:@"Subscribing job"];
    
    HTJob *job = [[HTJob alloc] init];
    job.block = block;
    
    [self.logger debug:@"Subscribed JobID : %@", @(job.jobID)];
    
    [self addJob:job];
    return job.jobID;
}

- (void)processJobs {
    [self.logger info:@"Processing jobs"];
    
    for (id <HTJobProtocol> job in self.jobs.allValues) {
        InvokeBlock(job.block, job);
    }
}

- (void)update:(NSTimeInterval)schedule {
    [self processJobs];
    self.schedule = schedule;
    [self invalidateTimer];
    [self startSchedulerIfNeeded];
}

- (void)resetSchedule {
    [self update:DefaultSchedule];
}

#pragma mark - Add/Removing Job Methods

- (void)addJob:(id <HTJobProtocol>)job {
    if (!job) {
        [self.logger info:@"Job is nil. Aborting"];
        return;
    }
    
    NSMutableDictionary <NSNumber *, id <HTJobProtocol>> *newJobs = [NSMutableDictionary dictionaryWithDictionary:self.jobs];
    [newJobs setObject:job forKey:@(job.jobID)];
    self.jobs = newJobs;
    
    [self startSchedulerIfNeeded];
}

- (void)complete:(HTJobID)jobID {
    [self.logger info:@"Completing Job : %@", @(jobID)];
    
    if (![self.jobs objectForKey:@(jobID)]) {
        [self.logger info:@"JobID doesn't exist. Aborting"];
        return;
    }
    
    NSMutableDictionary <NSNumber *, id <HTJobProtocol>> *newJobs = [NSMutableDictionary dictionaryWithDictionary:self.jobs];
    [newJobs removeObjectForKey:@(jobID)];
    self.jobs = newJobs;
    
    [self stopSchedulerIfNeeded];
}

#pragma mark - Scheduling Methods

- (void)stopSchedulerIfNeeded {
    if (self.jobs.count == 0) {
        [self invalidateTimer];
        if (self.scheduled) {
            [self.logger info:@"Job Scheduler unscheduled"];
        }
        self.scheduled = NO;
    }
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startSchedulerIfNeeded {
    if (self.jobs.count > 0) {
        [self startTimer];
        if (!self.scheduled) {
            [self.logger info:@"Job Scheduler scheduled"];
        }
        self.scheduled = YES;
    }
}

- (void)startTimer {
    if (self.timer) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self invalidateTimer];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.schedule target:self selector:@selector(processJobs) userInfo:nil repeats:YES];
    });
}

@end
