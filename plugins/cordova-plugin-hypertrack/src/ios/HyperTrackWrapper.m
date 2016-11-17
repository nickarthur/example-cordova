/********* HyperTrack.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <HTCommon/HyperTrack.h>
#import <HTTransmitter/HTTransmitter.h>

@interface HyperTrackWrapper : CDVPlugin {
  // Member variables go here.
}

- (void)helloWorld:(CDVInvokedUrlCommand*)command;
@end

@implementation HyperTrackWrapper

- (void)pluginInitialize
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
    // HTTripParams *tripParams = [[HTTripParams alloc] init];
    CDVPluginResult* pluginResult = nil;
    NSString* driverID = [command.arguments objectAtIndex:0];
    NSString* taskIDs = [command.arguments objectAtIndex:1];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)completeTask:(CDVInvokedUrlCommand*)command
{
    NSString* taskID = [command.arguments objectAtIndex:0];
    __block CDVPluginResult* pluginResult = nil;
    [[HTTransmitterClient sharedClient] completeTaskWithTaskID:taskID completion:^(HTResponse <HTTask *> * _Nullable response, NSError * _Nullable error) {

        if (error) {
            // Handle error and try again.
            NSDictionary *failure = @{@"error" : error.localizedDescription};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"task complete failure"];
        } else {
            // If there is no error, use the taskID received in the callback in your app.
            NSDictionary *success = @{@"task" : response.result.dictionaryValue.jsonString};
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"task complete success"];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
