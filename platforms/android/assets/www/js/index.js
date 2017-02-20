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
        this.helloWorld('test');
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

    helloWorld: function(text) {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.helloWorld(text,

          // success callback
          function(text) {
            alert('callback: ' + text);
          },

          // error callback
          function(error) {
            alert('error: ' + error)
          });
    },

    startTrip: function(driverID, taskIDs) {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.startTrip(driverID, taskIDs,

          // success callback
          function(response) {
            tripObj = JSON.parse(response.trip)
            console.log(tripObj);
            tripID = tripObj.id;
            var status = tripObj.status;
            alert('success: ' + tripID + ', ' + status);
          },

          // error callback
          function (error) {
            alert('error: ' + JSON.stringify(error));
          });
    },

    startShift: function(driverID) {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.startShift(driverID,

          // success callback
          function(response) {
            shift = JSON.parse(response.shift)
            alert('success: ' + shift);
          },

          // error callback
          function (error) {
            alert('error: ' + JSON.stringify(error));
          });
    },

    completeTask: function(taskID) {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.completeTask(taskID,

          // success callback
          function(response) {
            alert('success: ' + JSON.stringify(response));
          },

          // error callback
          function (error) {
            alert('error: ' + JSON.stringify(error));
          });
    },

    endTrip: function() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.endTrip(
          // success callback
          function(response) {
            tripObj = JSON.parse(response.trip)
            tripID = tripObj.id;
            var status = tripObj.status;
            alert('success: ' + tripID + ', ' + status);
          },

          // error callback
          function (error) {
            alert('error: ' + JSON.stringify(error));
          });
    },

    endShift: function() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.endShift(
          // success callback
          function(response) {
            shift = JSON.parse(response.shift)
            alert('success: ' + shift);
          },

          // error callback
          function (error) {
            alert('error: ' + JSON.stringify(error));
          });
    }
};

app.initialize();

driverID = "b4caf73c-87a4-4263-938f-08347612d96c";
taskID = "17f18397-1394-44ed-92db-da4894b709cb";
tripID = "";

helloWorldButton = function() {
    app.helloWorld('hello world button');
}

startTripButton = function() {
    app.startTrip(driverID, []);
}

startShiftButton = function() {
    app.startShift(driverID);
}

completeTaskButton = function() {
    app.completeTask(taskID);
}

endTripButton = function() {
    app.endTrip();
}

endShiftButton = function() {
    app.endShift();
}

document.getElementById("helloWorldButton").addEventListener("click", helloWorldButton);
document.getElementById("startTripButton").addEventListener("click", startTripButton);
document.getElementById("completeTaskButton").addEventListener("click", completeTaskButton);
document.getElementById("endTripButton").addEventListener("click", endTripButton);
document.getElementById("startShiftButton").addEventListener("click", startShiftButton);
document.getElementById("endShiftButton").addEventListener("click", endShiftButton);
