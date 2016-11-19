# hypertrack-cordova
Cordova plugin wrapper for hypertrack-android and hypertrack-ios. The [example-cordova](https://github.com/hypertrack/example-cordova/) app is built on top of this plugin.

[![Slack Status](http://slack.hypertrack.io/badge.svg)](http://slack.hypertrack.io) [![npm version](https://badge.fury.io/js/cordova-plugin-hypertrack.svg)](https://badge.fury.io/js/cordova-plugin-hypertrack)

> In case you are looking for an SDK to build an app with a common codebase for Android and iOS from scratch, we recommend using React Native instead. We have seen some configuration issues with iOS and Cordova - our solution is detailed out [here](ios-config.md). [react-native-hypertrack](https://github.com/hypertrack/react-native-hypertrack/) is our wrapper for RN.

## New app
Refer to the **Create your first Cordova app** guide [here](https://cordova.apache.org/docs/en/latest/guide/cli/index.html) in case you are building a new app.

## Requirements
- Configure the pre-requisites required for building a Cordova application which have been detailed out [here](https://cordova.apache.org/docs/en/latest/guide/cli/index.html#install-pre-requisites-for-building).
- Make sure the installed Cordova version is `6.4.0`. In case not, you can update Cordova by running the command
```
$ cordova --version
$ npm install -g cordova
```

## Usage
Before you can set up the HyperTrack plugin, we need to first set-up the dependencies for iOS as given below. For Android, the plugin configures the dependencies automatically.

### iOS
The iOS native dependencies are to be installed using Cocoapods in your project's ios directory. Please follow the steps detailed out in [ios-config](ios-config.md).

### Android
The plugin includes the native dependencies for Android, and they will be automatically configured when you install and building with the plugin.

### Install the plugin
To install the plugin, use the following command in your app directory.
```
$ cordova plugin add cordova-plugin-hypertrack
```

In your app's `config.xml` set a new preference key `HYPERTRACK_PK` with your publishable key as the value. This key will be used by the native SDKs. Read this to [get API keys](http://docs.hypertrack.io/docs/get-api-keys), if you don't have them already.
```
<preference name="HYPERTRACK_PK" value="pk_12345abcd" />
```

To use the plugin in a Cordova application, just use the `hypertrack` object. All methods are defined in the [HyperTrack.js](https://github.com/hypertrack/hypertrack-cordova/blob/master/www/HyperTrack.js) file.
```
var hypertrack = cordova.plugins.HyperTrack;
hypertrack.helloWorld("hello, world", success, error); // simple test method for the plugin, which prints to console.log

hypertrack.startTrip("DRIVER_ID", ["TASK_ID_1", "TASK_ID_2"], success, error); // start trip method
```

## Documentation
The HyperTrack documentation is at [docs.hypertrack.io](http://docs.hypertrack.io/)

## Support
For any questions, please reach out to us on [Slack](http://docs.hypertrack.io/) or on help@hypertrack.io. Please create an [issue](https://github.com/hypertrack/hypertrack-cordova/issues) for bugs or feature requests.
