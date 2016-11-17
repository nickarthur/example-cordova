//
//  HTNetworkRequestDataSourceProtocol.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTRequestDataSourceProtocol_h
#define HTRequestDataSourceProtocol_h

#import <HTCommon/HTBlocks.h>
#import "HTNetworkRequestManagerDefines.h"

@protocol HTNetworkRequestDataSourceProtocol <NSObject>

- (void)networkRequestsToProcessWithBlock:(HTNetworkRequestQueueBlock)block;
- (void)completeNetworkRequest:(id<HTNetworkRequestProtocol>)networkRequest block:(HTErrorBlock)block;
- (void)addNetworkRequest:(id <HTNetworkRequestProtocol>)networkRequest block:(HTNetworkRequestAddBlock)block;
- (void)requestsCountWithBlock:(HTNetworkRequestCountBlock)block;
- (void)incrementRetryCountForRequest:(id <HTNetworkRequestProtocol>)request block:(HTErrorBlock)block;

@end

#endif /* HTRequestDataSourceProtocol_h */
