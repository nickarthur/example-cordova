//
//  HTSQLiteDatabase.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 17/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <sqlite3.h>
#import <HTCommon/HTBlocks.h>
#import <HTCommon/HTError.h>

#import "HTSQLiteStatement.h"
#import "HTSQLiteDatabaseResult.h"

#import "HTSQLiteDatabase.h"

static NSString *const HTSQLiteDatabaseBeginExclusiveOperationCommand = @"BEGIN EXCLUSIVE";
static NSString *const HTSQLiteDatabaseCommitOperationCommand = @"COMMIT";
static NSString *const HTSQLiteDatabaseRollbackOperationCommand = @"ROLLBACK";


@interface HTSQLiteDatabase ()

/**
 Database instance
 */
@property (nonatomic, assign) sqlite3 *database;

/**
 Database path
 */
@property (nonatomic, copy) NSString *databasePath;

@property (nonatomic, strong) dispatch_queue_t databaseQueue;

@end

@implementation HTSQLiteDatabase

- (instancetype)initWithPath:(NSString *)path queue:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        self.databasePath = path;
        self.databaseQueue = queue;
    }
    
    return self;
}

+ (instancetype)databaseWithPath:(NSString *)path queue:(dispatch_queue_t)queue {
    return [[self alloc] initWithPath:path queue:queue];
}

- (void)isOpenWithBlock:(HTDatabaseOpenCloseBlock)block {
    dispatch_async(self.databaseQueue, ^{
        InvokeBlock(block, self.database != nil, nil);
    });
}

- (void)openWithBlock:(HTDatabaseOpenCloseBlock)block {
    dispatch_async(self.databaseQueue, ^{
        [self isOpenWithBlock:^(BOOL result, NSError *error) {
            if (result) {
                InvokeBlock(block, YES, nil);
                return;
            }
            
            sqlite3 *db;
            int resultCode = sqlite3_open(self.databasePath.UTF8String, &db);
            if (resultCode != SQLITE_OK) {
                InvokeBlock(block, NO, [self errorForDatabaseWithMessage:@"Could not open DB"]);
                return;
            }
            
            self.database = db;
            InvokeBlock(block, YES, nil);
            return;
        }];
    });
}

- (void)closeWithBlock:(HTDatabaseOpenCloseBlock)block {
    dispatch_async(self.databaseQueue, ^{
        [self isOpenWithBlock:^(BOOL result, NSError *error) {
            if (!result) {
                InvokeBlock(block, NO, nil);
                return;
            }
            
            int resultCode = sqlite3_close(self.database);
            if (resultCode == SQLITE_OK) {
                self.database = nil;
                InvokeBlock(block, YES, nil);
                return;
            }
            
            InvokeBlock(block, NO, nil);
        }];
    });
}

- (void)executeQuery:(NSString *)query withArgumentsInArray:(NSArray *)args
      cachingEnabled:(BOOL)enableCaching
               block:(HTDatabaseQueryBlock)block  {
    dispatch_async(self.databaseQueue, ^{
        
        int resultCode = 0;
        sqlite3_stmt *sqliteStatement = nil;
        resultCode = sqlite3_prepare_v2(self.database, query.UTF8String, -1, &sqliteStatement, 0);
        if (resultCode != SQLITE_OK) {
            sqlite3_finalize(sqliteStatement);
            InvokeBlock(block, nil, [self errorForDatabaseWithMessage:nil]);
            return;
        }
        
        HTSQLiteStatement *statement = [[HTSQLiteStatement alloc] initWithStatement:sqliteStatement];
        
        // Make parameter
        int queryCount = sqlite3_bind_parameter_count(statement.sqliteStatement);
        int argumentCount = (int)args.count;
        if (queryCount != argumentCount) {
            if (!enableCaching) {
                [statement close];
            }
            
            InvokeBlock(block, nil, [self errorForDatabaseWithMessage:nil]);
            return;
        }
        
        for (int idx = 0; idx < queryCount; ++idx) {
            [self _bindObject:args[idx] toColumn:(idx + 1) inStatement:statement];
        }
        
        HTSQLiteDatabaseResult *result = [[HTSQLiteDatabaseResult alloc] initWithStatement:statement];
        InvokeBlock(block, result, nil);
    });
}

