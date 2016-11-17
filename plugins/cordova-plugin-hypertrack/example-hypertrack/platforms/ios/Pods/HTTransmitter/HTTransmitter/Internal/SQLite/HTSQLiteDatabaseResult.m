//
//  HTSQLiteDatabaseResult.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 17/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <sqlite3.h>
#import "HTSQLiteStatement.h"

#import "HTSQLiteDatabaseResult.h"

@interface HTSQLiteDatabaseResult ()

@property (nonatomic, copy, readonly) NSDictionary *columnNameToIndexMap;
@property (nonatomic, strong, readwrite) HTSQLiteStatement *statement;

@end

@implementation HTSQLiteDatabaseResult

@synthesize columnNameToIndexMap = _columnNameToIndexMap;

- (instancetype)initWithStatement:(HTSQLiteStatement *)stmt {
    if ((self = [super init])) {
        self.statement = stmt;
    }
    return self;
}

- (BOOL)next {
    return [self step] == SQLITE_ROW;
}

- (int)step {
    return sqlite3_step([self.statement sqliteStatement]);
}

- (BOOL)close {
    return [self.statement close];
}

- (BOOL)reset {
    return [self.statement reset];
}

- (int)intForColumn:(NSString *)columnName {
    return [self intForColumnIndex:[self columnIndexForName:columnName]];
}

- (int)intForColumnIndex:(int)columnIndex {
    return sqlite3_column_int([self.statement sqliteStatement], columnIndex);
}

- (long)longForColumn:(NSString *)columnName {
    return [self longForColumnIndex:[self columnIndexForName:columnName]];
}

- (long)longForColumnIndex:(int)columnIndex {
    return (long)sqlite3_column_int64([self.statement sqliteStatement], columnIndex);
}

- (BOOL)boolForColumn:(NSString *)columnName {
    return [self boolForColumnIndex:[self columnIndexForName:columnName]];
}

- (BOOL)boolForColumnIndex:(int)columnIndex {
    return ([self intForColumnIndex:columnIndex] != 0);
}

- (double)doubleForColumn:(NSString *)columnName {
    return [self doubleForColumnIndex:[self columnIndexForName:columnName]];
}

- (double)doubleForColumnIndex:(int)columnIndex {
    return sqlite3_column_double([self.statement sqliteStatement], columnIndex);
}

- (NSString *)stringForColumn:(NSString *)columnName {
    return [self stringForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSString *)stringForColumnIndex:(int)columnIndex {
    if ([self columnIndexIsNull:columnIndex]) {
        return nil;
    }
    
    const char *str = (const char *)sqlite3_column_text([self.statement sqliteStatement], columnIndex);
    if (!str) {
        return nil;
    }
    return [NSString stringWithUTF8String:str];
}

- (NSDate *)dateForColumn:(NSString *)columnName {
    return [self dateForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate *)dateForColumnIndex:(int)columnIndex {
    return [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIndex]];
}

- (NSData *)dataForColumn:(NSString *)columnName {
    return [self dataForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData *)dataForColumnIndex:(int)columnIndex {
    if ([self columnIndexIsNull:columnIndex]) {
        return nil;
    }
    
    int size = sqlite3_column_bytes([self.statement sqliteStatement], columnIndex);
    const char *buffer = sqlite3_column_blob([self.statement sqliteStatement], columnIndex);
    if (buffer == nil) {
        return nil;
    }
    return [NSData dataWithBytes:buffer length:size];
}

- (id)objectForColumn:(NSString *)columnName {
    return [self objectForColumnIndex:[self columnIndexForName:columnName]];
}

- (id)objectForColumnIndex:(int)columnIndex {
    int columnType = sqlite3_column_type([self.statement sqliteStatement], columnIndex);
    switch (columnType) {
        case SQLITE_INTEGER:
            return @([self longForColumnIndex:columnIndex]);
        case SQLITE_FLOAT:
            return @([self doubleForColumnIndex:columnIndex]);
        case SQLITE_BLOB:
            return [self dataForColumnIndex:columnIndex];
        default:
            return [self stringForColumnIndex:columnIndex];
    }
}

- (BOOL)columnIsNull:(NSString *)columnName {
    return [self columnIndexIsNull:[self columnIndexForName:columnName]];
}

- (BOOL)columnIndexIsNull:(int)columnIndex {
    return (sqlite3_column_type([self.statement sqliteStatement], columnIndex) == SQLITE_NULL);
}

- (int)columnIndexForName:(NSString *)columnName {
    NSNumber *index = self.columnNameToIndexMap[columnName.lowercaseString];
    if (index) {
        return index.intValue;
    }
    // not found
    return -1;
}

- (NSDictionary *)columnNameToIndexMap {
    if (!_columnNameToIndexMap) {
        int columnCount = sqlite3_column_count(self.statement.sqliteStatement);
        NSMutableDictionary *mutableColumnNameToIndexMap = [[NSMutableDictionary alloc] initWithCapacity:columnCount];
        for (int i = 0; i < columnCount; ++i) {
            NSString *key = [NSString stringWithUTF8String:sqlite3_column_name(self.statement.sqliteStatement, i)];
            mutableColumnNameToIndexMap[key.lowercaseString] = @(i);
        }
        _columnNameToIndexMap = mutableColumnNameToIndexMap;
    }
    return _columnNameToIndexMap;
}


@end
