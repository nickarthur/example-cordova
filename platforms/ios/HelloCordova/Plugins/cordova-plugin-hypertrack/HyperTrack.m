/********* HyperTrack.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
// @import HTTransmitter;

@interface HyperTrack : CDVPlugin {
  // Member variables go here.
}

- (void)helloWorld:(CDVInvokedUrlCommand*)command;
@end

@implementation HyperTrack

- (void)pluginInitialize
{
    NSString* publishableKey = [self.commandDelegate.settings objectForKey:[@"HYPERTRACK_PK" lowercaseString]];
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
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
