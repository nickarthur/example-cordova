//
//  HTRestClientGetImageProtocol.h
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 21/09/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTRestClientGetImageProtocol_h
#define HTRestClientGetImageProtocol_h

#import "HTRestClientDefines.h"

@protocol HTRestClientGetImageProtocol <NSObject>

- (void)getImageWithUrl:(NSString *)url success:(HTRestClientImageSuccessBlock)success failure:(HTRestClientImageFailureBlock)failure;

@end


#endif /* HTRestClientGetImageProtocol_h */
