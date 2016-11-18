//
//  HTBlocks.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 30/08/15.
//  Copyright (c) 2015 HyperTrack Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef HyperTrack_iOS_SDK_Blocks_h
#define HyperTrack_iOS_SDK_Blocks_h

/**
 *  A generic callback to be run with no params.
 */
typedef void(^ _Nullable HTVoidBlock)(void);

/**
 *  A callback to be run with error as expected response.
 *
 *  @param error The error returned from the response, or nil in one occurs.
 */
typedef void(^ _Nullable HTErrorBlock)(NSError * _Nullable error);

#define DispatchMainThread(block, ...) if(block) dispatch_async(dispatch_get_main_queue(), ^{ block(__VA_ARGS__); })
#define InvokeBlock(block, ...) if(block) block(__VA_ARGS__)

#endif
