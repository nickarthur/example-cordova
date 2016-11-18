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
    if(object == nil || object == [NSNull null] || key == nil || key == [NSNull null]) {
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

- (NSString *)jsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if (!jsonData || error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
