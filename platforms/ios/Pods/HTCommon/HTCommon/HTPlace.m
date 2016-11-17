//
//  HTPlace.m
//  HTConsumer
//
//  Created by Ulhas Mandrawadkar on 19/01/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTUtility.h"
#import "HTLocation.h"
#import "NSDictionary+Extension.h"

#import "HTPlace.h"

static NSString * const locationKey = @"location";
static NSString * const placeIDKey = @"id";
static NSString * const addressKey = @"address";
static NSString * const landmarkKey = @"landmark";
static NSString * const postalCodeKey = @"zip_code";
static NSString * const cityKey = @"city";
static NSString * const stateKey = @"state";
static NSString * const countryKey = @"country";


@interface HTPlace ()

@property (copy, nonatomic, readwrite) NSString *placeID;
@property (strong, nonatomic, readwrite) HTLocation *location;
@property (copy, nonatomic, readwrite, nullable) NSString *address;
@property (copy, nonatomic, readwrite, nullable) NSString *landmark;
@property (copy, nonatomic, readwrite, nullable) NSString *zipCode;
@property (copy, nonatomic, readwrite, nullable) NSString *city;
@property (copy, nonatomic, readwrite, nullable) NSString *state;
@property (copy, nonatomic, readwrite, nullable) NSString *country;

@end

@interface CLLocation (Extension)

@property (copy, nonatomic, readonly) NSString *displayString;

@end

@implementation CLLocation (Extension)

- (NSString *)displayString {
    NSString *latitude = @(self.coordinate.latitude).stringValue;
    NSString *longitude = @(self.coordinate.longitude).stringValue;
    
    NSRange latitudeRange = [latitude rangeOfString:@"."];
    NSRange longitudeRange = [longitude rangeOfString:@"."];
    
    NSUInteger latitudeIndex = latitudeRange.length + latitudeRange.location + 1;
    NSUInteger longitudeIndex = longitudeRange.location + longitudeRange.length + 1;
    
    if (latitudeIndex > latitude.length) {
        latitudeIndex = latitude.length;
    }
    
    if (longitudeIndex > longitude.length) {
        longitudeIndex = longitude.length;
    }
    
    NSString *trimmedLatitude = [latitude substringToIndex:latitudeIndex];
    NSString *trimmedLongitude = [longitude substringToIndex:longitudeIndex];
    
    return [NSString stringWithFormat:@"%@° N, %@° E", trimmedLatitude, trimmedLongitude];
}

@end

@implementation HTPlace

- (instancetype)init {
    return [self initWithResponseObject:nil];
}

- (instancetype)initWithLocation:(HTLocation *)location {
    self = [self init];
    if (self) {
        self.location = location;
    }
    
    return self;
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
    
    self.placeID = objc_dynamic_cast(NSString, responseObject[placeIDKey]);
    self.location = [[HTLocation alloc] initWithResponseObject:objc_dynamic_cast(NSDictionary, responseObject[locationKey])];
    self.address = objc_dynamic_cast(NSString, responseObject[addressKey]);
    self.landmark = objc_dynamic_cast(NSString, responseObject[landmarkKey]);
    self.zipCode = objc_dynamic_cast(NSString, responseObject[postalCodeKey]);
    self.city = objc_dynamic_cast(NSString, responseObject[cityKey]);
    self.state = objc_dynamic_cast(NSString, responseObject[stateKey]);
    self.country = objc_dynamic_cast(NSString, responseObject[countryKey]);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ID : %@, Location : %@", self.placeID, self.location];
}

- (NSString *)displayString {
    
    if (self.address && self.address.length > 0) {
        return self.address;
    }
    
    if (self.landmark && self.landmark.length > 0) {
        return self.landmark;
    }
    
    if (self.location && self.location.location) {
        return self.location.location.displayString;
    }
    
    return nil;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary ht_setNilSafeObject:self.placeID forKey:placeIDKey];
    [dictionary ht_setNilSafeObject:self.location.dictionaryValue forKey:locationKey];
    [dictionary ht_setNilSafeObject:self.address forKey:addressKey];
    [dictionary ht_setNilSafeObject:self.landmark forKey:landmarkKey];
    [dictionary ht_setNilSafeObject:self.zipCode forKey:postalCodeKey];
    [dictionary ht_setNilSafeObject:self.city forKey:cityKey];
    [dictionary ht_setNilSafeObject:self.state forKey:stateKey];
    [dictionary ht_setNilSafeObject:self.country forKey:countryKey];
    
    return dictionary;
}

@end
