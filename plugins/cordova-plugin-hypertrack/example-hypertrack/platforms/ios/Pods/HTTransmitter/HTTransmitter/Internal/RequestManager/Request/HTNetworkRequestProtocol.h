//
//  HTNetworkRequestProtocol.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#ifndef HTNetworkRequestProtocol_h
#define HTNetworkRequestProtocol_h

#import <HTCommon/HTBlocks.h>
#import "HTNetworkRequestManagerDefines.h"

/**
 *  A callback to be run with error as expected response.
 *
 *  @param error The error returned from the response, or nil in one occurs.
 */
typedef void(^HTNetworkResponseStatusBlock)(id responseObject, HTNetworkRequestStatus status, NSError *error);

/**
 *  A callback to be run with error as expected response.
 *
 *  @param  responseObject  Response object
 *  @param error The error returned from the response, or nil in one occurs.
 */
typedef void(^HTNetworkResponseBlock)(id responseObject, NSError *error);

@protocol HTNetworkRequestProtocol;

@protocol HTNetworkRequestDelegate <NSObject>

- (void)networkRequestTimedOut:(id <HTNetworkRequestProtocol>)request;

@end

typedef NS_ENUM(NSUInteger, HTNetworkRequestType) {
    /**
     *  HTTP
     */
    HTNetworkRequestTypeHTTP = 0,
    /**
     *  MQTT
     */
    HTNetworkRequestTypeMQTT
};

@protocol HTNetworkRequestProtocol <NSObject, NSCoding>

/**
 *  Database maintained properties
 **/
@property (nonatomic, assign) HTNetworkRequestID requestID;
@property (nonatomic, assign) NSInteger retryCount;

/**
 *  Not serialized
 **/
@property (nonatomic, weak) id <HTNetworkRequestDelegate> delegate;
@property (nonatomic, assign) BOOL processed;
@property (nonatomic, assign) BOOL retry;
@property (nonatomic, copy, readonly) HTNetworkResponseStatusBlock callback;
@property (nonatomic, assign) BOOL responseOffline;

/**
 *  Serialized
 **/
@property (nonatomic, assign) BOOL parallel;
@property (nonatomic, assign) BOOL cached;
@property (nonatomic, assign) BOOL hasTimeout;
@property (nonatomic, assign, readonly) HTNetworkRequestMethodType method;
@property (nonatomic, copy, readonly) NSString *APIString;
@property (nonatomic, copy, readonly) id params;

/**
 *  Serialized & Socket 
 **/
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, assign) HTNetworkRequestType type;

/**
 *  Not Serialized & Socket
 */
@property (nonatomic, copy, readonly) HTNetworkResponseBlock messageHandler;

- (instancetype)initWithMethodType:(HTNetworkRequestMethodType)method APIString:(NSString *)APIString params:(id)params callback:(HTNetworkResponseStatusBlock)callback;
- (instancetype)initWithTopic:(NSString *)topic messageHandler:(HTNetworkResponseBlock)messageHandler callback:(HTNetworkResponseStatusBlock)callback;
- (instancetype)initWithTopicToDelete:(NSString *)topic;

- (void)startTimerForTimeOut;
- (void)cancel;
- (void)processCallbackForResponseObject:(id)responseObject status:(HTNetworkRequestStatus)status error:(NSError *)error;

@end

#endif /* HTNetworkRequest_h */
