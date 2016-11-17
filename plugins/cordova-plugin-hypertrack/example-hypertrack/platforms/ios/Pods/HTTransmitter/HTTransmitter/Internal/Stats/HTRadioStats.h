//
//  HTRadioStats.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTReachability;

@interface HTRadioStats : NSObject <NSCoding, NSCopying>

@property (nonatomic, readonly, copy) NSString *network;
@property (nonatomic, readonly, copy) NSString *state;

+ (HTRadioStats *)currentRadioStats:(HTReachability *)reachability;

@property (nonatomic, readonly) NSDictionary *dictionaryValue;

- (HTRadioStats *)statsFromSubtractingStats:(HTRadioStats *)radioStats;
- (BOOL)isEqualToRadioStats:(HTRadioStats *)stats;

@end
