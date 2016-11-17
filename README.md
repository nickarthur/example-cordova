# example-cordova
Example app on hypertrack-cordova built on the official Cordova [plugin](https://github.com/hypertrack/hypertrack-cordova).

[![Slack Status](http://slack.hypertrack.io/badge.svg)](http://slack.hypertrack.io)

## Usage
### iOS
```
$ cordova platform add ios
$ cordova run ios
```

1. Set up podfile
2. pod install
3. open xcode and fix PODS_ROOT $(SRCROOT)/Pods (recursvie)
4. add linker libraries
5. fix library search path $(SRCROOT)/build (recursive)
6. link binary with libraries - sqlite3

### Android
```
$ cordova platform add android
$ cordova run android
```


### HyperTrack config
The example app needs a HyperTrack publishable key, and valid driver and task id. To get the key, sign up [here](https://www.hypertrack.io/). The HyperTrack documentation is at [docs.hypertrack.io](http://docs.hypertrack.io/) which covers creating drivers/tasks.

## Support
For any questions, please reach out to us on [Slack](http://docs.hypertrack.io/) or on help@hypertrack.io. Please create an [issue](https://github.com/hypertrack/hypertrack-cordova/issues) for bugs or feature requests.
