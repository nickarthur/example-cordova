cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "id": "cordova-plugin-x-toast.Toast",
        "file": "plugins/cordova-plugin-x-toast/www/Toast.js",
        "pluginId": "cordova-plugin-x-toast",
        "clobbers": [
            "window.plugins.toast"
        ]
    },
    {
        "id": "cordova-plugin-x-toast.tests",
        "file": "plugins/cordova-plugin-x-toast/test/tests.js",
        "pluginId": "cordova-plugin-x-toast"
    },
    {
        "id": "cordova-plugin-hypertrack.HyperTrack",
        "file": "plugins/cordova-plugin-hypertrack/www/HyperTrack.js",
        "pluginId": "cordova-plugin-hypertrack",
        "clobbers": [
            "cordova.plugins.HyperTrack"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.3.2",
    "cordova-plugin-x-toast": "2.6.0",
    "cordova-plugin-hypertrack": "0.1.0"
};
// BOTTOM OF METADATA
});