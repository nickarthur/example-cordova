//
//  HTMQTTClient.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 05/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTSocketPublishable.h"
#import "HTSocketSubscribable.h"
#import "HTSocket.h"

@protocol HTLoggerProtocol;
@class HTReachability;

@interface HTMQTTClient : NSObject <HTSocketPublishable, HTSocketSubscribable, HTSocket>

- (instancetype)initWithHost:(NSString *)host prefix:(NSString *)prefix userAgent:(NSString *)userAgent logger:(id<HTLoggerProtocol>)logger reachability:(HTReachability *)reachability dispatchQueue:(dispatch_queue_t)dispatchQueue NS_DESIGNATED_INITIALIZER;

@end
