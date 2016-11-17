//
//  HTSDKControlsManager.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 14/07/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/HTBlocks.h>
#import "HTSDKControls.h"

#import "HTSDKControlsManager.h"

#pragma mark - HTSDKControls Update

@interface HTSDKControlsUpdate ()

@property (nonatomic, readwrite, assign) BOOL activeStatusChanged;
@property (nonatomic, readwrite, assign) BOOL batchDurationUpdated;
@property (nonatomic, readwrite, assign) BOOL healthDurationUpdated;
@property (nonatomic, readwrite, assign) BOOL accuracyUpdated;
@property (nonatomic, readwrite, assign) BOOL minimumDisplacementUpdated;
@property (nonatomic, readwrite, assign) BOOL minimumDurationUpdated;

@end

@implementation HTSDKControlsUpdate

- (NSString *)description {
    return [NSString stringWithFormat:@"SDK Controls Update: Active Status Changed : %@, Batch Duration Changed : %@, Health Duration Changed : %@, Accuracy Updated : %@, Minimum Displacement Updated : %@, Minimum Duration Updated : %@", @(self.activeStatusChanged), @(self.batchDurationUpdated), @(self.healthDurationUpdated), @(self.accuracyUpdated), @(self.minimumDisplacementUpdated), @(self.minimumDurationUpdated)];
}

@end

#pragma mark - HTSDKControls Manager

@interface HTSDKControlsManager ()

@property (strong, nonatomic, readwrite) HTSDKControls *sdkControls;

@end

@implementation HTSDKControlsManager

- (instancetype)initWithSDKControls:(HTSDKControls *)sdkControls {
    self = [super init];
    if (self) {
        self.sdkControls = sdkControls;
    }
    
    return self;
}

- (void)didReceiveSDKControls:(id)responseObject error:(NSError *)error completion:(HTSDKControlsUpdateBlock)completion {
    HTSDKControlsUpdate *update = [HTSDKControlsUpdate new];
    
    if (error) {
        InvokeBlock(completion, nil, update, error);
    } else {
        if (!responseObject) {
            InvokeBlock(completion, nil, update, nil);
            return;
        }
        
        HTSDKControls *oldControls = self.sdkControls;
        HTSDKControls *newControls = [[HTSDKControls alloc] initWithResponseObject:responseObject];
        
        update.activeStatusChanged = [self activeStatusChangedForNewControls:newControls oldControls:oldControls];
        update.batchDurationUpdated = [self batchDurationUpdatedForNewControls:newControls oldControls:oldControls];
        update.healthDurationUpdated = [self healthDurationUpdatedForNewControls:newControls oldControls:oldControls];
        update.accuracyUpdated = [self accuracyUpdatedForNewControls:newControls oldControls:oldControls];
        update.minimumDisplacementUpdated = [self minimumDisplacementUpdatedForNewControls:newControls oldControls:oldControls];
        update.minimumDurationUpdated = [self minimumDurationUpdatedForNewControls:newControls oldControls:oldControls];
        
        self.sdkControls = newControls;
        
        InvokeBlock(completion, self.sdkControls, update, nil);
    }
}

- (BOOL)activeStatusChangedForNewControls:(HTSDKControls *)newControls oldControls:(HTSDKControls *)oldControls {
    return newControls.isActive.boolValue != oldControls.isActive.boolValue;
}

- (BOOL)batchDurationUpdatedForNewControls:(HTSDKControls *)newControls oldControls:(HTSDKControls *)oldControls {
    return newControls.batchDuration.doubleValue != oldControls.batchDuration.doubleValue;
}

- (BOOL)healthDurationUpdatedForNewControls:(HTSDKControls *)newControls oldControls:(HTSDKControls *)oldControls {
    return newControls.healthDuration.doubleValue != oldControls.healthDuration.doubleValue;
}

- (BOOL)accuracyUpdatedForNewControls:(HTSDKControls *)newControls oldControls:(HTSDKControls *)oldControls {
    return newControls.accuracyLevel != oldControls.accuracyLevel;
}

- (BOOL)minimumDisplacementUpdatedForNewControls:(HTSDKControls *)newControls oldControls:(HTSDKControls *)oldControls {
    return newControls.minimumDisplacement.doubleValue != oldControls.minimumDisplacement.doubleValue;
}

- (BOOL)minimumDurationUpdatedForNewControls:(HTSDKControls *)newControls oldControls:(HTSDKControls *)oldControls {
    return newControls.minimumDuration.doubleValue != oldControls.minimumDuration.doubleValue;
}

@end
