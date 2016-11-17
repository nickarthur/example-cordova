//
//  HTNetworkRequestManager.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 20/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import <HTCommon/NSDictionary+Extension.h>
#import <HTCommon/HTRestClientGetProtocol.h>
#import <HTCommon/HTRestClientPostProtocol.h>
#import <HTCommon/HTBlocks.h>
#import <HTCommon/HTWeakStrongMacros.h>
#import <HTCommon/HTLoggerProtocol.h>
#import <HTCommon/HTError.h>

#import "HTNetworkRequestProtocol.h"
#import "HTNetworkRequestDataSourceProtocol.h"
#import "HTSocketSubscribable.h"
#import "HTSocketPublishable.h"
#import "HTSocket.h"
#import "HTReachability.h"
#import "NSError+HTNetworkRequestManager.h"

#import "HTNetworkRequestManager.h"

typedef void(^HTNetworkRequestBlock)(id <HTNetworkRequestProtocol> request, id responseObject, NSUInteger statusCode, NSError *error);
typedef void(^HTNetworkRequestRetryBlock)(BOOL retry, BOOL offline);
typedef void(^HTNetworkOfflineBlock) (BOOL offline);

static const NSInteger maxRetryCount = 10;

@interface HTNetworkRequestManager () <HTNetworkRequestDelegate>

@property (nonatomic, strong) id <HTNetworkRequestDataSourceProtocol> dataSource;
@property (nonatomic, strong) NSArray <id <HTNetworkRequestProtocol>> *transientRequests;
@property (nonatomic, strong) id <HTRestClientGetProtocol, HTRestClientPostProtocol> restClient;
@property (nonatomic, strong) HTReachability *reachability;
@property (nonatomic, strong) id<HTLoggerProtocol> logger;
@property (nonatomic, copy) NSArray <HTNetworkRequestManagerStatusBlock> *listeners;
@property (nonatomic, strong) id <HTSocketSubscribable, HTSocketPublishable, HTSocket> socketClient;

@property (nonatomic, assign) BOOL processing;

@end

@implementation HTNetworkRequestManager

#pragma mark - Init Methods

- (instancetype)init {
    return [self initWithDataSource:nil reachability:nil restClient:nil socketClient:nil logger:nil];
}

- (instancetype)initWithDataSource:(id<HTNetworkRequestDataSourceProtocol>)datasource reachability:(HTReachability *)reachability restClient:(id<HTRestClientPostProtocol, HTRestClientGetProtocol>)restClient socketClient:(id<HTSocketPublishable, HTSocketSubscribable, HTSocket>)socketClient logger:(id<HTLoggerProtocol>)logger {
    self = [super init];
    if (self) {
        self.dataSource = datasource;
        self.restClient = restClient;
        self.reachability = reachability;
        self.logger = logger;
        self.socketClient = socketClient;
        [self registerForNotifications];
        self.listeners = @[];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (self.reachability.currentReachabilityStatus != NotReachable) {
                                                          [self.logger info:@"Reachability - Connection is available"];
                                                          [self processCachedRequests];
                                                      } else {
                                                          [self.logger warn:@"Network not reachable"];
                                                      }
                                                  }];
}

#pragma mark - Request Methods

- (void)processRequest:(id<HTNetworkRequestProtocol>)request {
    [self.logger info:@"Processing request. Cached : %@", @(request.cached)];
    
    if (request.cached) {
        [self processRequestWithCaching:request];
    } else {
        [self processRequestWithoutCaching:request];
    }
}

- (void)addRequest:(id<HTNetworkRequestProtocol>)request block:(HTNetworkRequestManagerStatusBlock)block {
    WEAK(self);
    [self.dataSource addNetworkRequest:request block:^(NSInteger requestID, NSError *error) {
        STRONG(self);
        if (error) {
            [self broadcastStatus:HTNetworkRequestStatusError];
            InvokeBlock(block, HTNetworkRequestStatusError);
            return;
        }
        
        [self broadcastStatus:HTNetworkRequestStatusAddedToQueue];
        InvokeBlock(block, HTNetworkRequestStatusAddedToQueue);
    }];
}

- (void)processRequestWithoutCaching:(id<HTNetworkRequestProtocol>)request {
    [self.logger info:@"Processing uncached request"];
    
    [self processNetworkRequest:request block:^(id <HTNetworkRequestProtocol> request, id responseObject, NSUInteger statusCode, NSError * _Nullable error) {
        if (error) {
            [self.logger error:@"Request processing error : %@", error];
            [request processCallbackForResponseObject:responseObject
                                               status:HTNetworkRequestStatusError
                                                error:error];
            return;
        }
        
        [self.logger info:@"Request processed"];
        [request processCallbackForResponseObject:responseObject status:HTNetworkRequestStatusProcessed error:error];
    }];
}

