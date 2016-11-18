//
//  HTGPSLog.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 12/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLocation;

@interface HTGPSLog : NSObject

@property (copy, nonatomic, readonly, nullable) NSString *logID;
@property (strong, nonatomic, readonly, nullable) NSDate *recordedAt;
@property (assign, nonatomic, readonly) double bearing;
@property (assign, nonatomic, readonly) double speed;
@property (assign, nonatomic, readonly) double altitude;
@property (assign, nonatomic, readonly) double locationAccuracy;
@property (strong, nonatomic, readonly, nullable) HTLocation *location;

@property (nonatomic, readonly, nonnull) NSDictionary *dictionaryValue;

- (instancetype _Nullable)initWithResponseObject:(NSDictionary * _Nullable)responseObject NS_DESIGNATED_INITIALIZER;
- (instancetype _Nullable)initWithTimedLocation:(NSArray * _Nonnull)timedLocation;

- (void)updateWithResponseObject:(NSDictionary * _Nullable)responseObject;

- (BOOL)isEqualToLog:(HTGPSLog * _Nullable)log;

@end
