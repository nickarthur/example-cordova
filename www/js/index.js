/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {

    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
        this.configure();
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    },

    configure: function() {
        console.log('plugins', cordova.plugins);
        var hypertrack = cordova.plugins.HyperTrack;
        console.log('hypertrack', hypertrack);

        hypertrack.helloWorld("arjun", this.success, this.error);
    },

    // success callback
    success: function(text) {
        console.log("success handler");
        console.log(text);
    },

    // error callback
    error: function(text) {
        console.log("error handler");
        console.log(text);
    },

    helloWorld: function(text) {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.helloWorld(text, app.success, app.error);
    },

    startTrip: function(driverID, taskIDs) {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.startTrip(driverID, taskIDs, app.success, app.error);
    },

    completeTask: function(taskID) {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.completeTask(taskID, app.success, app.error);
    },

    endTrip: function() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.endTrip(tripID, app.success, app.error);
    },
};

app.initialize();

driverID = "b4caf73c-87a4-4263-938f-08347612d96c";
taskID = "a5eeb1d3-3081-45ff-880b-9f12bc249729";
tripID = "";

helloWorldButton = function() {
    app.configure();
}

startTripButton = function() {
    app.startTrip(driverID, [taskID]);
}

completeTaskButton = function() {
    app.completeTask(taskID);
}

endTripButton = function() {
    app.endTrip(tripID);
}

document.getElementById("helloWorldButton").addEventListener("click", helloWorldButton);
document.getElementById("startTripButton").addEventListener("click", startTripButton);
document.getElementById("completeTaskButton").addEventListener("click", completeTaskButton);
document.getElementById("endTripButton").addEventListener("click", endTripButton);
