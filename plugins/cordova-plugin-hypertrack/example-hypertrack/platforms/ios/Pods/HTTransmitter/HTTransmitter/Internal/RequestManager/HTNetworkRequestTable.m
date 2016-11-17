//
//  HTNetworkRequestTable.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTSQLiteDatabase.h"
#import "HTSQLiteDatabaseResult.h"
#import "HTNetworkRequestProtocol.h"

#import "HTNetworkRequestTable.h"

static NSString * const TABLE_NAME = @"request";

static NSString * const COLUMN_ID = @"_id";
static NSString * const COLUMN_REQUEST_BLOB = @"request_blob";
static NSString * const COLUMN_RETRY_COUNT = @"retry_count";

static NSString * const CREATE_TABLE_QUERY = @"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ BLOB NOT NULL, %@ INTEGER DEFAULT 0);";
static NSString * const GET_REQUEST_QUERY = @"SELECT * FROM %@";
static NSString * const GET_REQUEST_COUNT_QUERY = @"SELECT COUNT(*) FROM %@";
static NSString * const ADD_REQUEST_QUERY = @"INSERT INTO %@ (%@) VALUES (?);";
static NSString * const DELETE_REQUEST_QUERY = @"DELETE FROM %@ WHERE %@=%ld";
static NSString * const UPDATE_RETRY_COUNT_QUERY = @"UPDATE %@ SET %@ = %ld WHERE %@=%ld";


@implementation HTNetworkRequestTable

+ (NSString *)createTableQuery {
    return [NSString stringWithFormat:CREATE_TABLE_QUERY, TABLE_NAME, COLUMN_ID, COLUMN_REQUEST_BLOB, COLUMN_RETRY_COUNT];
}

+ (NSString *)getRequestQuery {
    return [NSString stringWithFormat:GET_REQUEST_QUERY, TABLE_NAME];
}

+ (NSString *)getRequestCountQuery {
    return [NSString stringWithFormat:GET_REQUEST_COUNT_QUERY, TABLE_NAME];
}

+ (NSString *)insertRequestQuery {
    return [NSString stringWithFormat:ADD_REQUEST_QUERY, TABLE_NAME, COLUMN_REQUEST_BLOB];
}

+ (void)createTableIfDoesNotExist:(HTSQLiteDatabase *)database block:(HTErrorBlock)block {
    [database executeQuery:[self createTableQuery]
      withArgumentsInArray:nil
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

+ (void)networkRequestsForDatabase:(HTSQLiteDatabase *)database block:(HTNetworkRequestQueueBlock)block {
    [database executeCachedQuery:[self getRequestQuery]
            withArgumentsInArray:nil
                           block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                               if (error) {
                                   InvokeBlock(block, nil, error);
                                   return;
                               }
                               
                               NSMutableArray <id <HTNetworkRequestProtocol>> *mutableRequests = [NSMutableArray array];
                               while ([result next]) {
                                   NSData *requestBlob = [result dataForColumn:COLUMN_REQUEST_BLOB];
                                   id <HTNetworkRequestProtocol> request = [NSKeyedUnarchiver unarchiveObjectWithData:requestBlob];
                                   request.requestID = [result intForColumn:COLUMN_ID];
                                   request.retryCount = [result intForColumn:COLUMN_RETRY_COUNT];
                                   [mutableRequests addObject:request];
                               }
                               
                               InvokeBlock(block, mutableRequests, nil);
                           }];
}

+ (void)requestCountForDatabase:(HTSQLiteDatabase *)database block:(HTNetworkRequestCountBlock)block {
    [database executeCachedQuery:[self getRequestCountQuery]
            withArgumentsInArray:nil
                           block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                               [result step];
                               NSInteger requestCount = -1;
                               requestCount = [result intForColumnIndex:0];
    
                               InvokeBlock(block, requestCount, error);
                           }];
}

+ (void)completeNetworkRequest:(id<HTNetworkRequestProtocol>)request database:(HTSQLiteDatabase *)database block:(HTErrorBlock)block {
    NSString *deleteQuery = [NSString stringWithFormat:DELETE_REQUEST_QUERY, TABLE_NAME, COLUMN_ID, (long)request.requestID];
    [database executeQuery:deleteQuery
      withArgumentsInArray:nil
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

+ (void)addNetworkRequest:(id<HTNetworkRequestProtocol>)request database:(HTSQLiteDatabase *)database block:(HTNetworkRequestAddBlock)block {
    NSData *requestBlob = [NSKeyedArchiver archivedDataWithRootObject:request];
    [database executeQuery:[self insertRequestQuery]
      withArgumentsInArray:@[requestBlob]
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         NSInteger requestID = -1;
                         if (error) {
                             InvokeBlock(block, requestID, error);
                             return;
                         }
                         
                         [self networkRequestsForDatabase:database block:^(NSArray<id<HTNetworkRequestProtocol>> *requests, NSError *error) {
                             id <HTNetworkRequestProtocol> lastRequest = requests.lastObject;
                             InvokeBlock(block, lastRequest.requestID, nil);
                         }];
                     }];
}

+ (void)updateRetryCountForRequest:(id<HTNetworkRequestProtocol>)request count:(NSUInteger)count database:(HTSQLiteDatabase *)database block:(HTErrorBlock)block {
    NSString *updateQuery = [NSString stringWithFormat:UPDATE_RETRY_COUNT_QUERY, TABLE_NAME, COLUMN_RETRY_COUNT, (long)count, COLUMN_ID, (long)request.requestID];
    [database executeQuery:updateQuery
      withArgumentsInArray:nil
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

@end
