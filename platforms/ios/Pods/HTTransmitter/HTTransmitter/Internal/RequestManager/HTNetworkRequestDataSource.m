//
//  HTNetworkRequestDataSource.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTSQLiteDatabase.h"
#import "HTNetworkRequestTable.h"
#import "HTNetworkRequestProtocol.h"

#import "HTNetworkRequestDataSource.h"

@interface HTNetworkRequestDataSource ()

@property (nonatomic, strong) HTSQLiteDatabase *database;

@end

@implementation HTNetworkRequestDataSource

- (instancetype)initWithDatabase:(HTSQLiteDatabase *)database {
    self = [super init];
    if (self) {
        self.database = database;
        [self.database openWithBlock:^(BOOL result, NSError *error) {
            [HTNetworkRequestTable createTableIfDoesNotExist:self.database block:nil];
        }];
    }
    
    return self;
}

- (void)addNetworkRequest:(id<HTNetworkRequestProtocol>)networkRequest block:(HTNetworkRequestAddBlock)block {
    [HTNetworkRequestTable addNetworkRequest:networkRequest database:self.database block:block];
}

- (void)completeNetworkRequest:(id<HTNetworkRequestProtocol>)networkRequest block:(HTErrorBlock)block {
    [HTNetworkRequestTable completeNetworkRequest:networkRequest database:self.database block:block];
}

- (void)networkRequestsToProcessWithBlock:(HTNetworkRequestQueueBlock)block {
    [HTNetworkRequestTable networkRequestsForDatabase:self.database block:^(NSArray<id<HTNetworkRequestProtocol>> *requests, NSError *error) {
        if (error || !requests || requests.count == 0) {
            InvokeBlock(block, requests, error);
            return;
        }
        
        if (!requests.firstObject.parallel) {
            InvokeBlock(block, @[requests.firstObject], nil);
            return;
        }
        
        NSMutableArray <id <HTNetworkRequestProtocol>>* parallelRequests = [NSMutableArray array];
        for (id <HTNetworkRequestProtocol> request in requests) {
            if (!request.parallel) {
                break;
            }
            
            [parallelRequests addObject:request];
        }
        
        InvokeBlock(block, parallelRequests, nil);
    }];
}

- (void)requestsCountWithBlock:(HTNetworkRequestCountBlock)block {
    [HTNetworkRequestTable requestCountForDatabase:self.database block:block];
}

- (void)incrementRetryCountForRequest:(id<HTNetworkRequestProtocol>)request block:(HTErrorBlock)block {
    NSInteger retryCount = request.retryCount + 1;
    [HTNetworkRequestTable updateRetryCountForRequest:request count:retryCount database:self.database block:^(NSError * _Nullable error) {
        if (!error) {
            request.retryCount = retryCount;
        }
        
        InvokeBlock(block, error);
    }];
}

@end
