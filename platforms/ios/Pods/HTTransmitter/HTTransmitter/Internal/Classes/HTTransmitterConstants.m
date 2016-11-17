//
//  HTTransmitterConstants.m
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 09/01/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTTransmitterConstants.h"

#ifdef PRODUCTION
NSString * const HTTransmitterHTTPHost              = @"app.hypertrack.io";
#else
NSString * const HTTransmitterHTTPHost              = @"hypertrack-api-v2-staging.herokuapp.com";
#endif

#ifdef PRODUCTION
NSString * const HTTransmitterMQTTHost              = @"ec2-52-90-251-227.compute-1.amazonaws.com";
#else
NSString * const HTTransmitterMQTTHost              = @"ec2-52-90-251-227.compute-1.amazonaws.com";
#endif

#ifdef PRODUCTION
NSString * const HTTransmitterTopicPrefix           = @"";
#else
NSString * const HTTransmitterTopicPrefix           = @"Staging/";
#endif

NSString * const HTTransmitterUserAgent             = @"TransmitterSDK";
NSInteger const LOCATION_BATCH_LIMIT = 100;
