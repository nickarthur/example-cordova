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

    NSString *pk = [HyperTrack publishableKey];

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
            NSDictionary *success = @{@"task" : response.result.dictionaryValue.jsonString};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:success];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
