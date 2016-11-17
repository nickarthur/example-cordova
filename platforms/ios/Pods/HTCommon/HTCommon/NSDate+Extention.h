//
//  NSDate+Extention.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 28/08/15.
//  Copyright (c) 2015 HyperTrack Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HTExtention)

@property (nonatomic, readonly) NSString *ht_stringValue;
@property (nonatomic, readonly) NSString *ht_mediumDateString;
@property (nonatomic, readonly) NSString *ht_mediumTimeString;

+ (NSDate *)ht_dateFromString:(NSString *)dateString;

@end
