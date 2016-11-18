//
//  HTLogMessageTable.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTDatabase.h"
#import "HTSQLiteDatabaseResult.h"

#import "HTLogMessageTable.h"

static NSString * const TABLE_NAME = @"log_message";

static NSString * const COLUMN_ID = @"_id";
static NSString * const COLUMN_LOG_MESSAGE = @"message";

static NSString * const CREATE_TABLE_QUERY = @"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT NOT NULL);";
static NSString * const GET_LOG_MESSAGE_QUERY = @"SELECT * FROM %@";
static NSString * const INSERT_LOG_MESSAGE_QUERY = @"INSERT INTO %@ (%@) VALUES (?);";
static NSString * const LOG_COUNT_QUERY = @"SELECT COUNT(*) FROM %@";
static NSString * const DELETE_LOG_MESSAGES_QUERY = @"DELETE FROM %@";

@implementation HTLogMessageTable

+ (NSString *)createTableQuery {
    return [NSString stringWithFormat:CREATE_TABLE_QUERY, TABLE_NAME, COLUMN_ID, COLUMN_LOG_MESSAGE];
}

+ (NSString *)getLogsQuery {
    return [NSString stringWithFormat:GET_LOG_MESSAGE_QUERY, TABLE_NAME];
}

+ (NSString *)insertLogMessageQuery {
    return [NSString stringWithFormat:INSERT_LOG_MESSAGE_QUERY, TABLE_NAME, COLUMN_LOG_MESSAGE];
}

+ (NSString *)logCountQuery {
    return [NSString stringWithFormat:LOG_COUNT_QUERY, TABLE_NAME];
}

+ (NSString *)deleteLogMessagesQuery {
    return [NSString stringWithFormat:DELETE_LOG_MESSAGES_QUERY, TABLE_NAME];
}

+ (void)createTableIfDoesNotExist:(id<HTDatabase>)database block:(HTErrorBlock)block {
    [database executeQuery:[self createTableQuery]
      withArgumentsInArray:nil
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

+ (void)addLogMessage:(NSString *)logMessage database:(id<HTDatabase>)database block:(HTErrorBlock)block {
    [database executeQuery:[self insertLogMessageQuery]
      withArgumentsInArray:@[logMessage]
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

+ (void)logMessages:(id<HTDatabase>)database block:(HTLogMessageBlock)block {
    [database executeCachedQuery:[self getLogsQuery]
            withArgumentsInArray:nil
                           block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                               if (error) {
                                   InvokeBlock(block, nil, error);
                                   return;
                               }
                               
                               NSMutableArray <NSString *> *logMessages = [NSMutableArray array];
                               while ([result next]) {
                                   NSString *logMessage = [result stringForColumn:COLUMN_LOG_MESSAGE];
                                   [logMessages addObject:logMessage];
                               }
                               
                               InvokeBlock(block, logMessages, nil);
                           }];
}

+ (void)logCount:(id<HTDatabase>)database block:(HTLogMessageCountBlock)block {
    [database executeCachedQuery:[self logCountQuery]
            withArgumentsInArray:nil
                           block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                               [result step];
                               NSInteger requestCount = -1;
                               requestCount = [result intForColumnIndex:0];
                               
                               InvokeBlock(block, requestCount, error);
                           }];
}

+ (void)deleteLogMessage:(id<HTDatabase>)database block:(HTErrorBlock)block {
    [database executeQuery:[self deleteLogMessagesQuery]
      withArgumentsInArray:nil
                     block:^(HTSQLiteDatabaseResult *result, NSError *error) {
                         InvokeBlock(block, error);
                     }];
}

@end
