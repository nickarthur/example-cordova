cordova.define("cordova-plugin-hypertrack.HyperTrack", function(require, exports, module) {
var exec = require('cordova/exec');
var hypertrack = {}


// Helper method to test sdk
hypertrack.helloWorld = function(text, success, error) {
    exec(success, error, "HyperTrack", "helloWorld", [text]);
};


// Method to get or create a new user. Use name to specify the name of the user.
// phone to specify phone number, and lookupId to specify internal id of the user.
// lookupId is used to check if a new user is to be created.
hypertrack.getOrCreateUser = function(name, phone, lookupId, success, error) {
    exec(success, error, "HyperTrack", "getOrCreateUser", [name, phone, lookupId]);
};


// Method to set a user id, if you already have a user object previously created.
hypertrack.setUserId = function(userId, success, error) {
    exec(success, error, "HyperTrack", "setUserId", [userId]);
};


// Method to start tracking. This will fail if there is no user set.
hypertrack.startTracking = function(success, error) {
    exec(success, error, "HyperTrack", "startTracking", [   ])
};


// Method to stop tracking.
hypertrack.stopTracking = function(success, error) {
    exec(success, error, "HyperTrack", "stopTracking", [])
};


// Method to mark a specific action as complete.
hypertrack.completeAction = function(actionId, success, error) {
    exec(success, error, "HyperTrack", "completeAction", [actionId])
};


// Method to get current location in callback
hypertrack.getCurrentLocation = function(success, error) {
    exec(success, error, "HyperTrack", "getCurrentLocation", [])
};


module.exports = hypertrack

});
