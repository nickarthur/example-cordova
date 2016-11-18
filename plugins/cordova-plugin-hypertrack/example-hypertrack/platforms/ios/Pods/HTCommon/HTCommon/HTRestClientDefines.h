//
//  HTRestClientDefines.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 23/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTRestClientDefines_h
#define HTRestClientDefines_h

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

typedef void(^HTRestClientSuccessBlock)(NSInteger statusCode, id responseObject);
typedef void(^HTRestClientFailureBlock)(NSInteger statusCode, id responseObject, NSError *error);
typedef void(^HTRestClientImageSuccessBlock)(NSInteger statusCode, UIImage *image);
typedef void(^HTRestClientImageFailureBlock)(NSInteger statusCode, UIImage *image, NSError *error);

#endif /* HTRestClientDefines_h */
