//
//  HTResponse_Private.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 25/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTResponse.h"

@interface HTResponse <T> ()

- (instancetype)initWithResult:(T)result offline:(BOOL)offline NS_DESIGNATED_INITIALIZER;

@end
