//
//  HTSocketPublishable.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 05/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTSocketPublishable_h
#define HTSocketPublishable_h

#import <Foundation/Foundation.h>
#import <HTCommon/HTBlocks.h>

@protocol HTSocketPublishable <NSObject>

- (void)publishParams:(id)params onTopic:(NSString *)topic completion:(HTErrorBlock)completion;

@end

#endif /* HTSocketPublishable_h */
