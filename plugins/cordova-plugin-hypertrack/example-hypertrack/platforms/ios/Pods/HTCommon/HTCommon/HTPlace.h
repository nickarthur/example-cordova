//
//  HTPlace.h
//  HTConsumer
//
//  Created by Ulhas Mandrawadkar on 19/01/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLocation;

@interface HTPlace : NSObject

@property (copy, nonatomic, readonly, nonnull) NSString *placeID;
@property (strong, nonatomic, readonly, nullable) HTLocation *location;
@property (copy, nonatomic, readonly, nullable) NSString *address;
@property (copy, nonatomic, readonly, nullable) NSString *landmark;
@property (copy, nonatomic, readonly, nullable) NSString *zipCode;
@property (copy, nonatomic, readonly, nullable) NSString *city;
@property (copy, nonatomic, readonly, nullable) NSString *state;
@property (copy, nonatomic, readonly, nullable) NSString *country;
@property (nonatomic, readonly, nullable) NSString *displayString;


- (instancetype _Nullable)initWithResponseObject:(NSDictionary * _Nullable)responseObject NS_DESIGNATED_INITIALIZER;
- (instancetype _Nullable)initWithLocation:(HTLocation * _Nullable)location;
- (void)updateWithResponseObject:(NSDictionary * _Nullable)responseObject;

@end
