//
//  HTDispatchQueue.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 22/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDispatchQueue : NSObject

+ (dispatch_queue_t)threadSafeQueueForClass:(Class)aClass;
+ (dispatch_queue_t)threadSafeConcurrentQueueForClass:(Class)aClass;

@end
