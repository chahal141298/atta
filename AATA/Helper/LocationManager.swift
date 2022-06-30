//
//  LocationManager .swift
//  NonIOT
//
//  Created by Uday Patel on 28/09/21.
//

import Foundation
import CoreLocation
import UIKit

///
class LocationManager: NSObject {
    // MARK: - Variables
    ///
    static let shared: LocationManager = LocationManager()
    ///
    var locationManager: CLLocationManager?
    ///
    var userLocation: CLLocation?
    ///
    var locationName: String = "Location"
    ///
    var isLocationServicesEnabled: Bool = false
    
    // MARK: - Init Method
    ///
    override init() {
        super.init()
        locationManager = CLLocationManager()
        self.setupLocationManager()
    }
    
    // MARK: - Custom Location Methods
    ///
    func setupLocationManager() {
        var status: CLAuthorizationStatus?
        if #available(iOS 14, *) {
            status = locationManager?.authorizationStatus ?? .none
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        switch status {
        case .restricted, .denied:
            break
        default:
            guard CLLocationManager.locationServicesEnabled() else { return }
            locationManager?.delegate = self
            /*locationManager?.allowsBackgroundLocationUpdates = true*/
            /*locationManager?.pausesLocationUpdatesAutomatically = false*/
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestWhenInUseAuthorization()
        /*locationManager?.requestAlwaysAuthorization()*/
        }
    }
    
    ///
    func isAlwaysAutherizationEnable() -> Bool {
        var locationStatus: CLAuthorizationStatus?
        if #available(iOS 14, *) {
            locationStatus = locationManager?.authorizationStatus ?? .none
        } else {
            locationStatus = CLLocationManager.authorizationStatus()
        }
        let applicationState = UIApplication.shared.applicationState
        switch locationStatus {
        case .restricted, .denied:
            if applicationState == .background {
                // show Enable Location Notification
            } else {
                showEnableLocationAlert()
            }
            return false
        case .notDetermined:
            if applicationState == .background {
                // show Enable Location Notification
            } else {
                showEnableLocationAlert()
            }
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .none:
            return false
        @unknown default: return false
        }
    }
    
    ///
    func isLocationAutherizationEnable() -> Bool {
        var locationStatus: CLAuthorizationStatus?
        if #available(iOS 14, *) {
            locationStatus = locationManager?.authorizationStatus ?? .none
        } else {
            locationStatus = CLLocationManager.authorizationStatus()
        }
        let applicationState = UIApplication.shared.applicationState
        switch locationStatus {
        case .restricted, .denied, .notDetermined:
            if applicationState == .background {
                // show Enable Location Notification
            } else {
                showEnableLocationAlert()
            }
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .none:
            return false
        @unknown default: return false
        }
    }
    
    ///
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    ///
    func stopTrackingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    ///
    func showAuthorizedWhenInUseAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Location Service Error !", message: "Location information won't be captured in the background mode which will impact on your Ride & Tour report, Please go to Settings and change it to \"Always\" instead of \"While Using the App\".", preferredStyle: .alert)
            let settingAction = UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    guard let openSettingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(openSettingsUrl) else { return }
                    UIApplication.shared.open(openSettingsUrl, completionHandler: nil)
                }
            })
            alert.addAction(settingAction)
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (_) in })
            alert.addAction(cancelAction)
            
            if #available(iOS 13.0, *) {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                guard let appDelgate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelgate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    ///
    func showEnableLocationAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Location Service Error !", message: "It seems like GPS Location services aren't enabled on your device, Please enable it from settings to use the App.", preferredStyle: .alert)
            let settingAction = UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    guard let openSettingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(openSettingsUrl) else { return }
                    UIApplication.shared.open(openSettingsUrl, completionHandler: nil)
                }
            })
            alert.addAction(settingAction)
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (_) in })
            alert.addAction(cancelAction)
            
            if #available(iOS 13.0, *) {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                guard let appDelgate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelgate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    static func currentLocation() -> (lat:Double?, long:Double?) {
        var lat:Double? = nil
        var long:Double? = nil
        
        if let lat1 = UserDefaults.standard.object(forKey: "lat_tvs") {
            lat = (lat1 as! NSNumber).doubleValue
        }
        
        if let long1 = UserDefaults.standard.object(forKey: "long_tvs") {
            long = (long1 as! NSNumber).doubleValue
        }
        
        return (lat, long)
    }
}

// MARK: - Location Manager Delegate
extension LocationManager: CLLocationManagerDelegate {
    // MARK: Location Manager Delegate Methods
    ///
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            print("No access")
            showEnableLocationAlert()
            isLocationServicesEnabled = false
        case .notDetermined:
            print("No access")
            isLocationServicesEnabled = false
        case .authorizedAlways:
            print("Access authorizedAlways")
            isLocationServicesEnabled = true
            startUpdatingLocation()
        case .authorizedWhenInUse:
            print("Access authorizedWhenInUse")
            isLocationServicesEnabled = true
            startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    /// locationManager didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        self.userLocation = userLocation
        self.stopTrackingLocation()
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.        
        /*if locations.count > 0, let mostRecentLocation = locations.last  {
         let locValue:CLLocationCoordinate2D = mostRecentLocation.coordinate
         print("locations = \(locValue.latitude) \(locValue.longitude)")
         }*/
        
    }
    
    /// locationManager didFailWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
