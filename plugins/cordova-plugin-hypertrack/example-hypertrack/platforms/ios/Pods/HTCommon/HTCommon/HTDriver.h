//
//  HTDriver.h
//  HTConsumer
//
//  Created by Ulhas Mandrawadkar on 19/01/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTVehicleType.h"
#import "HTBlocks.h"

@class HTLocation;
@class UIImage;
@class HTGPSLog;

@interface HTDriver : NSObject

@property (copy, nonatomic, readonly, nullable) NSString *driverID;
@property (copy, nonatomic, readonly, nullable) NSString *name;
@property (copy, nonatomic, readonly, nullable) NSString *phoneNumber;
@property (copy, nonatomic, readonly, nullable) NSURL *photoURL;
@property (strong, nonatomic, readonly, nullable) UIImage *image;
@property (assign, nonatomic, readonly) HTDriverVehicleType vehicleType;
@property (strong, nonatomic, readonly, nullable) HTLocation *location;
@property (strong, nonatomic, readonly, nullable) HTGPSLog *lastKnownLocation;
@property (nonatomic, readonly) BOOL validPhoneNumber;

- (instancetype _Nullable)initWithResponseObject:(NSDictionary * _Nullable)responseObject NS_DESIGNATED_INITIALIZER;
- (void)updateWithResponseObject:(NSDictionary * _Nullable)responseObject;
- (void)fetchImageWithCompletion:(HTErrorBlock)completion;

@end
