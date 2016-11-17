cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
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
    "cordova-plugin-hypertrack": "0.1.0",
    "cordova-plugin-whitelist": "1.3.0"
};
// BOTTOM OF METADATA
});