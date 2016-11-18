# example-cordova
Example app on hypertrack-cordova built on the official Cordova [plugin](https://github.com/hypertrack/hypertrack-cordova).

[![Slack Status](http://slack.hypertrack.io/badge.svg)](http://slack.hypertrack.io)

## Usage
### iOS
```
$ cordova platform add ios
$ cordova run ios
```
There is some additional config that had to be done, detailed [here](https://github.com/hypertrack/hypertrack-cordova/blob/master/ios-config.md). While all of that has been committed to the repo, there might be some hiccups.

### Android
```
$ cordova platform add android
$ cordova run android
```

## Developing
After you have cloned the repo, to run the example app, you must have Cordova installed. Cordova 6.3.1 was used for this project.
```
$ npm install -g cordova
$ cordova --version
```

cd into the app directory, and configure the platforms and plugins for the example app.
```
$ cordova plugin add cordova-plugin-hypertrack
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
$ cordova run android
```

To run the app for iOS, build the project with Cordova once. Chances are the build will fail, but you can then use Xcode to run the app. If you are switching between testing on the device and simulator, you will need to run the cordova build command again before Xcode can work with the library binaries.

```shell
$ cordova build --device # when building for device

$ cordova build # when building for simulator
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

### HyperTrack config
The example app needs a HyperTrack publishable key, and valid driver and task id. To get the key, sign up [here](https://www.hypertrack.io/). The HyperTrack documentation is at [docs.hypertrack.io](http://docs.hypertrack.io/) which covers creating drivers/tasks.

## Support
For any questions, please reach out to us on [Slack](http://docs.hypertrack.io/) or on help@hypertrack.io. Please create an [issue](https://github.com/hypertrack/hypertrack-cordova/issues) for bugs or feature requests.
