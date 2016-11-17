//
//  HTDeviceStats.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/NSDictionary+Extension.h>
#import <HTCommon/HTConstants.h>
#import <HTCommon/HyperTrack.h>
#import <HTCommon/HTUtility.h>

#import "HTDeviceStats.h"

NSString * const deviceIDKey = @"device_id";
NSString * const osVersionKey = @"os_version";
NSString * const sdkVersionKey = @"sdk_version";
NSString * const htdeviceKey = @"device";
NSString * const modelKey = @"model";
NSString * const brandKey = @"brand";
NSString * const manufacturerKey = @"manufacturer";
NSString * const productKey = @"product";
NSString * const timeZoneKey = @"time_zone";

@interface HTDeviceStats ()

@property (nonatomic, copy, readwrite) NSString *deviceID;
@property (nonatomic, copy, readwrite) NSString *osVersion;
@property (nonatomic, copy, readwrite) NSString *sdkVersion;
@property (nonatomic, copy, readwrite) NSString *device;
@property (nonatomic, copy, readwrite) NSString *model;
@property (nonatomic, copy, readwrite) NSString *brand;
@property (nonatomic, copy, readwrite) NSString *manufacturer;
@property (nonatomic, copy, readwrite) NSString *product;
@property (nonatomic, copy, readwrite) NSString *timeZone;

@end

@implementation HTDeviceStats

+ (HTDeviceStats *)currentDeviceStats {
    HTDeviceStats *stats = [[HTDeviceStats alloc] init];
    
    stats.deviceID = HT_IDENTIFIER_FOR_VENDOR;
    stats.osVersion = HT_SYSTEM_VERSION;
    stats.sdkVersion = HTSDKVersion;
    stats.device = HT_DEVICE_MODEL;
    stats.model = [HTUtility deviceModel];
    stats.brand = @"apple";
    stats.manufacturer = @"apple";
    stats.product = HT_DEVICE_MODEL;
    stats.timeZone = [NSTimeZone systemTimeZone].name;
    
    return stats;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params ht_setNilSafeObject:self.deviceID forKey:deviceIDKey];
    [params ht_setNilSafeObject:self.osVersion forKey:osVersionKey];
    [params ht_setNilSafeObject:self.sdkVersion forKey:sdkVersionKey];
    [params ht_setNilSafeObject:self.device forKey:htdeviceKey];
    [params ht_setNilSafeObject:self.model forKey:modelKey];
    [params ht_setNilSafeObject:self.brand forKey:brandKey];
    [params ht_setNilSafeObject:self.manufacturer forKey:manufacturerKey];
    [params ht_setNilSafeObject:self.product forKey:productKey];
    [params ht_setNilSafeObject:self.timeZone forKey:timeZoneKey];
    
    return params;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.deviceID = [aDecoder decodeObjectForKey:deviceIDKey];
        self.osVersion = [aDecoder decodeObjectForKey:osVersionKey];
        self.sdkVersion = [aDecoder decodeObjectForKey:sdkVersionKey];
        self.device = [aDecoder decodeObjectForKey:htdeviceKey];
        self.model = [aDecoder decodeObjectForKey:modelKey];
        self.brand = [aDecoder decodeObjectForKey:brandKey];
        self.manufacturer = [aDecoder decodeObjectForKey:manufacturerKey];
        self.product = [aDecoder decodeObjectForKey:productKey];
        self.timeZone = [aDecoder decodeObjectForKey:timeZoneKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.deviceID forKey:deviceIDKey];
    [aCoder encodeObject:self.osVersion forKey:osVersionKey];
    [aCoder encodeObject:self.sdkVersion forKey:sdkVersionKey];
    [aCoder encodeObject:self.device forKey:htdeviceKey];
    [aCoder encodeObject:self.model forKey:modelKey];
    [aCoder encodeObject:self.brand forKey:brandKey];
    [aCoder encodeObject:self.manufacturer forKey:manufacturerKey];
    [aCoder encodeObject:self.product forKey:productKey];
    [aCoder encodeObject:self.timeZone forKey:timeZoneKey];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    HTDeviceStats *stats = [[HTDeviceStats alloc] init];
    
    stats.deviceID = [self.deviceID copyWithZone:zone];
    stats.osVersion = [self.osVersion copyWithZone:zone];
    stats.sdkVersion = [self.sdkVersion copyWithZone:zone];
    stats.device = [self.device copyWithZone:zone];
    stats.model = [self.model copyWithZone:zone];
    stats.brand = [self.brand copyWithZone:zone];
    stats.manufacturer = [self.manufacturer copyWithZone:zone];
    stats.product = [self.product copyWithZone:zone];
    stats.timeZone = [self.timeZone copyWithZone:zone];
    
    return stats;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DeviceID : %@, OSVersion : %@, SDKVersion : %@, Device : %@, Model : %@, Brand : %@, Manufacturer : %@, Product : %@, Timezone : %@", self.deviceID, self.osVersion, self.sdkVersion, self.device, self.model, self.brand, self.manufacturer, self.product, self.timeZone];
}

