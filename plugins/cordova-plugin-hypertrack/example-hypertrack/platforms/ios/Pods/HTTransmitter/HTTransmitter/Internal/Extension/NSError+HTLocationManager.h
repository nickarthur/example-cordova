//
//  NSError+HTLocationManager.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 13/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (HTLocationManager)

+ (NSError *)ht_locationServicesDisabledError;
+ (NSError *)ht_locationAuthorizationError;
+ (NSError *)ht_infoDictionaryMissingKeyError;

@end
