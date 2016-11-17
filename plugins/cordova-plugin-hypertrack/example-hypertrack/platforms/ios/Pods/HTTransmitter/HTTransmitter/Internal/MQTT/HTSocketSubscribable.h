//
//  HTSocketSubscribable.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 05/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTSocketSubscribable_h
#define HTSocketSubscribable_h

#import <Foundation/Foundation.h>
#import "HTMQTTDefines.h"

@protocol HTSocketSubscribable <NSObject>

- (HTMQTTSubscriptionID)subscribeToTopic:(NSString *)topic messageHandler:(HTSocketMessageBlock)messageHandler subscriptionHandler:(HTErrorBlock)subscriptionHandler;
- (void)unsubscribeFromTopic:(NSString *)topic;

@end

#endif /* HTSocketSubscribable_h */
