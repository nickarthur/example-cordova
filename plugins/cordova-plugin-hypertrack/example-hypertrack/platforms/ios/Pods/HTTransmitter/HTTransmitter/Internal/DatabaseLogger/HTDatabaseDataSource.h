//
//  HTDatabaseDataSource.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTCommon/HTLogDataSource.h>
#import "HTDatabaseDataSourceDefines.h"
#import "HTGetLogsDataSource.h"

@protocol HTDatabase;

@interface HTDatabaseDataSource : NSObject <HTLogDataSource, HTGetLogDataSource>

- (instancetype)initWithDatabase:(id<HTDatabase>)database;

@end
