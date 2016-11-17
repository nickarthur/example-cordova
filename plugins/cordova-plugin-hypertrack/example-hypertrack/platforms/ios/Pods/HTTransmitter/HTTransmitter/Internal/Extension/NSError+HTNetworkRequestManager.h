//
//  NSError+HTNetworkRequestManager.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 18/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (HTNetworkRequestManager)

+ (NSError *)errorForRequestTimeout;
+ (NSError *)errorForNetworkOutage;

@end
