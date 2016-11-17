//
//  HTDatabaseDataSourceDefines.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTDatabaseDataSourceDefines_h
#define HTDatabaseDataSourceDefines_h

#import <Foundation/Foundation.h>

typedef void(^HTLogMessageBlock)(NSArray <NSString *> *logMessages, NSError *error);
typedef void(^HTLogMessageCountBlock)(NSUInteger count, NSError *error);

#endif /* HTDatabaseDataSourceDefines_h */
