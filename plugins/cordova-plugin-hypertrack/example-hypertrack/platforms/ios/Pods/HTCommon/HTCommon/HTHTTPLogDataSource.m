//
//  HTHTTPLogDataSource.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTRestClientPostProtocol.h"
#import "HTHTTPLogDataSource.h"

@interface HTHTTPLogDataSource ()

@property (nonatomic, strong) id<HTRestClientPostProtocol> restClient;
@property (nonatomic, copy) NSString *url;

@end

@implementation HTHTTPLogDataSource

- (instancetype)initWithRestClient:(id<HTRestClientPostProtocol>)restClient url:(NSString *)url {
    self = [super init];
    if (self) {
        self.restClient = restClient;
        self.url = url;
    }
    
    return self;
}

- (void)logMessage:(NSString *)message {
    [self.restClient postRequestWithParams:@[message] url:self.url additionalHeaders:nil success:nil failure:nil];
}

@end
