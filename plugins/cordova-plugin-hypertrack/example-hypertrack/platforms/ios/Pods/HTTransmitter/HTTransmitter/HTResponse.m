//
//  HTResponse.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 25/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTResponse.h"

@interface HTResponse <T> ()

@property (nonatomic, readwrite, assign) BOOL offline;
@property (nonatomic, readwrite, strong) T result;

@end

@implementation HTResponse

- (instancetype)init {
    return [self initWithResult:nil offline:NO];
}

- (instancetype)initWithResult:(id)result offline:(BOOL)offline {
    self = [super init];
    if (self) {
        self.offline = offline;
        self.result = result;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Offline : %@, Result : %@", @(self.offline), self.result];
}

@end
