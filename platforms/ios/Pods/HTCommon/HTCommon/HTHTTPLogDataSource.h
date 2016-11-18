//
//  HTHTTPLogDataSource.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLogDataSource.h"

@protocol HTRestClientPostProtocol;

@interface HTHTTPLogDataSource : NSObject <HTLogDataSource>

- (instancetype)initWithRestClient:(id<HTRestClientPostProtocol>)restClient url:(NSString *)url;

@end
