//
//  HTDispatchQueue.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 22/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTDispatchQueue.h"

static void *const HTThreadsafetyQueueIDKey = (void *)&HTThreadsafetyQueueIDKey;

@implementation HTDispatchQueue

+ (dispatch_queue_t)threadSafeQueueForClass:(Class)aClass {
    NSString *label = [NSStringFromClass(aClass) stringByAppendingString:@".synchronizationQueue"];
    dispatch_queue_t queue = dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_SERIAL);
    
    void *uuid = calloc(1, sizeof(uuid));
    dispatch_queue_set_specific(queue, HTThreadsafetyQueueIDKey, uuid, free);
    
    return queue;
}

+ (dispatch_queue_t)threadSafeConcurrentQueueForClass:(Class)aClass {
    NSString *label = [NSStringFromClass(aClass) stringByAppendingString:@".synchronizationQueue"];
    dispatch_queue_t queue = dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    
    void *uuid = calloc(1, sizeof(uuid));
    dispatch_queue_set_specific(queue, HTThreadsafetyQueueIDKey, uuid, free);
    
    return queue;
}

@end
