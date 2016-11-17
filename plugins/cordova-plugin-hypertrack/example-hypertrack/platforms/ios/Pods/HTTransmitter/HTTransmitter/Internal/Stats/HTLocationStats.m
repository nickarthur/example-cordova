//
//  HTLocationStats.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/NSDictionary+Extension.h>

#import "HTLocationManager.h"
#import "HTLocationStats.h"

NSString * const enabledKey = @"enabled";
NSString * const permissionKey = @"permission";

@interface HTLocationStats ()

@property (nonatomic, readwrite, copy) NSNumber *enabled;
@property (nonatomic, readwrite, copy) NSNumber *permission;

@end

@implementation HTLocationStats

+ (HTLocationStats *)currentLocationStats {
    HTLocationStats *stats = [[HTLocationStats alloc] init];
    
    stats.enabled = [NSNumber numberWithBool:[HTLocationManager locationEnabled]];
    stats.permission = [NSNumber numberWithBool:[HTLocationManager permissionEnabled]];
    
    return stats;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params ht_setNilSafeObject:self.enabled forKey:enabledKey];
    [params ht_setNilSafeObject:self.permission forKey:permissionKey];
    
    return params;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.enabled = [aDecoder decodeObjectForKey:enabledKey];
        self.permission = [aDecoder decodeObjectForKey:permissionKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.enabled forKey:enabledKey];
    [aCoder encodeObject:self.permission forKey:permissionKey];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    HTLocationStats *stats = [[HTLocationStats alloc] init];
    
    stats.enabled = [self.enabled copyWithZone:zone];
    stats.permission = [self.permission copyWithZone:zone];
    
    return stats;
}

- (HTLocationStats *)statsFromSubtractingStats:(HTLocationStats *)locationStats {
    if (!locationStats) {
        return [self copy];
    }
    
    if ([self isEqualToLocationStats:locationStats]) {
        return nil;
    }
    
    HTLocationStats *diff = [[HTLocationStats alloc] init];
    
    if (![self.enabled isEqualToNumber:locationStats.enabled]) {
        diff.enabled = self.enabled;
    }
    
    if (![self.permission isEqualToNumber:locationStats.permission]) {
        diff.permission = self.permission;
    }
    
    return diff;
}

#pragma mark - Equality

- (BOOL)isEqualToLocationStats:(HTLocationStats *)stats {
    if (!stats) {
        return NO;
    }
    
    BOOL haveEqualEnabled = (!self.enabled && !stats.enabled) || [self.enabled isEqualToNumber:stats.enabled];
    BOOL haveEqualPermission = (!self.permission && !stats.permission) || [self.permission isEqualToNumber:stats.permission];
    
    return haveEqualEnabled && haveEqualPermission;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[HTLocationStats class]]) {
        return NO;
    }
    
    return [self isEqualToLocationStats:(HTLocationStats *)object];
}

- (NSUInteger)hash {
    return self.permission.hash ^ self.enabled.hash;
}

@end
