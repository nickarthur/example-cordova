//
//  HTNetworkRequestManager.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTCommon/HTBlocks.h>
#import <HTCommon/HTRestClientGetProtocol.h>
#import <HTCommon/HTRestClientPostProtocol.h>

#import "HTNetworkRequestManagerDefines.h"

@class HTReachability;
@protocol HTNetworkRequestDataSourceProtocol;
@protocol HTRestClientGetProtocol;
@protocol HTRestClientPostProtocol;
@protocol HTLoggerProtocol;
@protocol HTSocketSubscribable;
@protocol HTSocketPublishable;
@protocol HTSocket;

typedef void(^HTNetworkRequestManagerStatusBlock)(HTNetworkRequestStatus status);

@interface HTNetworkRequestManager : NSObject

- (instancetype)initWithDataSource:(id<HTNetworkRequestDataSourceProtocol>)datasource reachability:(HTReachability *)reachability restClient:(id <HTRestClientPostProtocol, HTRestClientGetProtocol>)restClient socketClient:(id<HTSocketPublishable, HTSocketSubscribable, HTSocket>)socketClient logger:(id<HTLoggerProtocol>)logger NS_DESIGNATED_INITIALIZER;

- (void)addListener:(HTNetworkRequestManagerStatusBlock)listener;
- (void)removeListener:(HTNetworkRequestManagerStatusBlock)listener;

- (void)processCachedRequests;
- (void)processRequest:(id <HTNetworkRequestProtocol>)request;
- (void)addRequest:(id<HTNetworkRequestProtocol>)request block:(HTNetworkRequestManagerStatusBlock)block;

@end
