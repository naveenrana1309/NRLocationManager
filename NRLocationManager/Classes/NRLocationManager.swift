//
//  NRLocationManager.swift
//  NRLocationManager
//
//  Created by Naveen Rana on 19/02/18.
//

import Foundation
import CoreLocation


/// This class is used to provide a location updates via completion handler.

open class NRLocationManger: NSObject, CLLocationManagerDelegate {
    
    let LOCATION_ERROR_MESSAGE = "Please check your location settings. Settings->Privacy->Location Services"
    var manager: CLLocationManager
    open static let shared = NRLocationManger()
    public var currentLocation: CLLocation?
    var type: LocationType = .onetime
    /// This completionhandler use for call back for one time location.
    public typealias LocationHandler = ((_ location: CLLocation?, _ error: Error?) -> ())
    var onetimeLocation: LocationHandler?

    /// Below completionhandler use for beacon and region monitoring.
    var beaconHandler: onRangingBeacon?
    var onRegionEnter: onRegionEvent?
    var onRegionExit: onRegionEvent?
    typealias onRangingBeacon = ( (_ beacons: [CLBeacon]) -> Void)
    public typealias onRegionEvent = ( (_ region: CLRegion?) -> Void)

    
    
    public enum ServiceStatus: Int {
        case available
        case undetermined
        case denied
        case restricted
        case disabled
    }
    
    public enum LocationType: Int {
        case onetime
        case continous
        case significant
    }
    
    
    /// ServiceStatus is used to get the status of location manager for iOS
    class var state: ServiceStatus {
        get {
            if CLLocationManager.locationServicesEnabled() == false {
                return .disabled
            } else {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    return .undetermined
                case .denied:
                    return .denied
                case .restricted:
                    return .restricted
                case .authorizedAlways, .authorizedWhenInUse:
                    return .available
                }
            }
        }
    }
    
    override fileprivate init() {
        manager = CLLocationManager()
        super.init()
        manager.delegate = self
    }
    
    
    fileprivate func updateLocationManagerStatus() {
        if #available(iOS 9.0, *) {
            manager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        let hasAlwaysKey = (Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil)
        let hasWhenInUseKey = (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil)
        if hasAlwaysKey == true {
            manager.requestAlwaysAuthorization()
        } else if hasWhenInUseKey == true {
            manager.requestWhenInUseAuthorization()
        } else {
            // You've forgot something essential
            assert(false, "To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.")
        }
    }
    
    ///Start continuos location
    private func startLocationUpdate() {
        if NRLocationManger.state == ServiceStatus.disabled {
            // Utils.showAlertWithMessage("This will allow the support team to find you more w=ork")
            print(LOCATION_ERROR_MESSAGE)
            
        }
        else {
            updateLocationManagerStatus()
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            manager.pausesLocationUpdatesAutomatically = false
            manager.distanceFilter = 100
            manager.startUpdatingLocation()
        }
    }
    
    fileprivate func startUpdatingSignificantLocationChange() {
        if NRLocationManger.state == ServiceStatus.disabled {
            print(LOCATION_ERROR_MESSAGE)
        }
        else {
            updateLocationManagerStatus()
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            manager.pausesLocationUpdatesAutomatically = false
            manager.startMonitoringSignificantLocationChanges()
        }
    }
    
    /// Use this for fetch the current location one time
    public func fetchLocation(locationType: LocationType, _ handler: @escaping LocationHandler) {
        type = locationType
        self.onetimeLocation = handler
        manager.stopUpdatingLocation()
        if locationType == .significant {
            startUpdatingSignificantLocationChange()
        }
        else {
            startLocationUpdate()

        }
    }
    
    
    /// Check at any time if location is on/off
    public func isLocationEnabled() -> Bool {
        if NRLocationManger.state == ServiceStatus.disabled {
            return false
        }
        else {
            return true
        }
    }
    
    //MARK: [Private] Location Manager Delegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationsReceived(locations,manager)
    }
    
    /// inside logic to ensure to get the valid coordinates only
    fileprivate func locationsReceived(_ locations: [AnyObject]!, _ manager: CLLocationManager) {
        if let location = locations.last as? CLLocation {
            let eventDate = location.timestamp //time when this location found
            let howRecent = eventDate.timeIntervalSinceNow //diffrence between current time and last location time
            let horizontalAccuracy = location.horizontalAccuracy
            if howRecent < 15.0 && (horizontalAccuracy>0 && horizontalAccuracy<300) {
                currentLocation = location
                if let _ = onetimeLocation {
                    self.onetimeLocation!(location, nil)
                    manager.stopUpdatingLocation()
                    if type == .onetime {
                        self.onetimeLocation = nil

                    }
                }
            }
            else {
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if onetimeLocation != nil && type == .onetime {
            self.onetimeLocation!(nil, error)
            self.onetimeLocation = nil
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            // Clear out any pending location requests (which will execute the blocks with a status that reflects
            // the unavailability of location services) since we now no longer have location services permissions
            let err = NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Location services denied/restricted by parental control"])
            locationManager(manager, didFailWithError: err)
        } else if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
        } else if status == CLAuthorizationStatus.notDetermined {
            let error = NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Location services denied/restricted by parental control"])
            locationManager(manager, didFailWithError: error)
        }
    }
    
    //MARK: Beacons
    
    func monitorBeaconsInRegion(region: CLBeaconRegion!, onRanging: onRangingBeacon? ) {
        if NRLocationManger.state == ServiceStatus.disabled {
            // Utils.showAlertWithMessage("This will allow the support team to find you more w=ork")
            print(LOCATION_ERROR_MESSAGE)
            return ()
            
        }
        let isAvailable = CLLocationManager.isRangingAvailable() // if beacons monitoring is not available on this device we can't satisfy the request
        if isAvailable {
            
            manager.stopRangingBeacons(in: region)
            manager.startRangingBeacons(in: region)
            manager.pausesLocationUpdatesAutomatically = false
            self.beaconHandler = onRanging
        }
        else {
            print("Beacon monitoring not supported in this device")
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if beaconHandler != nil {
            self.beaconHandler!(beacons)
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("rangingBeaconsDidFailFor /\(error.localizedDescription)")
    }
    
    
    //MARK: Region Monitoring
    
    func removeAllMonitoredRegions() {
        for region in manager.monitoredRegions {
            manager.stopMonitoring(for: region)
        }
    }
    
    func monitorRegion(region: CLRegion!, onEnter: onRegionEvent?, onExit: onRegionEvent?){
        // if beacons region monitoring is not available on this device we can't satisfy the request
        let isAvailable = CLLocationManager.isMonitoringAvailable(for: CLRegion.self)
        if isAvailable {
            self.onRegionEnter = onEnter
            self.onRegionExit = onExit
            manager.stopMonitoring(for: region)
            manager.startMonitoring(for: region)
            
        } else {
            print("monitoring not available")
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if onRegionEnter != nil {
            self.onRegionEnter!(region)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if onRegionExit != nil {
            self.onRegionExit!(region)
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("monitoringDidFailFor")
    }
    
}

