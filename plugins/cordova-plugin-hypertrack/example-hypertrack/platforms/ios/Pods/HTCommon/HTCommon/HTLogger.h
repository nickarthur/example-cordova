//
//  HTLogger.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 14/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTConstants.h"
#import "HTLoggerProtocol.h"

@protocol HTLogDataSource;

@interface HTLogger : NSObject <HTLoggerProtocol>

- (instancetype)initWithDataSource:(id<HTLogDataSource>)dataSource userAgent:(NSString *)userAgent NS_DESIGNATED_INITIALIZER;

@end
