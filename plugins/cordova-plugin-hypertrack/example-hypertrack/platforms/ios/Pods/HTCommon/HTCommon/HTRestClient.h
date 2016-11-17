//
//  HTRestClient.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 29/08/15.
//  Copyright (c) 2015 HyperTrack Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTRestClientPostProtocol.h"
#import "HTRestClientGetProtocol.h"
#import "HTRestClientGetImageProtocol.h"

@class UIImage;

@interface HTRestClient : NSObject <HTRestClientPostProtocol, HTRestClientGetProtocol, HTRestClientGetImageProtocol>

- (instancetype)initWithBaseURL:(NSString *)baseURL andUserAgent:(NSString *)userAgent NS_DESIGNATED_INITIALIZER;

@end