- (NSError *)errorForDatabaseWithMessage:(NSString *)message {
    return [NSError ht_errorForType:HTDatabaseError
                            message:message
                          parameter:nil
                          errorCode:HTSQLiteDatabaseInvalidSQL
                    devErrorMessage:[NSString stringWithUTF8String:sqlite3_errmsg(self.database)]];
}

- (void)executeQuery:(NSString *)query withArgumentsInArray:(NSArray *)args block:(HTDatabaseQueryBlock)block {
    [self executeQuery:query withArgumentsInArray:args cachingEnabled:NO block:^(HTSQLiteDatabaseResult *result, NSError *error) {
        if (error) {
            InvokeBlock(block, nil, error);
        } else {
            int sqliteResultCode = [result step];
            [result reset];
            switch (sqliteResultCode) {
                case SQLITE_DONE: {
                    InvokeBlock(block, result, nil);
                }
                    break;
                case SQLITE_ROW: {
                    NSError *error = [self errorForDatabaseWithMessage:@"Cannot use executeQuery for SELECT"];
                    InvokeBlock(block, nil, error);
                }
                    break;
                default: {
                    NSError *error = [self errorForDatabaseWithMessage:@"SQL Error"];
                    InvokeBlock(block, nil, error);
                }
            }
            
            [result close];
        }
    }];
}

- (void)executeCachedQuery:(NSString *)sql withArgumentsInArray:(NSArray *)args block:(HTDatabaseQueryBlock)block {
    [self executeQuery:sql withArgumentsInArray:args cachingEnabled:YES block:^(HTSQLiteDatabaseResult *result, NSError *error) {
        if (error) {
            InvokeBlock(block, nil, error);
        } else {
            InvokeBlock(block, result, nil);
            [result close];
        }
    }];
}

- (int)_bindObject:(id)obj toColumn:(int)idx inStatement:(HTSQLiteStatement *)statement {
    int result = -1;
    
    if ((!obj) || ((NSNull *)obj == [NSNull null])) {
        result = sqlite3_bind_null(statement.sqliteStatement, idx);
    } else if ([obj isKindOfClass:[NSData class]]) {
        const void *bytes = [obj bytes];
        if (!bytes) {
            // It's an empty NSData object, aka [NSData data].
            // Don't pass a NULL pointer, or sqlite will bind a SQL null instead of a blob.
            bytes = "";
        }
        result = sqlite3_bind_blob(statement.sqliteStatement, idx, bytes, (int)[obj length], SQLITE_TRANSIENT);
    } else if ([obj isKindOfClass:[NSDate class]]) {
        result = sqlite3_bind_double(statement.sqliteStatement, idx, [obj timeIntervalSince1970]);
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        if (CFNumberIsFloatType((__bridge CFNumberRef)obj)) {
            result = sqlite3_bind_double(statement.sqliteStatement, idx, [obj doubleValue]);
        } else {
            result = sqlite3_bind_int64(statement.sqliteStatement, idx, [obj longLongValue]);
        }
    } else {
        result = sqlite3_bind_text(statement.sqliteStatement, idx, [obj description].UTF8String, -1, SQLITE_TRANSIENT);
    }
    
    return result;
}

- (void)beginTransactionWithBlock:(HTDatabaseQueryBlock)block {
    [self executeQuery:HTSQLiteDatabaseBeginExclusiveOperationCommand withArgumentsInArray:nil block:block];
}

- (void)commitWithBlock:(HTDatabaseQueryBlock)block {
    [self executeQuery:HTSQLiteDatabaseCommitOperationCommand withArgumentsInArray:nil block:block];
}

- (void)rollbackWithBlock:(HTDatabaseQueryBlock)block {
    [self executeQuery:HTSQLiteDatabaseRollbackOperationCommand withArgumentsInArray:nil block:block];
}

@end
