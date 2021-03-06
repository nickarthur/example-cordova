# hypertrack-cordova
Cordova plugin wrapper for hypertrack-android and hypertrack-ios. The [example-cordova](https://github.com/hypertrack/example-cordova/) app is built on top of this plugin.

[![Slack Status](http://slack.hypertrack.io/badge.svg)](http://slack.hypertrack.io) [![npm version](https://badge.fury.io/js/cordova-plugin-hypertrack.svg)](https://badge.fury.io/js/cordova-plugin-hypertrack)

> In case you are looking for an SDK to build an app with a common codebase for Android and iOS from scratch, you can also use the [react-native-hypertrack](https://github.com/hypertrack/react-native-hypertrack/) wrapper.

## New app
Refer to the **Create your first Cordova app** guide [here](https://cordova.apache.org/docs/en/latest/guide/cli/index.html) in case you are building a new app.

## Requirements
- Configure the pre-requisites required for building a Cordova application which have been detailed out [here](https://cordova.apache.org/docs/en/latest/guide/cli/index.html#install-pre-requisites-for-building).
- Make sure the installed Cordova version is at least `6.4.0`. In case not, you can update Cordova by running the command
```
$ cordova --version
$ npm install -g cordova
```

## Usage
Before you can set up the HyperTrack plugin, we need to first set-up the dependencies for iOS as given below. For Android, the plugin configures the dependencies automatically.

### Install the plugin
To install the plugin, use the following command in your app directory. **On iOS**, follow the [following steps](#ios) before you can add the plugin to your repository.
```
$ cordova plugin add cordova-plugin-hypertrack
```

In your app's `config.xml` set a new preference key `HYPERTRACK_PK` with your publishable key as the value. This key will be used by the native SDKs. [Sign up](https://hypertrack.com/) on HyperTrack, if you don't have them already.
```
<preference name="HYPERTRACK_PK" value="YOUR_PUBLISHABLE_KEY" />
```

### iOS
#### Capabilities
Enable "Background Modes" capability for your project, with the following options.

```
* Location updates
* Remote notification
* Background fetch
```

#### Permission strings
The SDK requires location and activity permissions on the device. To request for these permissions, you need to define permission strings for the following in your project settings.

```
* Privacy - Location Always and When In Use Usage Description
* Privacy - Location When In Use Usage Description
* Privacy - Motion Usage Description
```

#### Dependencies
The native SDK is built in Swift and distributed using Cocoapods. To work with these in Cordova, we need two additional plugins. Install them using the following commands.

```
$ cordova plugin add cordova-plugin-add-swift-support --save
$ cordova plugin add cordova-plugin-cocoapod-support --save
```

Now you're ready to install the HyperTrack plugin.
```
$ cordova plugin add cordova-plugin-hypertrack
```

To ensure that the swift setup is compleled, you can run the following find command to search for the wrapper file, and verify the expected response.

```
$ find platforms/ios|grep HyperTrackWrapper.swift

platforms/ios/HyperTrackExample/Plugins/cordova-plugin-hypertrack/HyperTrackWrapper.swift
```

## Plugin methods
To use the plugin in a Cordova application, just use the `hypertrack` object. All methods are defined below, and also in the [HyperTrack.js](https://github.com/hypertrack/hypertrack-cordova/blob/master/www/HyperTrack.js) file.

```js
var hypertrack = cordova.plugins.HyperTrack;

// To get or create user with a name, phone number, photo (url or Base64 converted string) and unique internal id (eg, 001ABC)
hypertrack.getOrCreateUser("TestName", "+16102563456", "photo_url", "001ABC", success, error);

// To start tracking
hypertrack.startTracking(success, error);

// To stop tracking
hypertrack.stopTracking(success, error);

// To create an action, pass action type, action lookup id, action expected place address, expected place latitude, expected place longitude (all fields are optional)
hypertrack.createAndAssignAction('visit', 'lookupId', 'Ferry building, San Francisco', 37.79557, -122.39550, success, error);
```

## Documentation
The HyperTrack documentation is at [docs.hypertrack.com](http://docs.hypertrack.com/)

## Support
For any questions, please reach out to us on [Slack](http://slack.hypertrack.io/) or on help@hypertrack.io. Please create an [issue](https://github.com/hypertrack/hypertrack-cordova/issues) for bugs or feature requests.