- (void)processRequestWithCaching:(id<HTNetworkRequestProtocol>)request {
    [self.logger info:@"Processing cached request"];
    WEAK(self);
    [self.dataSource addNetworkRequest:request block:^(NSInteger requestID, NSError *error) {
        STRONG(self);
        if (error) {
            [self.logger error:@"Request processing error : %@", error];
            [request processCallbackForResponseObject:nil status:HTNetworkRequestStatusError error:error];
            return;
        }
        
        [self setupTransientRequest:request requestID:requestID];
        [self addTransientRequest:request];
        [self processCachedRequestsWithCompletion:^(BOOL offline) {
            if (offline) {
                [self completeTransientRequest:request responseObject:nil error:[NSError errorForNetworkOutage]];
            }
        }];
    }];
}

- (void)processCachedRequests {
    [self processCachedRequestsWithCompletion:nil];
}

- (void)processCachedRequestsWithCompletion:(HTNetworkOfflineBlock)block {
    if (self.processing) {
        [self.logger info:@"Cached requests already processing. Aborting"];
        return;
    }
    
    [self.dataSource networkRequestsToProcessWithBlock:^(NSArray<id <HTNetworkRequestProtocol>> *requests, NSError *error) {
        if (!requests || requests.count == 0 || error) {
            [self.logger warn:@"Request count : %@", @(requests.count)];
            if (error) {
                [self.logger warn:@"Error getting requests. Error : %@", [error localizedDescription]];
            }
            return;
        }
        
        self.processing = YES;
        [self processNetworkRequests:requests block:^(BOOL processNext, BOOL offline) {
            self.processing = NO;
            if (processNext) {
                [self.logger info:@"Processing next requests"];
                [self broadcastStatus:HTNetworkRequestStatusProcessed];
                [self processCachedRequests];
            } else {
                [self broadcastStatus:HTNetworkRequestStatusError];
                [self.logger error:@"Not processing next. Aborting."];
            }
            
            InvokeBlock(block, offline);
        }];
    }];
}

- (void)processNetworkRequests:(NSArray <id <HTNetworkRequestProtocol>> *)requests block:(HTNetworkRequestRetryBlock)block {
    [self.logger info:@"Process Network Requests. Request Count : %@", @(requests.count)];
    
    for (id <HTNetworkRequestProtocol> request in requests) {
        [self processNetworkRequest:request block:^(id<HTNetworkRequestProtocol> request, id responseObject, NSUInteger statusCode, NSError *error) {
            request.processed = YES;
            
            // If it's a valid request. Complete it.
            if ([self validClientStatusCode:statusCode]) {
                [self completeTransientRequest:request responseObject:responseObject error:error];
                [self completeRequest:request groupedIn:requests block:block];
                
            } else {
                [self.logger warn:@"Response is not valid. Retrying."];
                request.retry = YES;
                
                //If it's an internal server error
                if ([self serverErrorStatusCode:statusCode]) {
                    [self.logger warn:@"Response is internal server error"];
                    
                    if (request.retryCount < maxRetryCount) {
                        [self.logger info:@"Request has not retried enough. incrementing the count"];
                        [self.dataSource incrementRetryCountForRequest:request block:nil];
                        [self didProcessNetworkRequest:requests block:block];
                        
                    } else {
                        [self.logger info:@"Request has retried many times. Completing"];
                        [self completeTransientRequest:request responseObject:responseObject error:error];
                        [self completeRequest:request groupedIn:requests block:block];
                    }
                    
                } else {
                    [self.logger warn:@"Network error. Network Error : %@. Status Code : %@", @(error.networkError), @(statusCode)];
                    request.responseOffline = error.networkError;
                    [self completeTransientRequest:request responseObject:responseObject error:error];
                    [self didProcessNetworkRequest:requests block:block];
                }
            }
        }];
    }
}

- (void)didProcessNetworkRequest:(NSArray <id<HTNetworkRequestProtocol>> *)requests block:(HTNetworkRequestRetryBlock)block {
    if ([self requestsProcessed:requests]) {
        InvokeBlock(block, ![self retryRequests:requests], [self requestsProcessedOffline:requests]);
    }
}

