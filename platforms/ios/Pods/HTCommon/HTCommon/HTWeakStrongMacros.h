//
//  HTWeakStrongMacros.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 25/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

/*
 * Based on @weakify() and @strongify() from
 * https://github.com/jspahrsummers/libextc
 */

#ifndef HTWeakStrongMacros_h
#define HTWeakStrongMacros_h

#define WEAK(var) __weak typeof(var) weak_##var = var;
#define STRONG(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = weak_##var; \
_Pragma("clang diagnostic pop") \

#endif /* HTWeakStrongMacros_h */
