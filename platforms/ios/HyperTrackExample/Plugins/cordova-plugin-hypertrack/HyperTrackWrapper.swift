import HyperTrack


@objc(HyperTrackWrapper) class HyperTrackWrapper : CDVPlugin {
    override func pluginInitialize() {
        // Initialise HyperTrack when the plugin is initialised
        let hyperTrackKey = self.commandDelegate.settings["hypertrack_pk"] as! String?
        
        if (hyperTrackKey != nil) {
            HyperTrack.initialize(hyperTrackKey!)
        } else {
            print("Key not configured inside config.xml")
        }
    }
    
    @objc(helloWorld:)
    func helloWorld(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )
        
        let msg = command.arguments[0] as? String ?? ""
        
        if msg.characters.count > 0 {
            let toastController: UIAlertController =
                UIAlertController(
                    title: "",
                    message: msg,
                    preferredStyle: .alert
            )
            
            self.viewController?.present(
                toastController,
                animated: true,
                completion: nil
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                toastController.dismiss(
                    animated: true,
                    completion: nil
                )
            }
            
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: msg
            )
        }
        
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
    
    @objc(getOrCreateUser:)
    func getOrCreateUser(command: CDVInvokedUrlCommand) {
        let name = command.arguments[0] as? String ?? ""
        let phone = command.arguments[1] as? String ?? ""
        let photo = command.arguments[2] as? String ?? "" // Is being ignored right now
        let lookupId = command.arguments[3] as? String ?? ""
        
        HyperTrack.getOrCreateUser(name, _phone: phone, lookupId) { (user, error) in
            var pluginResult : CDVPluginResult? = nil
            
            if (error != nil) {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error?.errorMessage)
            }
            
            if (user != nil) {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: user?.toJson())
            }
            
            self.commandDelegate!.send(
                pluginResult,
                callbackId: command.callbackId
            )
        }
    }
    
    @objc(setUserId:)
    func setUserId(command: CDVInvokedUrlCommand) {
        let userId = command.arguments[0] as? String ?? ""
        var pluginResult : CDVPluginResult? = nil
        
        if userId.characters.count > 0 {
            HyperTrack.setUserId(userId)
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
        }
        
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
    
    @objc(startTracking:)
    func startTracking(command: CDVInvokedUrlCommand) {

        HyperTrack.startTracking { (error) in
            var pluginResult : CDVPluginResult? = nil
            
            if (error != nil) {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error?.errorMessage)
            } else {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            }
            
            self.commandDelegate!.send(
                pluginResult,
                callbackId: command.callbackId
            )
        }
    }
    
    @objc(stopTracking:)
    func stopTracking(command: CDVInvokedUrlCommand) {
        
        HyperTrack.stopTracking()
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
    
    @objc(createAndAssignAction:)
    func createAndAssignAction(command: CDVInvokedUrlCommand) {
        let actionType = command.arguments[0] as? String ?? ""
        let lookupId = command.arguments[1] as? String ?? ""
        let expectedPlaceAddress = command.arguments[2] as? String ?? ""
        let expectedPlaceLatitude = command.arguments[3] as? Double
        let expectedPlaceLongitude = command.arguments[4] as? Double
        
        let expectedPlace: HyperTrackPlace = HyperTrackPlace()
            .setAddress(address: expectedPlaceAddress)
            .setLocation(latitude: expectedPlaceLatitude!, longitude: expectedPlaceLongitude!)
        
        let htActionParams = HyperTrackActionParams()
        htActionParams.lookupId = lookupId
        htActionParams.type = actionType
        htActionParams.expectedPlace = expectedPlace
        
        HyperTrack.createAndAssignAction(htActionParams) { action, error in
            var pluginResult : CDVPluginResult? = nil
            
            if (error != nil) {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error?.errorMessage)
            }
            
            if (action != nil) {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: action?.toJson())
            }
            
            self.commandDelegate!.send(
                pluginResult,
                callbackId: command.callbackId
            )
        }
        
    }
    
    @objc(completeAction:)
    func completeAction(command: CDVInvokedUrlCommand) {
        let actionId = command.arguments[0] as? String ?? ""
        HyperTrack.completeAction(actionId)
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
    
    @objc(completeActionWithLookupId:)
    func completeActionWithLookupId(command: CDVInvokedUrlCommand) {
        // TODO
    }
    
    @objc(getCurrentLocation:)
    func getCurrentLocation(command: CDVInvokedUrlCommand) {
        HyperTrack.getCurrentLocation { (location, error) in
            var pluginResult : CDVPluginResult? = nil
            
            if (error != nil) {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error?.errorMessage)
            }
            
            if (location != nil) {
                // TODO: need to be consistent across Android and iOS
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            }
            
            self.commandDelegate!.send(
                pluginResult,
                callbackId: command.callbackId
            )
        }
    }
    
    @objc(requestPermissions:)
    func requestPermissions(command: CDVInvokedUrlCommand) {
        HyperTrack.requestAlwaysAuthorization { (isAuthorized) in
            var pluginResult : CDVPluginResult? = nil
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isAuthorized)
            
            self.commandDelegate!.send(
                pluginResult,
                callbackId: command.callbackId
            )
        }
    }
    
    @objc(requestLocationServices:)
    func requestLocationServices(command: CDVInvokedUrlCommand) {
        HyperTrack.requestLocationServices()
    }
    
    @objc(checkLocationPermission:)
    func checkLocationPermission(command: CDVInvokedUrlCommand) {
        // TODO
    }
    
    @objc(checkLocationServices:)
    func checkLocationServices(command: CDVInvokedUrlCommand) {
        // TODO
    }
    
    @objc(requestMotionAuthorization:)
    func requestMotionAuthorization(command: CDVInvokedUrlCommand) {
        
        HyperTrack.requestMotionAuthorization()
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
}
