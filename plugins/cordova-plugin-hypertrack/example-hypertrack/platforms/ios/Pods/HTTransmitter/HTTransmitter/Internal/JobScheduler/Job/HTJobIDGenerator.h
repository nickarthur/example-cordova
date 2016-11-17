//
//  HTJobIDGenerator.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTJobSchedulerDefines.h"

@interface HTJobIDGenerator : NSObject

+ (HTJobID)getUniqueJobID;

@end
