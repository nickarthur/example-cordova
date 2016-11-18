//
//  NSDictionary+Extension.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 11/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HTExtension)

- (void)ht_setNilSafeObject:(id)object forKey:(id)key;

@end

@interface NSDictionary (HTExtension)

+ (NSDictionary *)batteryHeader;

@end
