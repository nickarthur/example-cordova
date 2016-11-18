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


module.exports = hypertrack
