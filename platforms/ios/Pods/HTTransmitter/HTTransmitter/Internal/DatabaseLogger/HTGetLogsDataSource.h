//
//  HTGetLogsDataSource.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTGetLogsDataSource_h
#define HTGetLogsDataSource_h


#import <HTCommon/HTBlocks.h>
#import "HTDatabaseDataSourceDefines.h"

@protocol HTGetLogDataSource <NSObject>

- (void)logCount:(HTLogMessageCountBlock)block;
- (void)logMessages:(HTLogMessageBlock)block;
- (void)deleteMessages:(HTErrorBlock)block;

@end

#endif /* HTGetLogsDataSource_h */
