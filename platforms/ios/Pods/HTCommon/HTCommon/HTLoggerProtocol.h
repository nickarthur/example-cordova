//
//  HTLoggerProtocol.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTLoggerProtocol_h
#define HTLoggerProtocol_h

#import <Foundation/Foundation.h>
#import "HTConstants.h"

@protocol HTLoggerProtocol <NSObject>

- (void)assert:(NSString * _Nullable)format, ... NS_FORMAT_FUNCTION(1, 2);
- (void)error:(NSString * _Nullable)format, ... NS_FORMAT_FUNCTION(1, 2);
- (void)warn:(NSString * _Nullable)format, ... NS_FORMAT_FUNCTION(1, 2);
- (void)info:(NSString * _Nullable)format, ... NS_FORMAT_FUNCTION(1, 2);
- (void)debug:(NSString * _Nullable)format, ... NS_FORMAT_FUNCTION(1, 2);

+ (void)setLogLevel:(HTLogLevel)logLevel;
+ (HTLogLevel)logLevel;

@end


#endif /* HTLoggerProtocol_h */