- (void)completeRequest:(id<HTNetworkRequestProtocol>)request groupedIn:(NSArray <id<HTNetworkRequestProtocol>> *)requests block:(HTNetworkRequestRetryBlock)block {
    [self.dataSource completeNetworkRequest:request block:nil];
    [self didProcessNetworkRequest:requests block:block];
}

- (void)processNetworkRequest:(id <HTNetworkRequestProtocol>)request block:(HTNetworkRequestBlock)block {
    if (request.method == HTNetworkRequestMethodTypeGet) {
        [self getNetworkRequest:request block:block];
    } else if (request.method == HTNetworkRequestMethodTypePost){
        [self postNetworkRequest:request block:block];
    } else if (request.method == HTNetworkRequestMethodTypeDelete) {
        [self deleteNetworkRequest:request block:block];
    }
}

#pragma mark - Post Type Methods

- (void)postNetworkRequest:(id <HTNetworkRequestProtocol>)request block:(HTNetworkRequestBlock)block {
    [self.socketClient restoreSocketConnectionIfBroken];
    
    if (request.type == HTNetworkRequestTypeMQTT && self.socketClient.connected) {
        [self postNetworkRequestViaMQTTClient:request block:block];
    } else {
        [self postNetworkRequestViaRestClient:request block:block];
    }
}

- (void)postNetworkRequestViaMQTTClient:(id <HTNetworkRequestProtocol>)request block:(HTNetworkRequestBlock)block {
    [self.socketClient publishParams:request.params onTopic:request.topic completion:^(NSError * _Nullable error) {
        if (error) {
            [self.logger error:@"MQTT Broker Publish error. Error : %@", error];
        }
        
        InvokeBlock(block, request, nil, (error == nil) ? HTNetworkResponseStatusCodeNoContent : error.code, error);
    }];
}

- (void)postNetworkRequestViaRestClient:(id <HTNetworkRequestProtocol>)request block:(HTNetworkRequestBlock)block {
    NSDictionary *additionalHeaders = [NSDictionary batteryHeader];
    [self.restClient postRequestWithParams:request.params
                                       url:request.APIString
                         additionalHeaders:additionalHeaders
                                   success:^(NSInteger statusCode, id responseObject) {
                                       InvokeBlock(block, request, responseObject, statusCode, nil);
                                   } failure:^(NSInteger statusCode, id responseObject, NSError *error) {
                                        InvokeBlock(block, request, responseObject, statusCode, error);
                                   }];
}

#pragma mark - Get Type Methods

- (void)getNetworkRequest:(id <HTNetworkRequestProtocol>)request block:(HTNetworkRequestBlock)block {
    if (request.type == HTNetworkRequestTypeMQTT) {
        [self getNetworkRequestViaMQTTClient:request block:block];
    } else {
        [self getNetworkRequestViaRestClient:request block:block];
    }
}

- (void)getNetworkRequestViaRestClient:(id <HTNetworkRequestProtocol>)request block:(HTNetworkRequestBlock)block {
    NSDictionary *additionalHeaders = [NSDictionary batteryHeader];
    [self.restClient getRequestWithParams:request.params
                                      url:request.APIString
                        additionalHeaders:additionalHeaders
                                  success:^(NSInteger statusCode, id responseObject) {
                                      InvokeBlock(block, request, responseObject, statusCode, nil);
                                  } failure:^(NSInteger statusCode, id responseObject, NSError *error) {
                                      InvokeBlock(block, request, responseObject, statusCode, error);
                                  }];
}

- (void)getNetworkRequestViaMQTTClient:(id <HTNetworkRequestProtocol>)request block:(HTNetworkRequestBlock)block {
    [self.socketClient subscribeToTopic:request.topic messageHandler:request.messageHandler subscriptionHandler:^(NSError * _Nullable error) {
        if (error) {
            [self.logger error:@"MQTT Broker Publish error. Error : %@", error];
        }
        
        InvokeBlock(block, request, nil, (error == nil) ? HTNetworkResponseStatusCodeNoContent : error.code, error);
    }];
}

#pragma mark - Delete Type Methods

- (void)deleteNetworkRequest:(id <HTNetworkRequestProtocol>)request block:(HTNetworkRequestBlock)block {
    if (request.type == HTNetworkRequestTypeMQTT) {
        [self deleteNetworkRequestViaMQTTClient:request block:block];
    }
}

- (void)deleteNetworkRequestViaMQTTClient:(id <HTNetworkRequestProtocol>)request block:(HTNetworkRequestBlock)block {
    [self.socketClient unsubscribeFromTopic:request.topic];
    InvokeBlock(block, nil, nil, HTNetworkResponseStatusCodeNoContent, nil);
}

