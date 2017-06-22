//
//  MapViewController.swift
//  Arena
//
//  Created by Vijay Murugappan Subbiah on 5/24/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var uidArray = [String]()
    //let uid = String()
    var name = [String]()
    var sport = [String]()
    var address = [String]()
    var counter = 0
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.mapType = .hybrid
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locManager.startUpdatingLocation()
        mapView.userTrackingMode = .follow
        print("UID ARRAY : \(uidArray)")
        addAnnotation()
    }
    
//    func zoom() {
//        let loc = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
//        let region = MKCoordinateRegionMakeWithDistance(loc, 2000, 2000)
//        mapView.setRegion(region, animated: true)
//
//    }
    
    func addAnnotation() {
        let ref = FIRDatabase.database().reference() //creating root referenence
        for uid in uidArray {
        let chdref = ref.child(uid) //creating path for child
        chdref.observe(.value, with: {(FIRDataSnapshot) in
            if let result = FIRDataSnapshot.children.allObjects as? [FIRDataSnapshot] {
                self.counter += 1
                self.name.append((result[4].value as? String)!)
                self.sport.append((result[10].value as? String)!)
                self.address.append((result[0].value as? String)!)
                //print("A \(self.address)")
                if(self.counter == self.uidArray.count) {
                    self.geoCoding(_address: self.address,_name: self.name,_sport: self.sport)
                }
                //self.geoCoding(_address: (result[0].value as? String)!)
            }
        })
        }
    }
    
    func geoCoding(_address: [String], _name: [String], _sport: [String]) {
        //print(_address)
        let name = _name[i]
        let sport = _sport[i]
        geocoder.geocodeAddressString(_address[i]) { (placemarks,error) in
            self.i += 1
            //print(self.i)
            self.processResponse(withPlacemarks: placemarks, error: error, _name: name,_sport: sport)
            if(self.i == self.uidArray.count) {
                
            }
            else {
                self.geoCoding(_address: _address,_name: _name,_sport: _sport)
            }
        }
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, _name: String, _sport: String) {
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
        }
        else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                //print(coordinate.latitude)
                //print(coordinate.longitude)
                let distLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
                print(mapView.userLocation.coordinate)
                let distance = (distLocation.distance(from: location))
                print("DISTANCE \(distance)")
                if(distance <= 2000) {
                let objAnimation = MKPointAnnotation()
                objAnimation.coordinate = pinLocation
                objAnimation.title = _name
                objAnimation.subtitle = _sport
                self.mapView.addAnnotation(objAnimation)
                }
            } else {
                print("No Matching Location Found")
            }
        }
    }
}
