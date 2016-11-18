//
//  HTNetworkRequestTable.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTCommon/HTBlocks.h>

#import "HTNetworkRequestManagerDefines.h"

@class HTSQLiteDatabase;

@interface HTNetworkRequestTable : NSObject

+ (void)createTableIfDoesNotExist:(HTSQLiteDatabase *)database block:(HTErrorBlock)block;
+ (void)networkRequestsForDatabase:(HTSQLiteDatabase *)database block:(HTNetworkRequestQueueBlock)block;
+ (void)requestCountForDatabase:(HTSQLiteDatabase *)database block:(HTNetworkRequestCountBlock)block;
+ (void)addNetworkRequest:(id <HTNetworkRequestProtocol>)request database:(HTSQLiteDatabase *)database block:(HTNetworkRequestAddBlock)block;
+ (void)completeNetworkRequest:(id <HTNetworkRequestProtocol>)request database:(HTSQLiteDatabase *)database block:(HTErrorBlock)block;
+ (void)updateRetryCountForRequest:(id <HTNetworkRequestProtocol>)request count:(NSUInteger)count database:(HTSQLiteDatabase *)database block:(HTErrorBlock)block;

@end
