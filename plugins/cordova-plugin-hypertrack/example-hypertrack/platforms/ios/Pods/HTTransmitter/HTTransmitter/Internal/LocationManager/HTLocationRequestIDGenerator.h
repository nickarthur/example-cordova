//
//  HTLocationRequestIDGenerator.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 10/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLocationManagerDefines.h"

@interface HTLocationRequestIDGenerator : NSObject

+ (HTLocationRequestID)getUniqueRequestID;

@end
