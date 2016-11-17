//
//  HTDriver.m
//  HTConsumer
//
//  Created by Ulhas Mandrawadkar on 19/01/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTUtility.h"
#import "HTError.h"
#import "HTRestClient.h"
#import "HTLocation.h"
#import "HTGPSLog.h"

#import "HTDriver.h"

static NSString * const idKey = @"id";
static NSString * const nameKey = @"name";
static NSString * const phoneNumberKey = @"phone";
static NSString * const photoKey = @"photo";
static NSString * const vehicleTypeKey = @"vehicle_type";
static NSString * const locationKey = @"location";
static NSString * const lastKnownLocationKey = @"last_known_location";

@interface HTDriver ()

@property (copy, nonatomic, readwrite, nullable) NSString *driverID;
@property (copy, nonatomic, readwrite, nullable) NSString *name;
@property (copy, nonatomic, readwrite, nullable) NSString *phoneNumber;
@property (copy, nonatomic, readwrite, nullable) NSURL *photoURL;
@property (assign, nonatomic, readwrite) HTDriverVehicleType vehicleType;
@property (strong, nonatomic, readwrite, nullable) UIImage *image;
@property (strong, nonatomic, readwrite, nullable) HTLocation *location;
@property (strong, nonatomic, readwrite, nullable) HTGPSLog *lastKnownLocation;

@end

@implementation HTDriver

- (instancetype)init {
    return [self initWithResponseObject:nil];
}

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject {
    self = [super init];

    if (self) {
        [self updateWithResponseObject:responseObject];
    }

    return self;
}

- (void)updateWithResponseObject:(NSDictionary *)responseObject {

    if (!responseObject
        || responseObject.count == 0) {
        return;
    }

    self.driverID = objc_dynamic_cast(NSString, responseObject[idKey]);
    self.name = objc_dynamic_cast(NSString, responseObject[nameKey]);
    self.phoneNumber = objc_dynamic_cast(NSString, responseObject[phoneNumberKey]);
    self.photoURL = [NSURL URLWithString:objc_dynamic_cast(NSString, responseObject[photoKey])];

    self.vehicleType = [HTVehicleType vehicleTypeForStringValue:objc_dynamic_cast(NSString, responseObject[vehicleTypeKey])];
    self.location = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[locationKey])];
    self.lastKnownLocation = [[HTGPSLog alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[lastKnownLocationKey])];
}

- (BOOL)validPhoneNumber {
    return (self.phoneNumber && self.phoneNumber.length > 0);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ID : %@, Name : %@, Phone : %@, Photo : %@", self.driverID, self.name, self.phoneNumber, self.photoURL];
}

- (void)fetchImageWithCompletion:(HTErrorBlock)completion {
    if (self.image) {
        DispatchMainThread(completion, nil);
        return;
    }

    if (!self.photoURL
        || self.photoURL.absoluteString.length == 0) {
        DispatchMainThread(completion, [NSError errorWithDomain:HTErrorDomain code:404 userInfo:nil]);
        return;
    }

    [[HTRestClient new] getImageWithUrl:self.photoURL.absoluteString success:^(NSInteger statusCode, UIImage *image) {
        self.image = image;
        DispatchMainThread(completion, nil);
    } failure:^(NSInteger statusCode, UIImage *image, NSError *error) {
        DispatchMainThread(completion, error);
    }];
}

@end
