//
//  HTSQLiteDatabaseResult.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 17/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTSQLiteStatement;

@interface HTSQLiteDatabaseResult : NSObject

- (instancetype)initWithStatement:(HTSQLiteStatement *)statement;

/**
 Move current result to next row. Returns true if next result exists. False if current result
 is the end of result set.
 */
- (BOOL)next;

/**
 Move the current result to next row, and returns the raw SQLite return code for the cursor.
 Useful for detecting end of cursor vs. error.
 */
- (int)step;

/**
 Closes the database result.
 */
- (BOOL)close;

/**
 * Resets the data result.
 */
- (BOOL)reset;

///--------------------------------------
#pragma mark - Get Column Value
///--------------------------------------

- (int)intForColumn:(NSString *)columnName;
- (int)intForColumnIndex:(int)columnIndex;

- (long)longForColumn:(NSString *)columnName;
- (long)longForColumnIndex:(int)columnIndex;

- (BOOL)boolForColumn:(NSString *)columnName;
- (BOOL)boolForColumnIndex:(int)columnIndex;

- (double)doubleForColumn:(NSString *)columnName;
- (double)doubleForColumnIndex:(int)columnIndex;

- (NSString *)stringForColumn:(NSString *)columnName;
- (NSString *)stringForColumnIndex:(int)columnIndex;

- (NSDate *)dateForColumn:(NSString *)columnName;
- (NSDate *)dateForColumnIndex:(int)columnIndex;

- (NSData *)dataForColumn:(NSString *)columnName;
- (NSData *)dataForColumnIndex:(int)columnIndex;

- (id)objectForColumn:(NSString *)columnName;
- (id)objectForColumnIndex:(int)columnIndex;

- (BOOL)columnIsNull:(NSString *)columnName;
- (BOOL)columnIndexIsNull:(int)columnIndex;

@end
