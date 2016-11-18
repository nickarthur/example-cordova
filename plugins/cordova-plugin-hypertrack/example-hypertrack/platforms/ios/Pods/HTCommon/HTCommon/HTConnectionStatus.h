//
//  HTConnectionStatus.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 26/07/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTConnectionStatus : NSObject

typedef NS_ENUM(NSUInteger, HTDriverConnectionStatus) {
    /**
     *  Healthy
     */
    HTDriverConnectionStatusHealthy = 0,
    /**
     *  Lost
     */
    HTDriverConnectionStatusLost
};

+ (NSString * _Nonnull)stringValueForConnectionStatus:(HTDriverConnectionStatus)connectionStatus;
+ (HTDriverConnectionStatus)connectionStatusForStringValue:(NSString * _Nullable)connectionTypeString;

@end
