//
//  HTDriverStatsCollector.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTDriverStats.h"
#import "HTDriverStatsCollector.h"

static NSString * const HTLastRecordedStats = @"io.hypertrack.transmitter:HTLastRecordedStats";

@interface HTDriverStatsCollector ()

@property (nonatomic, copy) NSString *driverID;
@property (nonatomic, strong, readwrite) NSArray <HTDriverStats *> *driverStats;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) HTReachability *reachability;

@property (nonatomic) HTDriverStats *lastRecordedStats;

@end

@implementation HTDriverStatsCollector

- (instancetype)init {
    self = [super init];
    if (self) {
        self.driverStats = @[];
    }
    
    return self;
}

- (void)dealloc {
    [self invalidateTimer];
}

- (void)startCollectingStatsForDriverID:(NSString *)driverID timeInterval:(NSTimeInterval)timeInterval reachability:(HTReachability *)reachability {
    if (!self.timer) {
        [self startTimerForTimeInterval:timeInterval];
        self.driverID = driverID;
        self.reachability = reachability;
    }
}

- (void)updateTimeInterval:(NSTimeInterval)timeInterval {
    [self collectStats];
    [self startTimerForTimeInterval:timeInterval];
}

- (void)startTimerForTimeInterval:(NSTimeInterval)timeInterval {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self invalidateTimer];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                      target:self
                                                    selector:@selector(collectStats)
                                                    userInfo:nil
                                                     repeats:YES];
    });
}

- (void)collectStats {
    NSMutableArray <HTDriverStats *> *driverStats = [NSMutableArray arrayWithArray:self.driverStats];
    
    HTDriverStats *currentDriverStats = [HTDriverStats currentDriverStatsForDriverID:self.driverID reachability:self.reachability];
    HTDriverStats *difference = [currentDriverStats statsFromSubtractingStats:self.lastRecordedStats];
    self.lastRecordedStats = currentDriverStats;
    
    [driverStats addObject:difference];
    self.driverStats = driverStats;
}

- (void)stopCollectingStats {
    self.driverID = nil;
    self.driverStats = @[];
    [self clearLastRecordedStats];
    [self invalidateTimer];
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)addStats:(NSArray<HTDriverStats *> *)driverStats {
    NSMutableArray <HTDriverStats *> *stats = [NSMutableArray arrayWithArray:self.driverStats];
    [stats arrayByAddingObjectsFromArray:driverStats];
    self.driverStats = stats;
}

- (NSArray <HTDriverStats *> *)flushDriverStats {
    NSArray <HTDriverStats *> *driverStats = self.driverStats.copy;
    self.driverStats = @[];
    return driverStats;
}

- (NSArray <NSDictionary *> *)paramsForDriverStats:(NSArray<HTDriverStats *> *)driverStats {
    NSMutableArray *params = [[NSMutableArray alloc] init];
    
    for (HTDriverStats *stats in driverStats) {
        [params addObject:stats.dictionaryValue];
    }
    
    return params;
}

- (void)setLastRecordedStats:(HTDriverStats *)currentStats {
    if (!currentStats) {
        return;
    }
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:currentStats];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedObject forKey:HTLastRecordedStats];
}

- (HTDriverStats *)lastRecordedStats {
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] valueForKey:HTLastRecordedStats];
    if (!encodedObject) {
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}

- (void)clearLastRecordedStats {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:HTLastRecordedStats];
}

@end
