//
//  HTSQLiteStatement.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 17/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct sqlite3_stmt sqlite3_stmt;

@interface HTSQLiteStatement : NSObject

@property (nonatomic, assign, readonly) sqlite3_stmt *sqliteStatement;

- (instancetype)initWithStatement:(sqlite3_stmt *)stmt;

- (BOOL)close;
- (BOOL)reset;

@end
