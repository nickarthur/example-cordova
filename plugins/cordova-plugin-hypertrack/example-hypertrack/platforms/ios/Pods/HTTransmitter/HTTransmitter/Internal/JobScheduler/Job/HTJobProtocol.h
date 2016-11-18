//
//  HTJobProtocol.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTJobProtocol_h
#define HTJobProtocol_h

#import "HTJobSchedulerDefines.h"

@protocol HTJobProtocol <NSObject>

@property (nonatomic, assign) HTJobID jobID;
@property (nonatomic, copy) HTJobBlock block;

@end

#endif /* HTJobProtocol_h */
