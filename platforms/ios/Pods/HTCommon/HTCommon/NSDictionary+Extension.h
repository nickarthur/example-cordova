//
//  NSDictionary+Extension.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 11/12/15.
//  Copyright © 2015 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HTExtension)

- (void)ht_setNilSafeObject:(id _Nullable)object forKey:(id _Nullable)key;

@end

@interface NSDictionary (HTExtension)

@property (nonatomic, readonly, nullable) NSString *jsonString;

+ (NSDictionary * _Nonnull)batteryHeader;

@end
