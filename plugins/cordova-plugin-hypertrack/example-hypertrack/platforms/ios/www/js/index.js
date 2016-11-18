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
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
        app.helloWorld("hello, world");

        // app.startTrip(driverID, taskIDs);
    },

    success: function(text) {
        console.log("success handler");
        console.log(text);
    },

    error: function(text) {
        console.log("error handler");
        console.log(text);
    },

    helloWorld: function(text) {
        var hypertrack = cordova.plugins.HyperTrack;
        console.log(hypertrack);
        hypertrack.helloWorld(text, app.success, app.error);
        console.log('sent')
    },

    startTrip: function(driverID, taskIDs) {
        var hypertrack = cordova.plugins.HyperTrack;
        console.log('driverID', driverID);
        console.log('taskIDs', taskIDs);
        hypertrack.startTrip(driverID, taskIDs, app.success, app.error);
    },

    completeTask: function(taskID) {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.completeTask(taskID, app.success, app.error);
    },

    endTrip: function() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.endTrip(app.success, app.error);
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};


app.initialize();


var driverID = "YOUR_DRIVER_ID";
var taskID = "YOUR_TASK_ID";

helloWorldButton = function() {
    app.helloWorld("test hello, world");
}

startTripButton = function() {
    app.startTrip(driverID, [taskID]);
}

completeTaskButton = function() {
    app.completeTask(taskID);
}

endTripButton = function() {
    app.endTrip();
}

document.getElementById("startTripButton").addEventListener("click", helloWorldButton);
document.getElementById("completeTaskButton").addEventListener("click", completeTaskButton);
document.getElementById("endTripButton").addEventListener("click", endTripButton);
