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

        // Check for Location Settings, Create User and call startTracking
        // this.checkLocationSettings();

        // Uncomment this to getCurrentLocation
        // this.getCurrentLocation();

        // Uncomment this to call stopTracking API
        this.stopTracking();

        // Uncomment this to call createAndAssignAction
        // and completeAction APIs
        // this.createAction();
    },

    checkLocationSettings() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.checkLocationPermission(
            (e) => {
                if (e == "false") {
                    console.log('LocationPermission is denied. Requesting for LocationPermissions. Run the app again once granted.')
                    window.plugins.toast.showShortBottom('LocationPermission is denied. Requesting for LocationPermissions. Run the app again once granted.')
                    this.requestPermissions()

                } else {
                    this.checkLocationServices()
                }   
            })
    },

    checkLocationServices() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.checkLocationServices(
            (e) => {
                if (e == "false") {
                    console.log('LocationServices is disabled. Requesting for LocationServices. Run the app again once enabled.')
                    window.plugins.toast.showShortBottom('LocationServices is disabled. Requesting for LocationServices. Run the app again once enabled.')
                    this.requestLocationServices()

                } else {
                    this.getOrCreateUser()
                }
            })
    },

    requestPermissions() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.requestPermissions()
    },

    requestLocationServices() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.requestLocationServices()
    },

    getOrCreateUser() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.getOrCreateUser("cordova-photo-test", "phone", "https://scontent.fdel1-1.fna.fbcdn.net/v/t31.0-8/19221515_1407738472636221_550707151637861761_o.jpg?oh=68c4e66369e521546ebe33f72021ca5a&oe=59CE8692", "lookupId",
            (e) => {
                console.log('getOrCreateUser success', e)
                window.plugins.toast.showShortBottom("getOrCreateUser success" + e)

                // Call startTracking once, user is successfully created
                this.startTracking();
            },
            (e) => {
                console.log('getOrCreateUser error', e)
                window.plugins.toast.showShortBottom("getOrCreateUser error" + e)
            })
    },

    startTracking() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.startTracking(
            (e) => {
                console.log('startTracking success. Now you can see the user being tracked', e)
                window.plugins.toast.showShortBottom("startTracking success. Now you can see the user being tracked" + e)
            },
            (e) => {
                console.log('startTracking error', e)
                window.plugins.toast.showShortBottom("startTracking error" + e)
            })
    },

    createAction() {
        console.log('creating action')
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.createAndAssignAction(
            'visit', 'lookupId', 'Ferry building, San Francisco', 37.79557, -122.39550,

            (e) => {
                console.log('createAndAssignAction success', e);
                window.plugins.toast.showShortBottom("createAndAssignAction success" + e)
                var obj = JSON.parse(e);
                console.log('trying to complete action', obj.id, hypertrack.completeAction)
                hypertrack.completeAction(obj.id, (e) => {console.log('completeAction success', e)}, (e) => {console.log('completeAction error', e)})
            },
            (e) => {
                console.log('createAndAssignAction error', e)
                window.plugins.toast.showShortBottom("createAndAssignAction error" + e)
            })
    },

    stopTracking() {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.stopTracking(
            (e) => {
                console.log('stopTracking success', e)
                window.plugins.toast.showShortBottom("stopTracking success" + e)
            }, 
            (e) => {
                console.log('stopTracking error', e)
                window.plugins.toast.showShortBottom("stopTracking error" + e)
            })
    },

    getCurrentLocation () {
        var hypertrack = cordova.plugins.HyperTrack;
        hypertrack.getCurrentLocation(
            (e) => {
                console.log('getCurrentLocation success', e);
                var obj = JSON.parse(e);
                alert(obj.mLatitude + ', ' + obj.mLongitude)
                window.plugins.toast.showShortBottom("getCurrentLocation success" + e)
            },
            (e) => {
                console.log('getCurrentLocation error', e)
                window.plugins.toast.showShortBottom("getCurrentLocation error" + e)
            })
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