//
//  HTDatabase.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 21/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTDatabase_h
#define HTDatabase_h

#import <Foundation/Foundation.h>

@class HTSQLiteDatabaseResult;

typedef void(^HTDatabaseQueryBlock)(HTSQLiteDatabaseResult *result, NSError *error);
typedef void(^HTDatabaseOpenCloseBlock)(BOOL result, NSError *error);

@protocol HTDatabase <NSObject>

- (void)openWithBlock:(HTDatabaseOpenCloseBlock)block;
- (void)closeWithBlock:(HTDatabaseOpenCloseBlock)block;
- (void)isOpenWithBlock:(HTDatabaseOpenCloseBlock)block;

- (void)beginTransactionWithBlock:(HTDatabaseQueryBlock)block;
- (void)commitWithBlock:(HTDatabaseQueryBlock)block;
- (void)rollbackWithBlock:(HTDatabaseQueryBlock)block;

- (void)executeQuery:(NSString *)query withArgumentsInArray:(NSArray *)args block:(HTDatabaseQueryBlock)block;
- (void)executeCachedQuery:(NSString *)sql withArgumentsInArray:(NSArray *)args block:(HTDatabaseQueryBlock)block;

@end

#endif /* HTDatabase_h */
