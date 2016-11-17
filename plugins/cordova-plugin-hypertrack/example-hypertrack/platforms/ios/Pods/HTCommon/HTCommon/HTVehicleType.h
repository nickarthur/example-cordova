//
//  HTVehicleType.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 11/03/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTVehicleType : NSObject

typedef NS_ENUM(NSUInteger, HTDriverVehicleType) {
    /**
     *  Default
     */
    HTDriverVehicleTypeDefault = 0,
    /**
     *  Walk
     */
    HTDriverVehicleTypeWalk,
    /**
     *  Bicycle
     */
    HTDriverVehicleTypeBicycle,
    /**
     *  Motorcycle
     */
    HTDriverVehicleTypeMotorCycle,
    /**
     *  Three Wheeler
     */
    HTDriverVehicleTypeThreeWheeler,
    /**
     *  Car
     */
    HTDriverVehicleTypeCar,
    /**
     *  Van
     */
    HTDriverVehicleTypeVan
};

+ (NSString * _Nonnull)stringValueForVehicleType:(HTDriverVehicleType)vehicleType;
+ (HTDriverVehicleType)vehicleTypeForStringValue:(NSString * _Nullable)vehicleTypeString;

@end
