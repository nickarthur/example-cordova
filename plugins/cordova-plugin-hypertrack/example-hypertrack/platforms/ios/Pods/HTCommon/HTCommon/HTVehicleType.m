//
//  HTVehicleType.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 11/03/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTVehicleType.h"

NSString * const HTDriverVehicleTypeWalkString = @"walking";
NSString * const HTDriverVehicleTypeBicycleString = @"bicycle";
NSString * const HTDriverVehicleTypeMotorCycleString = @"motorcycle";
NSString * const HTDriverVehicleTypeCarString = @"car";
NSString * const HTDriverVehicleTypeThreeWheelerString = @"3-wheeler";
NSString * const HTDriverVehicleTypeVanString = @"van";
NSString * const HTDriverVehicleTypeDefaultString = @"default";

@implementation HTVehicleType

+ (NSString *)stringValueForVehicleType:(HTDriverVehicleType)vehicleType {
    NSString *vehicleTypeString;
    
    switch (vehicleType) {
        case HTDriverVehicleTypeWalk:
            vehicleTypeString = HTDriverVehicleTypeWalkString;
            break;
            
        case HTDriverVehicleTypeBicycle:
            vehicleTypeString = HTDriverVehicleTypeBicycleString;
            break;
            
        case HTDriverVehicleTypeMotorCycle:
            vehicleTypeString = HTDriverVehicleTypeMotorCycleString;
            break;
            
        case HTDriverVehicleTypeCar:
            vehicleTypeString = HTDriverVehicleTypeCarString;
            break;
            
        case HTDriverVehicleTypeThreeWheeler:
            vehicleTypeString = HTDriverVehicleTypeThreeWheelerString;
            break;
            
        case HTDriverVehicleTypeVan:
            vehicleTypeString = HTDriverVehicleTypeVanString;
            break;
            
        case HTDriverVehicleTypeDefault:
        default:
            vehicleTypeString = HTDriverVehicleTypeDefaultString;
            break;
    }
    
    return vehicleTypeString;
}

+ (HTDriverVehicleType)vehicleTypeForStringValue:(NSString *)vehicleTypeString {
    HTDriverVehicleType vehicleType = HTDriverVehicleTypeDefault;
    
    if ([vehicleTypeString isEqualToString:HTDriverVehicleTypeWalkString]) {
        vehicleType = HTDriverVehicleTypeWalk;
    } else if ([vehicleTypeString isEqualToString:HTDriverVehicleTypeBicycleString]) {
        vehicleType = HTDriverVehicleTypeBicycle;
    } else if ([vehicleTypeString isEqualToString:HTDriverVehicleTypeMotorCycleString]) {
        vehicleType = HTDriverVehicleTypeMotorCycle;
    } else if ([vehicleTypeString isEqualToString:HTDriverVehicleTypeCarString]) {
        vehicleType = HTDriverVehicleTypeCar;
    } else if ([vehicleTypeString isEqualToString:HTDriverVehicleTypeThreeWheelerString]) {
        vehicleType = HTDriverVehicleTypeThreeWheeler;
    } else if ([vehicleTypeString isEqualToString:HTDriverVehicleTypeVanString]) {
        vehicleType = HTDriverVehicleTypeVan;
    }
    
    return vehicleType;
}

@end
