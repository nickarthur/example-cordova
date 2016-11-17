//
//  HTLocation.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 28/08/15.
//  Copyright (c) 2015 HyperTrack Inc. All rights reserved.
//

#import "HTUtility.h"
#import "NSDictionary+Extension.h"
#import "NSDate+Extention.h"

#import "HTLocation.h"

static NSString * const typeKey = @"type";
static NSString * const coordinatesKey = @"coordinates";

static NSString * const coderTypeKey = @"type";
static NSString * const coderLocationKey = @"location";
static NSString * const coderActivitiesKey = @"activities";
static NSString * const coderActivityConfidenceKey = @"activityConfidence";

@interface HTLocation ()

@property (copy, nonatomic, readwrite, nullable) NSString *type;
@property (strong, nonatomic, readwrite, nullable) CLLocation *location;
@property (strong, nonatomic, readwrite, nullable) NSArray <NSString *> *activities;
@property (strong, nonatomic, readwrite, nullable) NSNumber *activityConfidence;

@end

@implementation HTLocation

///--------------------------------------
#pragma mark - Init
///--------------------------------------

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

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [self init];
    
    if (self) {
        self.type = @"Point";
        self.location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    }
    
    return self;
}

- (_Nullable instancetype)initWithLocation:(CLLocation *)location {
    self = [self init];
    
    if (self) {
        self.type = @"Point";
        self.location = location;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:coderTypeKey];
        self.location = [aDecoder decodeObjectForKey:coderLocationKey];
        self.activities = [aDecoder decodeObjectForKey:coderActivitiesKey];
        self.activityConfidence = [aDecoder decodeObjectForKey:coderActivityConfidenceKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:coderTypeKey];
    [aCoder encodeObject:self.location forKey:coderLocationKey];
    [aCoder encodeObject:self.activities forKey:coderActivitiesKey];
    [aCoder encodeObject:self.activityConfidence forKey:coderActivityConfidenceKey];
}

///--------------------------------------
#pragma mark - Update
///--------------------------------------

- (void)updateWithResponseObject:(NSDictionary *)responseObject {
    
    if (!responseObject
        || responseObject.count == 0) {
        return;
    }
    
    self.type = objc_dynamic_cast(NSString, responseObject[typeKey]);
    
    NSArray *coordinates = objc_dynamic_cast(NSArray, responseObject[coordinatesKey]);
    self.location = [[CLLocation alloc] initWithLatitude:objc_dynamic_cast(NSNumber, coordinates[1]).doubleValue
                                               longitude:objc_dynamic_cast(NSNumber, coordinates[0]).doubleValue];
}

- (void)updateWithActivities:(NSArray<NSString *> *)activities andConfidence:(NSUInteger)confidence {
    self.activities = activities;
    self.activityConfidence = @(confidence);
}

///--------------------------------------
#pragma mark - Instance Methods
///--------------------------------------

- (NSString *)description {
    return [NSString stringWithFormat:@"Type : %@, Location : %@", self.type, self.location];
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary ht_setNilSafeObject:self.type forKey:typeKey];
    [dictionary ht_setNilSafeObject:@[@(self.location.coordinate.longitude), @(self.location.coordinate.latitude)] forKey:coordinatesKey];
    
    return dictionary;
}

- (NSDictionary *)locationDictionaryValue {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary ht_setNilSafeObject:self.dictionaryValue forKey:@"location"];
    
    [dictionary ht_setNilSafeObject:self.location.timestamp.ht_stringValue forKey:@"recorded_at"];
    [dictionary ht_setNilSafeObject:@(self.location.speed) forKey:@"speed"];
    [dictionary ht_setNilSafeObject:@(self.location.horizontalAccuracy) forKey:@"location_accuracy"];
    [dictionary ht_setNilSafeObject:@(self.location.altitude) forKey:@"altitude"];
    [dictionary ht_setNilSafeObject:@(self.location.course) forKey:@"bearing"];
    [dictionary ht_setNilSafeObject:self.activities forKey:@"activities"];
    [dictionary ht_setNilSafeObject:self.activityConfidence forKey:@"activity_confidence"];
    
    return dictionary;
}

@end
