//
//  HTLocationStats.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 12/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLocationStats : NSObject <NSCoding, NSCopying>

@property (nonatomic, readonly, copy) NSNumber *enabled;
@property (nonatomic, readonly, copy) NSNumber *permission;

+ (HTLocationStats *)currentLocationStats;

@property (nonatomic, readonly) NSDictionary *dictionaryValue;

- (HTLocationStats *)statsFromSubtractingStats:(HTLocationStats *)locationStats;
- (BOOL)isEqualToLocationStats:(HTLocationStats *)stats;

@end
