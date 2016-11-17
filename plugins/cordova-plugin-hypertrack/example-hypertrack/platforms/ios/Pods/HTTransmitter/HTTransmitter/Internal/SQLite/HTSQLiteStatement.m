//
//  HTSQLiteStatement.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 17/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <sqlite3.h>

#import "HTSQLiteStatement.h"

@interface HTSQLiteStatement ()

@property (nonatomic, assign, readwrite) sqlite3_stmt *sqliteStatement;

@end

@implementation HTSQLiteStatement

- (instancetype)initWithStatement:(sqlite3_stmt *)stmt {
    self = [super init];
    if (!stmt || !self) return nil;
    
    self.sqliteStatement = stmt;
    
    return self;
}

- (void)dealloc {
    [self close];
}

- (BOOL)close {
    if (!_sqliteStatement) {
        return YES;
    }
    
    int resultCode = sqlite3_finalize(_sqliteStatement);
    _sqliteStatement = NULL;
    
    return (resultCode == SQLITE_OK || resultCode == SQLITE_DONE);
}

- (BOOL)reset {
    if (!_sqliteStatement) {
        return YES;
    }
    
    int resultCode = sqlite3_reset(_sqliteStatement);
    return (resultCode == SQLITE_OK || resultCode == SQLITE_DONE);
}

@end
