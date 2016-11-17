//
//  HTMQTTSubscription.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 06/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTCommon/HTBlocks.h>

#import "HTMQTTDefines.h"

@interface HTMQTTSubscription : NSObject

@property (nonatomic, readonly, assign) HTMQTTSubscriptionID subscriptionID;
@property (nonatomic, readonly, copy) NSString *topic;
@property (nonatomic, readonly, copy) HTSocketMessageBlock messageHandler;
@property (nonatomic, readonly, copy) HTErrorBlock subscriptionHandler;

- (instancetype)initWithTopic:(NSString *)topic messageHandler:(HTSocketMessageBlock)messageHandler subscriptionHandler:(HTErrorBlock)subscriptionHandler NS_DESIGNATED_INITIALIZER;

@end
