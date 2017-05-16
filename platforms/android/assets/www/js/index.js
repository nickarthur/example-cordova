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

        var hypertrack = cordova.plugins.HyperTrack;
        console.log(hypertrack);

        this.getOrCreateUser();
        this.startTracking();
        this.getCurrentLocation();
        // this.stopTracking();
        this.createAction();
    },

    getOrCreateUser() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.getOrCreateUser("name", "phone", "lookup", (e) => {console.log('success', e)}, (e) => {console.log('error', e)})
    },

    createAction() {
        console.log('create action')
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.createAndAssignAction(
            'visit', 'lookupId', 'Ferry building, San Francisco', 37.79557, -122.39550,

            (e) => {console.log('success', e);
                    var obj = JSON.parse(e);
                    console.log('trying to complete', obj.id, hypertrack.completeAction)
                    hypertrack.completeAction(obj.id, (e) => {console.log('complete success', e)}, (e) => {console.log('complete error', e)})},
            (e) => {console.log('error', e)})
    },

    startTracking() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.startTracking((e) => {console.log('success', e)}, (e) => {console.log('error', e)})
    },

    stopTracking() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.stopTracking((e) => {console.log('success', e)}, (e) => {console.log('error', e)})
    },

    getCurrentLocation () {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.getCurrentLocation(
            (e) => {console.log('success', e);
                    var obj = JSON.parse(e);
                    alert(obj.mLatitude + ', ' + obj.mLongitude)},
            (e) => {console.log('error', e)})
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