- (HTDeviceStats *)statsFromSubtractingStats:(HTDeviceStats *)deviceStats {
    if (!deviceStats) {
        return [self copy];
    }
    
    if ([self isEqualToDeviceStats:deviceStats]) {
        return nil;
    }
    
    HTDeviceStats *diff = [[HTDeviceStats alloc] init];
    
    if (![self.deviceID isEqualToString:deviceStats.deviceID]) {
        diff.deviceID = self.deviceID;
    }
    
    if (![self.osVersion isEqualToString:deviceStats.osVersion]) {
        diff.osVersion = self.osVersion;
    }
    
    if (![self.sdkVersion isEqualToString:deviceStats.sdkVersion]) {
        diff.sdkVersion = self.sdkVersion;
    }
    
    if (![self.device isEqualToString:deviceStats.device]) {
        diff.device = self.device;
    }
    
    if (![self.model isEqualToString:deviceStats.model]) {
        diff.model = self.model;
    }
    
    if (![self.brand isEqualToString:deviceStats.brand]) {
        diff.brand = self.brand;
    }
    
    if (![self.manufacturer isEqualToString:deviceStats.manufacturer]) {
        diff.manufacturer = self.manufacturer;
    }
    
    if (![self.product isEqualToString:deviceStats.product]) {
        diff.product = self.product;
    }
    
    if (![self.timeZone isEqualToString:deviceStats.timeZone]) {
        diff.timeZone = self.timeZone;
    }
    
    return diff;
}

#pragma mark - Equality

- (BOOL)isEqualToDeviceStats:(HTDeviceStats *)stats {
    if (!stats) {
        return NO;
    }
    
    BOOL haveEqualDeviceID = (!self.deviceID && !stats.deviceID) || [self.deviceID isEqualToString:stats.deviceID];
    BOOL haveEqualosVersion = (!self.osVersion && !stats.osVersion) || [self.osVersion isEqualToString:stats.osVersion];
    BOOL haveEqualSDKVersion = (!self.sdkVersion && !stats.sdkVersion) || [self.sdkVersion isEqualToString:stats.sdkVersion];
    BOOL haveEqualDevice = (!self.device && !stats.device) || [self.device isEqualToString:stats.device];
    BOOL haveEqualModel = (!self.model && !stats.model) || [self.model isEqualToString:stats.model];
    BOOL haveEqualBrand = (!self.brand && !stats.brand) || [self.brand isEqualToString:stats.brand];
    BOOL haveEqualManufacturer = (!self.manufacturer && !stats.manufacturer) || [self.manufacturer isEqualToString:stats.manufacturer];
    BOOL haveEqualProduct = (!self.product && !stats.product) || [self.product isEqualToString:stats.product];
    BOOL haveEqualTimeZone = (!self.timeZone && !stats.timeZone) || [self.timeZone isEqualToString:stats.timeZone];

    return haveEqualDeviceID && haveEqualosVersion && haveEqualSDKVersion && haveEqualDevice && haveEqualModel && haveEqualBrand && haveEqualManufacturer && haveEqualProduct && haveEqualTimeZone;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[HTDeviceStats class]]) {
        return NO;
    }
    
    return [self isEqualToDeviceStats:(HTDeviceStats *)object];
}

- (NSUInteger)hash {
    return self.deviceID.hash ^ self.osVersion.hash ^ self.sdkVersion.hash ^ self.device.hash ^ self.model.hash ^ self.brand.hash ^ self.manufacturer.hash ^ self.product.hash ^ self.product.hash;
}

@end
