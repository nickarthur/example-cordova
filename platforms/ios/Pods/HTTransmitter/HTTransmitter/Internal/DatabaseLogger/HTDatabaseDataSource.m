//
//  HTDatabaseDataSource.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTDatabaseDataSource.h"
#import "HTDatabase.h"
#import "HTLogMessageTable.h"

@interface HTDatabaseDataSource ()

@property (nonatomic, nullable, strong) id<HTDatabase> database;

@end

@implementation HTDatabaseDataSource

- (instancetype)initWithDatabase:(id<HTDatabase>)database {
    self = [super init];
    if (self) {
        self.database = database;
        [self.database openWithBlock:^(BOOL result, NSError *error) {
            [HTLogMessageTable createTableIfDoesNotExist:self.database block:nil];
        }];
    }
    
    return self;
}

- (void)logMessage:(NSString *)message {
    [HTLogMessageTable addLogMessage:message database:self.database block:nil];
}

- (void)logMessages:(HTLogMessageBlock)block {
    [HTLogMessageTable logMessages:self.database block:block];
}

- (void)logCount:(HTLogMessageCountBlock)block {
    [HTLogMessageTable logCount:self.database block:block];
}

- (void)deleteMessages:(HTErrorBlock)block {
    [HTLogMessageTable deleteLogMessage:self.database block:block];
}

@end
