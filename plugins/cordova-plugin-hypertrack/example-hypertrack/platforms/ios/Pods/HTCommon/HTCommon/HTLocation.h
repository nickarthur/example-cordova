//
//  HTLocation.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 28/08/15.
//  Copyright (c) 2015 HyperTrack Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HTLocation : NSObject <NSCoding>

@property (copy, nonatomic, readonly, nullable) NSString *type;
@property (strong, nonatomic, readonly, nullable) CLLocation *location;
@property (strong, nonatomic, readonly, nullable) NSArray <NSString *> *activities;
@property (strong, nonatomic, readonly, nullable) NSNumber *activityConfidence;

@property (nonatomic, readonly, nonnull) NSDictionary *dictionaryValue;
@property (nonatomic, readonly, nonnull) NSDictionary *locationDictionaryValue;

- (_Nullable instancetype)initWithResponseObject:(NSDictionary * _Nullable)responseObject NS_DESIGNATED_INITIALIZER;
- (_Nullable instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (_Nullable instancetype)initWithLocation:(CLLocation * _Nullable)location;

- (void)updateWithResponseObject:(NSDictionary * _Nullable)responseObject;
- (void)updateWithActivities:(NSArray <NSString *> * _Nullable)activities andConfidence:(NSUInteger)confidence;

@end
