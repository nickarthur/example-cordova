//
//  HTNetworkRequestDataSource.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetworkRequestDataSourceProtocol.h"

@class HTSQLiteDatabase;

@interface HTNetworkRequestDataSource : NSObject <HTNetworkRequestDataSourceProtocol>

- (instancetype)initWithDatabase:(HTSQLiteDatabase *)database;

@end
