/********* HyperTrack.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <HTCommon/HyperTrack.h>
#import <HTTransmitter/HTTransmitter.h>

@interface HyperTrackWrapper : CDVPlugin {
  // Member variables go here.
}

- (void)helloWorld:(CDVInvokedUrlCommand*)command;
- (void)startTrip:(CDVInvokedUrlCommand*)command;
- (void)completeTask:(CDVInvokedUrlCommand*)command;
- (void)endTrip:(CDVInvokedUrlCommand*)command;
- (void)startShift:(CDVInvokedUrlCommand*)command;
- (void)endShift:(CDVInvokedUrlCommand*)command;
- (void)isTransmitting:(CDVInvokedUrlCommand*)command;
- (void)getActiveDriver:(CDVInvokedUrlCommand*)command;
- (void)connectDriver:(CDVInvokedUrlCommand*)command;
- (void)getPublishableKey:(CDVInvokedUrlCommand*)command;

@end

@implementation HyperTrackWrapper

- (void)pluginInitialize
{
    [self setPk];
}

- (void)setPk
{
    NSString* publishableKey = [self.commandDelegate.settings objectForKey:[@"HYPERTRACK_PK" lowercaseString]];
    [HyperTrack setPublishableAPIKey:publishableKey];
}

- (void)helloWorld:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startTrip:(CDVInvokedUrlCommand*)command
{
    [self setPk];
    NSString* driverID = [command.arguments objectAtIndex:0];
    NSMutableArray* taskIDs = [command.arguments objectAtIndex:1];

    __block CDVPluginResult* pluginResult = nil;

    HTTripParams* tripParams = [[HTTripParams alloc] init];
    tripParams.driverID = driverID;
    tripParams.taskIDs = taskIDs;

    [[HTTransmitterClient sharedClient] startTripWithTripParams:tripParams completion:^(HTResponse <HTTrip *> * _Nullable response, NSError * _Nullable error) {
        if (error) {
            // Handle error and try again.
            NSDictionary *failure = @{@"error" : error.localizedDescription};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:failure];
        } else {
            // If there is no error, use the tripID received in the callback in your app.
            NSDictionary *success = @{@"trip" : response.result.dictionaryValue.jsonString};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:success];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)startShift:(CDVInvokedUrlCommand*)command
{
    NSString* driverID = [command.arguments objectAtIndex:0];
    __block CDVPluginResult* pluginResult = nil;

    HTShiftParams *shiftParams = [[HTShiftParams alloc] init];
    shiftParams.driverID = driverID;

    [[HTTransmitterClient sharedClient] startShiftWithShiftParams:shiftParams completion:^(HTResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            // Handle error and try again.
            NSDictionary *failure = @{@"error" : error.localizedDescription};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:failure];
        } else {
            // If there is no error, use the tripID received in the callback in your app.
            NSDictionary *success = @{@"shift" : @""};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:success];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)completeTask:(CDVInvokedUrlCommand*)command
{
    [self setPk];
    NSString* taskID = [command.arguments objectAtIndex:0];
    __block CDVPluginResult* pluginResult = nil;
    [[HTTransmitterClient sharedClient] completeTaskWithTaskID:taskID completion:^(HTResponse <HTTask *> * _Nullable response, NSError * _Nullable error) {

        if (error) {
            // Handle error and try again.
            NSDictionary *failure = @{@"error" : error.localizedDescription};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:failure];
        } else {
            // If there is no error, use the taskID received in the callback in your app.
            NSDictionary *success = @{@"task" : response.result.dictionaryValue.jsonString};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:success];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)endTrip:(CDVInvokedUrlCommand*)command
{
    [self setPk];
    NSString* tripID = [command.arguments objectAtIndex:0];
    __block CDVPluginResult* pluginResult = nil;
    [[HTTransmitterClient sharedClient] endTripWithTripID:tripID completion:^(HTResponse <HTTask *> * _Nullable response, NSError * _Nullable error) {

        if (error) {
            // Handle error and try again.
            NSDictionary *failure = @{@"error" : error.localizedDescription};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:failure];
        } else {
            // If there is no error, use the taskID received in the callback in your app.
            NSDictionary *success = @{@"trip" : response.result.dictionaryValue.jsonString};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:success];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)endShift:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    [[HTTransmitterClient sharedClient] endShiftWithCompletion:^(HTResponse * _Nullable response, NSError * _Nullable error) {

        if (error) {
            // Handle error and try again.
            NSDictionary *failure = @{@"error" : error.localizedDescription};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:failure];
        } else {
            // If there is no error, use the taskID received in the callback in your app.
            NSDictionary *success = @{@"shift" : @""};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:success];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)isTransmitting:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                       messageAsBool:[[HTTransmitterClient sharedClient] transmitingLocation]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getActiveDriver:(CDVInvokedUrlCommand*)command
{
    NSString *driverID = [[HTTransmitterClient sharedClient] activeDriverID];

    if (!driverID) {
        driverID = @"";
    }

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                     messageAsString:driverID];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)connectDriver:(CDVInvokedUrlCommand*)command
{
    NSString* driverID = [command.arguments objectAtIndex:0];
    [[HTTransmitterClient sharedClient] connectDriverWithDriverID:driverID completion:nil];
}

- (void)getPublishableKey:(CDVInvokedUrlCommand*)command
{
    NSString *publishableKey = [HyperTrack publishableKey];

    if (!publishableKey) {
        publishableKey = @"";
    }

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                     messageAsString:publishableKey];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
