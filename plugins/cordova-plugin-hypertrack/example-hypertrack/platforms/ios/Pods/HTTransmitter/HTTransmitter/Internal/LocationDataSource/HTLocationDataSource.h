//
//  HTLocationDataSource.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 18/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTLocationDataSourceProtocol.h"
#import <Foundation/Foundation.h>

@class HTSQLiteDatabase;

@interface HTLocationDataSource : NSObject <HTLocationDataSourceProtocol>

- (instancetype)initWithDatabase:(HTSQLiteDatabase *)database;

@end
