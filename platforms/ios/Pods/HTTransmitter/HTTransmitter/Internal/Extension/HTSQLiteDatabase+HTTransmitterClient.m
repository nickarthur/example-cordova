//
//  HTSQLiteDatabase+HTTransmitterClient.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTDispatchQueue.h"
#import "HTSQLiteDatabase+HTTransmitterClient.h"

static NSString * const DATABASE_NAME = @"hypertrack-transmitter.sqlite3";

@implementation HTSQLiteDatabase (HTTransmitterClient)

+ (HTSQLiteDatabase *)databaseForTransmitterClient {
    NSArray <NSString *> *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = directories.firstObject;
    
    return [[HTSQLiteDatabase alloc] initWithPath:[documentDirectoryPath stringByAppendingPathComponent:DATABASE_NAME]
                                            queue:[HTDispatchQueue threadSafeQueueForClass:[HTSQLiteDatabase class]]];
}

@end
