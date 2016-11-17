//
//  NSArray+HTExtension.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 27/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<T> (HTExtension)

- (NSArray <NSArray <T> *> *)splitWithCount:(NSUInteger)count;

@end
