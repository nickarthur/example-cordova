//
//  NSArray+HTExtension.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 27/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "NSArray+HTExtension.h"

@implementation NSArray (HTExtension)

- (NSArray <NSArray *> *)splitWithCount:(NSUInteger)count {
    NSMutableArray <NSArray *> *partition = [NSMutableArray array];
    NSUInteger size = self.count;
    
    for (int i = 0; i < size; i += count) {
        [partition addObject:[self subarrayWithRange:NSMakeRange(i, MIN(size - i, count))]];
    }
    
    return partition;
}

@end
