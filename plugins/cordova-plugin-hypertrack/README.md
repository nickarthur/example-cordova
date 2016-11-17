# hypertrack-cordova
Cordova plugin wrapper for hypertrack-android and hypertrack-ios. The [example-cordova](https://github.com/hypertrack/example-cordova/) app is built on top of this plugin.

[![Slack Status](http://slack.hypertrack.io/badge.svg)](http://slack.hypertrack.io) [![npm version](https://badge.fury.io/js/cordova-plugin-hypertrack.svg)](https://badge.fury.io/js/cordova-plugin-hypertrack)

## Usage
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

## Developing
The repo includes the plugin and an example app to test the integration.

After you have cloned the repo, to run the example app, you must have Cordova installed. Cordova 6.3.1 was used for this project.
```
$ npm install -g cordova
$ cordova --version
```

cd into the app directory, and configure the platforms and plugins for the example app.
```
$ cd example-hypertrack
$ cordova plugin add ../.
$ cordova platform add android
$ cordova platform add ios
```

Verify that the hypertrack plugin is installed. Also verify that the app is set for both Android and iOS platforms.
```
$ cordova plugin ls
cordova-plugin-hypertrack 0.1.0 "HyperTrack"
cordova-plugin-whitelist 1.3.0 "Whitelist"
$ cordova platforms ls
Installed platforms:
  android 5.2.2
  ios 4.2.1
```

Also verify whether your environment has the required packages. If not, install them with `npm install -g`.
```
$ cordova requirements
```

To run the app in the Android emulator, run
```
$ cordova build --stacktrace --info | cordova emulate android
```

To run the app in the iOS simulator, run
```
$ cordova build --stacktrace --info | cordova emulate ios
```

Some times the build might crap out for unexpected reasons. The author fixed it by removing and adding the respectively platform. This also rebuilds the plugin for the platform - so in cases where the plugin changes have not been reflected, use this.
```
$ cordova platform rm android
$ cordova platform add android
```

## Debugging
On Android, you can use the Chrome web debugger to debug while developing the app/plugin for Android. Open the following url in Chrome, and click on `inspect`. This will open the js console for the Cordova app, and `console.log` messages will be visible.
```
chrome://inspect/#devices
```
Similarly on iOS, the Safari web inspector can be used.

## Documentation
The HyperTrack documentation is at [docs.hypertrack.io](http://docs.hypertrack.io/)

## Support
For any questions, please reach out to us on [Slack](http://docs.hypertrack.io/) or on help@hypertrack.io. Please create an [issue](https://github.com/hypertrack/hypertrack-cordova/issues) for bugs or feature requests.
