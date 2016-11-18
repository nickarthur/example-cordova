//
//  HTJobScheduler.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTScheduler.h"

@protocol HTLoggerProtocol;

@interface HTJobScheduler : NSObject <HTScheduler>

- (instancetype)initWithLogger:(id<HTLoggerProtocol>)logger NS_DESIGNATED_INITIALIZER;

@end
