//
//  HTSocket.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 05/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTSocket_h
#define HTSocket_h

#import <Foundation/Foundation.h>

@protocol HTSocket <NSObject>

@property (nonatomic, readonly) BOOL connected;

- (void)restoreSocketConnectionIfBroken;

@end

#endif /* HTSocket_h */
