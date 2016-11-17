//
//  NSDateFormatter+HTExtension.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 14/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (HTExtension)

+ (NSDateFormatter *)ht_longISOFormatter;
+ (NSDateFormatter *)ht_shortISOFormatter;

+ (NSDateFormatter *)ht_remoteLoggerFormatter;

@end
