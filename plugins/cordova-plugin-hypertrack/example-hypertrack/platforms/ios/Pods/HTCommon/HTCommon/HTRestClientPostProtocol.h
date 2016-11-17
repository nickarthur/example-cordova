//
//  HTRestClientPostProtocol.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 23/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTRestClientPostProtocol_h
#define HTRestClientPostProtocol_h

#import "HTRestClientDefines.h"

@protocol HTRestClientPostProtocol <NSObject>

- (void)postRequestWithParams:(id)params url:(NSString *)url additionalHeaders:(NSDictionary <NSString *, NSString *> *)additionalHeaders success:(HTRestClientSuccessBlock)success failure:(HTRestClientFailureBlock)failure;

@end


#endif /* HTRestClientPostProtocol_h */
