//
//  HTRestClientGetProtocol.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 23/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTRestClientGetProtocol_h
#define HTRestClientGetProtocol_h

#import "HTRestClientDefines.h"

@protocol HTRestClientGetProtocol <NSObject>

- (void)getRequestWithParams:(id)params url:(NSString *)url additionalHeaders:(NSDictionary <NSString *, NSString *> *)additionalHeaders success:(HTRestClientSuccessBlock)success failure:(HTRestClientFailureBlock)failure;

@end

#endif /* HTRestClientGetProtocol_h */
