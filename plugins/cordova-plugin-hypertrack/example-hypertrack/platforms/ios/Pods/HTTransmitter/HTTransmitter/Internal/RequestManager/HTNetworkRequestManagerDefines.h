//
//  HTNetworkRequestManagerDefines.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTNetworkRequestManagerDefines_h
#define HTNetworkRequestManagerDefines_h

typedef NS_ENUM(NSInteger, HTNetworkRequestMethodType) {
    HTNetworkRequestMethodTypeGet = 0,
    HTNetworkRequestMethodTypePost,
    HTNetworkRequestMethodTypeDelete
};

typedef NS_ENUM(NSInteger, HTNetworkRequestStatus) {
    HTNetworkRequestStatusAddedToQueue = 0,
    HTNetworkRequestStatusProcessed,
    HTNetworkRequestStatusTimedOut,
    HTNetworkRequestStatusError,
};

typedef NS_ENUM(NSUInteger, HTNetworkResponseStatusCode) {
    HTNetworkResponseStatusCodeOK = 200,
    HTNetworkResponseStatusCodeCreated = 201,
    HTNetworkResponseStatusCodeNoContent = 204,
    HTNetworkResponseStatusCodeBadRequest = 400,
    HTNetworkResponseStatusCodeInternalServerError = 500,
    HTNetworkResponseStatusCodeMaxServerError = 599
};

/** A unique ID that corresponds to one network request. */
typedef NSInteger HTNetworkRequestID;

@protocol HTNetworkRequestProtocol;

typedef void(^HTNetworkRequestQueueBlock)(NSArray <id <HTNetworkRequestProtocol>> *requests, NSError *error);
typedef void(^HTNetworkRequestAddBlock)(NSInteger requestID, NSError *error);
typedef void(^HTNetworkRequestCountBlock)(NSInteger count, NSError *error);

#endif /* HTNetworkRequestManagerDefines_h */
