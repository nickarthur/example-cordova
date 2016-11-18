//
//  HTDeviceStats.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDeviceStats : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readonly) NSString *deviceID;
@property (nonatomic, copy, readonly) NSString *osVersion;
@property (nonatomic, copy, readonly) NSString *sdkVersion;
@property (nonatomic, copy, readonly) NSString *device;
@property (nonatomic, copy, readonly) NSString *model;
@property (nonatomic, copy, readonly) NSString *brand;
@property (nonatomic, copy, readonly) NSString *manufacturer;
@property (nonatomic, copy, readonly) NSString *product;
@property (nonatomic, copy, readonly) NSString *timeZone;

@property (nonatomic, readonly) NSDictionary *dictionaryValue;

+ (HTDeviceStats *)currentDeviceStats;

- (HTDeviceStats *)statsFromSubtractingStats:(HTDeviceStats *)deviceStats;
- (BOOL)isEqualToDeviceStats:(HTDeviceStats *)stats;

@end
