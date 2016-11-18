//
//  HTJobSchedulerDefines.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTJobSchedulerDefines_h
#define HTJobSchedulerDefines_h

@protocol HTJobProtocol;

typedef void(^HTJobBlock)(id<HTJobProtocol> job);

/** A unique ID that corresponds to one location request. */
typedef NSInteger HTJobID;

#endif /* HTJobSchedulerDefines_h */
