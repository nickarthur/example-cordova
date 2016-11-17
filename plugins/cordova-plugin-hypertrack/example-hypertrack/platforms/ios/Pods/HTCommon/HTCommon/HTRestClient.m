//
//  HTRestClient.m
//  HTCommon
//
//  Created by Ulhas Mandrawadkar on 29/08/15.
//  Copyright (c) 2015 HyperTrack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HTBlocks.h"
#import "HTConstants.h"
#import "HTError.h"
#import "HyperTrack.h"
#import "NSDate+Extention.h"

#import "HTRestClient.h"

@interface HTRestClient ()

@property (strong, nonatomic, nonnull) NSURLSession *session;
@property (copy, nonatomic, nullable) NSString *baseURL;
@property (copy, nonatomic, nullable) NSString *userAgent;

@end

const NSTimeInterval timeIntervalForRequest = 30;

@implementation HTRestClient

- (instancetype)init {
    return [self initWithBaseURL:nil andUserAgent:nil];
}

- (instancetype)initWithBaseURL:(NSString *)baseURL andUserAgent:(NSString *)userAgent {
    self = [super init];
    if (self) {
        self.userAgent = userAgent;
        self.session = [self urlSession];
        self.baseURL = baseURL;
    }
    
    return self;
}

- (NSURLSession *)urlSession {
    /* Configure session, choose between:
     * defaultSessionConfiguration
     * ephemeralSessionConfiguration
     * backgroundSessionConfigurationWithIdentifier:
     And set session-wide properties, such as: HTTPAdditionalHeaders,
     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
     */
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [self updateAdditionalHTTPHeadersForConfiguration:configuration];
    
    configuration.timeoutIntervalForRequest = timeIntervalForRequest;
    configuration.HTTPMaximumConnectionsPerHost = 5;
    
    return [NSURLSession sessionWithConfiguration:configuration];
}

- (void)updateAdditionalHTTPHeadersForConfiguration:(NSURLSessionConfiguration *)configuration {
    NSDictionary *additionalHTTPHeaders = [NSMutableDictionary dictionary];
    [additionalHTTPHeaders setValue:@"application/json" forKey:@"Content-Type"];
    [additionalHTTPHeaders setValue:@"application/json" forKey:@"Accept"];
    [additionalHTTPHeaders setValue:[self userAgentString] forKey:@"User-Agent"];
    
    configuration.HTTPAdditionalHeaders = additionalHTTPHeaders;
}

- (NSString *)userAgentString {
    UIDevice *device = [UIDevice currentDevice];
    NSString *userAgent = [NSString stringWithFormat:@"HyperTrack (%@ %@) %@/v%@", device.systemName, device.systemVersion, self.userAgent, HTSDKVersion];
    
    return userAgent;
}

- (void)getRequestWithParams:(id)params url:(NSString *)url additionalHeaders:(NSDictionary <NSString *, NSString *> *)additionalHeaders success:(HTRestClientSuccessBlock)success failure:(HTRestClientFailureBlock)failure {
    [self requestWithMethod:@"GET" params:params url:url additionalHeaders:additionalHeaders success:success failure:failure];
}

- (void)postRequestWithParams:(id)params url:(NSString *)url additionalHeaders:(NSDictionary <NSString *, NSString *> *)additionalHeaders success:(HTRestClientSuccessBlock)success failure:(HTRestClientFailureBlock)failure {
    [self requestWithMethod:@"POST" params:params url:url additionalHeaders:additionalHeaders success:success failure:failure];
}

- (void)requestWithMethod:(NSString *)method params:(id)params url:(NSString *)url additionalHeaders:(NSDictionary <NSString *, NSString *> *)additionalHeaders success:(HTRestClientSuccessBlock)success failure:(HTRestClientFailureBlock)failure {
    NSString *urlResource = [NSString stringWithFormat:@"%@%@", self.baseURL, url];
    
    NSURL* URL = [NSURL URLWithString:urlResource];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = method ? : @"GET";
    
    if ([HyperTrack publishableKey]) {
        [request setValue:[NSString stringWithFormat:@"Token %@", [HyperTrack publishableKey]] forHTTPHeaderField:@"Authorization"];
    }
    [request setValue:[NSDate date].ht_stringValue forHTTPHeaderField:@"Device-Time"];
    
    if (params) {
        NSError *writingError = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:0 error:&writingError];
        if (!writingError
            && bodyData) {
            request.HTTPBody = bodyData;
        }
    }
    
    if (additionalHeaders && additionalHeaders.count > 0) {
        NSMutableDictionary *existingHeaders = [request.allHTTPHeaderFields mutableCopy];
        [existingHeaders addEntriesFromDictionary:additionalHeaders];
        request.allHTTPHeaderFields = existingHeaders;
    }
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
                                                     
                                                     id responseObject = nil;
                                                     if (data && data.length > 0) {
                                                         NSError *jsonError = nil;
                                                         responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                          options:NSJSONReadingMutableContainers
                                                                                                            error:&jsonError];
                                                         
                                                         if (jsonError) {
                                                             DispatchMainThread(failure, statusCode, responseObject, jsonError);
                                                         }
                                                     }
                                                     
                                                     if (error == nil) {
                                                         // Success
                                                         if (statusCode >= 200 && statusCode < 400) {
                                                             DispatchMainThread(success, statusCode, responseObject);
                                                         } else {
                                                             error = [NSError errorWithDomain:HTErrorDomain code:statusCode userInfo:nil];
                                                             DispatchMainThread(failure, statusCode, responseObject, error);
                                                         }
                                                     } else {
                                                         // Failure
                                                         DispatchMainThread(failure, statusCode, responseObject, error);
                                                     }
                                                 }];
    [task resume];
}

- (void)getImageWithUrl:(NSString *)url success:(HTRestClientImageSuccessBlock)success failure:(HTRestClientImageFailureBlock)failure {
    /* Create the Request */
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    
    /* Start a new Task */
    NSURLSessionDownloadTask* task = [self.session downloadTaskWithRequest:request
                                                         completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                             NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
                                                             
                                                             UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                             if (image) {
                                                                 DispatchMainThread(success, statusCode, image);
                                                             } else {
                                                                 DispatchMainThread(failure, statusCode, nil, error);
                                                             }
                                                         }];
    [task resume];
}

@end
