var exec = require('cordova/exec');
var hypertrack = {}


hypertrack.helloWorld = function(text, success, error) {
    exec(success, error, "HyperTrack", "helloWorld", [text]);
};


hypertrack.startTrip = function(driverID, taskIDs, success, error) {
    exec(success, error, "HyperTrack", "startTrip", [driverID, taskIDs]);
};


hypertrack.completeTask = function(taskID, success, error) {
    exec(success, error, "HyperTrack", "completeTask", [taskID])
};


hypertrack.endTrip = function(tripID, success, error) {
    exec(success, error, "HyperTrack", "endTrip", [tripID])
};


hypertrack.startShift = function(driverID, success, error) {
    exec(success, error, "HyperTrack", "startShift", [driverID])
};


hypertrack.endShift = function(success, error) {
    exec(success, error, "HyperTrack", "endShift", [])
};


hypertrack.connectDriver = function(driverID, success, error) {
    exec(success, error, "HyperTrack", "connectDriver", [driverID]);
};


hypertrack.isTransmitting = function(callback) {
    exec(callback, null, "HyperTrack", "isTransmitting", []);
};


hypertrack.getActiveDriver = function(callback) {
    exec(callback, null, "HyperTrack", "getActiveDriver", []);
};


hypertrack.getPublishableKey = function(callback) {
    exec(callback, null, "HyperTrack", "getPublishableKey", []);
};


module.exports = hypertrack
