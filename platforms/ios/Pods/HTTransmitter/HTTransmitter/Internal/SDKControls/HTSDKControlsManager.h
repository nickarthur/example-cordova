//
//  HTSDKControlsManager.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 14/07/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTNetworkRequestManager;
@class HTSDKControls;
@class HTSDKControlsUpdate;

typedef void(^HTSDKControlsUpdateBlock)(HTSDKControls *sdkControls, HTSDKControlsUpdate *update, NSError *error);

#pragma mark - HTSDKControls Update

@interface HTSDKControlsUpdate : NSObject

@property (nonatomic, readonly, assign) BOOL activeStatusChanged;
@property (nonatomic, readonly, assign) BOOL batchDurationUpdated;
@property (nonatomic, readonly, assign) BOOL healthDurationUpdated;
@property (nonatomic, readonly, assign) BOOL accuracyUpdated;
@property (nonatomic, readonly, assign) BOOL minimumDisplacementUpdated;
@property (nonatomic, readonly, assign) BOOL minimumDurationUpdated;

@end

#pragma mark - HTSDKControls Manager

@interface HTSDKControlsManager : NSObject

@property (strong, nonatomic, readonly) HTSDKControls *sdkControls;

- (instancetype)initWithSDKControls:(HTSDKControls *)sdkControls;
- (void)didReceiveSDKControls:(id)responseObject error:(NSError *)error completion:(HTSDKControlsUpdateBlock)completion;

@end
