//
//  HTLogDataSource.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 19/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTLogDataSource_h
#define HTLogDataSource_h

#import <Foundation/Foundation.h>

@protocol HTLogDataSource <NSObject>

- (void)logMessage:(NSString *)message;

@end

#endif /* HTLogDataSource_h */
