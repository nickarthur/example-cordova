//
//  NSDictionary+Extension.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 11/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import "NSDictionary+Extension.h"
#import "HTUtility.h"

@implementation NSMutableDictionary (HTExtension)

- (void)ht_setNilSafeObject:(id)object forKey:(id)key {
    if(object == nil || object == [NSNull null] || key == nil) {
        return;
    }
    
    [self setObject:object forKey:key];
}

@end

@implementation NSDictionary (HTExtension)

+ (NSDictionary *)batteryHeader {
    NSDictionary *additionalHeaders = @{@"Battery": [NSString stringWithFormat:@"%@", @([HTUtility batteryLevel])]};
    return additionalHeaders;
}

@end