#pragma mark - Requests Flag Methods

- (BOOL)requestsProcessed:(NSArray <id <HTNetworkRequestProtocol>> *)requests {
    BOOL processed = YES;
    for (id <HTNetworkRequestProtocol> request in requests) {
        if (!request.processed) {
            processed = NO;
            break;
        }
    }
    
    return processed;
}

- (BOOL)retryRequests:(NSArray <id <HTNetworkRequestProtocol>> *)requests {
    BOOL retry = NO;
    for (id <HTNetworkRequestProtocol> request in requests) {
        if (request.retry) {
            retry = YES;
            break;
        }
    }
    
    return retry;
}

- (BOOL)requestsProcessedOffline:(NSArray <id <HTNetworkRequestProtocol>> *)requests {
    BOOL processed = YES;
    for (id <HTNetworkRequestProtocol> request in requests) {
        if (!request.processed) {
            processed = NO;
            break;
        }
    }
    
    return processed;
}

#pragma mark - Transient Request Methods

- (void)completeTransientRequest:(id<HTNetworkRequestProtocol>)request responseObject:(id)responseObject error:(NSError *)error {
    id <HTNetworkRequestProtocol> transientRequest = [self transientRequestForRequest:request];
    if (transientRequest) {
        [transientRequest processCallbackForResponseObject:responseObject status:HTNetworkRequestStatusProcessed error:error];
        [transientRequest cancel];
        [self removeTransientRequest:transientRequest];
    }
}

- (void)setupTransientRequest:(id <HTNetworkRequestProtocol>)request requestID:(HTNetworkRequestID)requestID {
    request.requestID = requestID;
    request.delegate = self;
    [request startTimerForTimeOut];
}

- (id <HTNetworkRequestProtocol>)transientRequestForRequest:(id <HTNetworkRequestProtocol>)request {
    __block id <HTNetworkRequestProtocol> transientRequest;
    [self.transientRequests enumerateObjectsUsingBlock:^(id<HTNetworkRequestProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.requestID == request.requestID) {
            transientRequest = obj;
            *stop = YES;
        }
    }];
    
    return transientRequest;
}

- (void)addTransientRequest:(id <HTNetworkRequestProtocol>)request {
    if (!request) {
        return;
    }
    
    NSMutableArray <id <HTNetworkRequestProtocol>> *requests = [NSMutableArray arrayWithArray:self.transientRequests];
    [requests addObject:request];
    self.transientRequests = requests;
}

- (void)removeTransientRequest:(id <HTNetworkRequestProtocol>)request {
    if (!request) {
        return;
    }
    
    NSMutableArray <id <HTNetworkRequestProtocol>> *requests = [NSMutableArray arrayWithArray:self.transientRequests];
    [requests removeObject:request];
    self.transientRequests = requests;
}

#pragma mark - Network Request Delegate Methods

- (void)networkRequestTimedOut:(id<HTNetworkRequestProtocol>)request {
    [request processCallbackForResponseObject:nil status:HTNetworkRequestStatusTimedOut error:[NSError errorForRequestTimeout]];
    [request cancel];
    
    [self removeTransientRequest:request];
}

#pragma mark - Listener Methods

- (void)addListener:(HTNetworkRequestManagerStatusBlock)listener {
    if (!listener) {
        return;
    }
    
    NSMutableArray <HTNetworkRequestManagerStatusBlock> *listeners = [NSMutableArray arrayWithArray:self.listeners];
    [listeners addObject:listener];
    self.listeners = listeners;
}

- (void)removeListener:(HTNetworkRequestManagerStatusBlock)listener {
    if (!listener) {
        return;
    }
    
    NSMutableArray <HTNetworkRequestManagerStatusBlock> *listeners = [NSMutableArray arrayWithArray:self.listeners];
    [listeners removeObject:listener];
    self.listeners = listeners;
}

- (void)broadcastStatus:(HTNetworkRequestStatus)status {
    for (HTNetworkRequestManagerStatusBlock listener in self.listeners) {
        InvokeBlock(listener, status);
    }
}

#pragma mark - Error Methods

- (BOOL)validClientStatusCode:(NSUInteger)statusCode {
    return (statusCode >= HTNetworkResponseStatusCodeOK
            && statusCode < HTNetworkResponseStatusCodeInternalServerError);
}

- (BOOL)serverErrorStatusCode:(NSUInteger)statusCode {
    return (statusCode >= HTNetworkResponseStatusCodeInternalServerError
            && statusCode <= HTNetworkResponseStatusCodeMaxServerError);
}

@end
