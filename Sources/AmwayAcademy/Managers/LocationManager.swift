//
//  LocationManager.swift
//  ABOAcademy
//
//  Created by Shrinivas Reddy on 03/01/22.
//

import Foundation
import CoreLocation
import Combine

/// Class to fetch the user location details and store it in memory
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    @Published var address = ""
    @Published var subLocality = ""
    @Published var locality = ""
    @Published var area = ""
    @Published var country = ""
    @Published var postalCode = ""
    
    /// User permission status
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// Function to get the location permission status
    /// - Parameters:
    ///   - manager: location manager
    ///   - status: status of the permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
//        print(#function, statusString)
    }
    
    /// Function to get updated user location data
    /// - Parameters:
    ///   - manager: location manager
    ///   - locations: Location object which contains all data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
//        print(#function, location)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if (error != nil){
                AmwayAppLogger.generalLogger.debug("error in reverseGeocode")
            }
            guard let address = placemarks else { return }
            if address.count > 0 {
                let placemark = address[0]
                self.subLocality = placemark.subLocality ?? "-"
                self.locality = placemark.locality ?? "-"
                self.area = placemark.administrativeArea ?? "-"
                self.country = placemark.country ?? "-"
                self.postalCode = placemark.postalCode ?? "-"
                
                self.address = "\(placemark.subLocality ?? "-"), \(placemark.locality ?? "-"), \(placemark.administrativeArea ?? "-"), \(placemark.country ?? "-"), \(placemark.postalCode ?? "-")"
            }
        }
    }
}
