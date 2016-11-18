//
//  HTLogMessageTable.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTCommon/HTBlocks.h>
#import "HTDatabaseDataSourceDefines.h"

@protocol HTDatabase;

@interface HTLogMessageTable : NSObject

+ (void)createTableIfDoesNotExist:(id<HTDatabase>)database block:(HTErrorBlock)block;
+ (void)addLogMessage:(NSString *)logMessage database:(id<HTDatabase>)database block:(HTErrorBlock)block;
+ (void)logMessages:(id<HTDatabase>)database block:(HTLogMessageBlock)block;
+ (void)logCount:(id<HTDatabase>)database block:(HTLogMessageCountBlock)block;
+ (void)deleteLogMessage:(id<HTDatabase>)database block:(HTErrorBlock)block;

@end
