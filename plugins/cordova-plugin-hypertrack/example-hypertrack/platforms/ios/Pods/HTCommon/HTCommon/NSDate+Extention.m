//
//  NSDate+Extention.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 28/08/15.
//  Copyright (c) 2015 HyperTrack Inc. All rights reserved.
//

#import "NSDateFormatter+HTExtension.h"

#import "NSDate+Extention.h"

@implementation NSDate (HTExtention)

+ (NSDate *)ht_dateFromString:(NSString *)dateString {
    
    NSDate *date = [[NSDateFormatter ht_longISOFormatter] dateFromString:dateString];
    
    if (!date) {
        date = [[NSDateFormatter ht_shortISOFormatter] dateFromString:dateString];
    }
    
    return date;
}

- (NSString *)ht_mediumDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    
    return [formatter stringFromDate:self];
}

- (NSString *)ht_mediumTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    return [formatter stringFromDate:self];
}

- (NSString *)ht_stringValue {
    return [[NSDateFormatter ht_longISOFormatter] stringFromDate:self];
}

@end
