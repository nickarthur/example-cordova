//
//  HTActiveDriver.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 08/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTActiveDriver : NSObject <NSCoding>

@property (copy, nonatomic, readonly) NSString *driverID;
@property (assign, nonatomic, readonly) BOOL active;

+ (HTActiveDriver *)activeDriverWithDriverID:(NSString *)driverID;
+ (HTActiveDriver *)inactiveDriverWithDriverID:(NSString *)driverID;

@end
