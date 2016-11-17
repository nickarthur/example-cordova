//
//  HTUtility.m
//  HTCommon
//
//  Created by Arjun Attam on 21/03/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <sys/utsname.h>
#import "HTUtility.h"

@implementation HTUtility

+ (float)batteryLevel {
    if (![[UIDevice currentDevice] isBatteryMonitoringEnabled]) {
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    }
    
    float batteryLevel = [UIDevice currentDevice].batteryLevel;
    return 100 * batteryLevel;
}

+ (UIDeviceBatteryState)batteryState {
    if (![[UIDevice currentDevice] isBatteryMonitoringEnabled]) {
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    }
    
    return [UIDevice currentDevice].batteryState;
}

+ (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end
