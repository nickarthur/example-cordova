//
//  HTRadioStats.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTReachability.h"
#import <HTCommon/NSDictionary+Extension.h>

#import "HTRadioStats.h"

NSString * const networkKey = @"network";
NSString * const stateKey = @"state";

@interface HTRadioStats ()

@property (nonatomic, readwrite, copy) NSString *network;
@property (nonatomic, readwrite, copy) NSString *state;

@end

@implementation HTRadioStats

+ (HTRadioStats *)currentRadioStats:(HTReachability *)reachability {
    HTRadioStats *radioStats = [[HTRadioStats alloc] init];
    
    radioStats.network = [self networkForReachability:reachability];
    radioStats.state = [self stateForReachability:reachability];
    
    return radioStats;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params ht_setNilSafeObject:self.network forKey:networkKey];
    [params ht_setNilSafeObject:self.state forKey:stateKey];
    
    return params;
}

+ (NSString *)networkForReachability:(HTReachability *)reachability {
    NSString *network;
    
    switch (reachability.currentReachabilityStatus) {
        case ReachableViaWiFi:
            network = @"WIFI";
            break;
            
        case ReachableViaWWAN:
            network = @"CELLULAR";
            break;
            
        default:
            network = @"UNKNOWN";
            break;
    }
    
    return network;
}

+ (NSString *)stateForReachability:(HTReachability *)reachability {
    NSString *state;
    
    switch (reachability.currentReachabilityStatus) {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            state = @"CONNECTED";
            break;
            
        default:
            state = @"DISCONNECTED";
            break;
    }
    
    return state;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.network = [aDecoder decodeObjectForKey:networkKey];
        self.state = [aDecoder decodeObjectForKey:stateKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.network forKey:networkKey];
    [aCoder encodeObject:self.state forKey:stateKey];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    HTRadioStats *stats = [[HTRadioStats alloc] init];
    
    stats.network = [self.network copyWithZone:zone];
    stats.state = [self.state copyWithZone:zone];
    
    return stats;
}

- (HTRadioStats *)statsFromSubtractingStats:(HTRadioStats *)radioStats {
    if (!radioStats) {
        return [self copy];
    }
    
    if ([self isEqualToRadioStats:radioStats]) {
        return nil;
    }
    
    HTRadioStats *diff = [[HTRadioStats alloc] init];
    
    if (![self.network isEqualToString:radioStats.network]) {
        diff.network = self.network;
    }
    
    if (![self.state isEqualToString:radioStats.state]) {
        diff.state = self.state;
    }
    
    return diff;
}

#pragma mark - Equality

- (BOOL)isEqualToRadioStats:(HTRadioStats *)stats {
    if (!stats) {
        return NO;
    }
    
    BOOL haveEqualNetwork = (!self.network && !stats.network) || [self.network isEqualToString:stats.network];
    BOOL haveEqualState = (!self.state && !stats.state) || [self.state isEqualToString:stats.state];
    
    return haveEqualNetwork && haveEqualState;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[HTRadioStats class]]) {
        return NO;
    }
    
    return [self isEqualToRadioStats:(HTRadioStats *)object];
}

- (NSUInteger)hash {
    return self.network.hash ^ self.state.hash;
}

@end
