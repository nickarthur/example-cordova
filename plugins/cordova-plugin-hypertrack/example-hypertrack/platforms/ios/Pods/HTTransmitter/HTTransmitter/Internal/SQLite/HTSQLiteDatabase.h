//
//  HTSQLiteDatabase.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 17/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTDatabase.h"

@interface HTSQLiteDatabase : NSObject <HTDatabase>

- (instancetype)initWithPath:(NSString *)path queue:(dispatch_queue_t)queue;
+ (instancetype)databaseWithPath:(NSString *)path queue:(dispatch_queue_t)queue;

@end
