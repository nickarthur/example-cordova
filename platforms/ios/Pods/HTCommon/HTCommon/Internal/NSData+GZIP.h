//
//  NSData+GZIP.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 22/10/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

/*
 * Based on GZIP from
 * https://github.com/nicklockwood/GZIP
 */

#import <Foundation/Foundation.h>

@interface NSData (GZIP)

- (nullable NSData *)gzippedDataWithCompressionLevel:(float)level;
- (nullable NSData *)gzippedData;
- (nullable NSData *)gunzippedData;
- (BOOL)isGzippedData;

@end
