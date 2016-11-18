//
//  HTScheduler.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 25/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTScheduler_h
#define HTScheduler_h

#import "HTJobSchedulerDefines.h"

@protocol HTJobProtocol;

@protocol HTScheduler <NSObject>

- (HTJobID)subscribe:(HTJobBlock)block;
- (void)complete:(HTJobID)jobID;

- (void)update:(NSTimeInterval)schedule;
- (void)resetSchedule;

@end


#endif /* HTScheduler_h */
