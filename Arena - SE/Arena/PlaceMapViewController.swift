//
//  PlaceMapViewController.swift
//  Arena
//
//  Created by Vijay Murugappan Subbiah on 6/22/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class PlaceMapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var radius = String()
    var rating = String()
    var game = String()
    
    let locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locManager.startUpdatingLocation()
        mapView.userTrackingMode = .follow
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.785834,-122.406417&rating=\(rating)&radius=\(radius)&type=recreation&keyword=\(game)&key=AIzaSyBH2jfN-bWe0LIBaPfKEbc_WeGF8oez6X8")
        let request = URLRequest(url: url!)
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data,response,error) in
            if error != nil {
                print(error?.localizedDescription ?? 0)
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                let data = jsonData["results"] as! [[String:Any]]
                for value in data {
                    let name = value["name"] as! String
                    let address = value["vicinity"] as! String
                    if let geo = value["geometry"] as? [String:Any] {
                        if let locate = geo["location"] as? [String:Any] {
                            let placeLatitude = locate["lat"] as! Double
                            let placeLongitude = locate["lng"] as! Double
                            let placeLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(placeLatitude, placeLongitude)
                            let animation = MKPointAnnotation()
                            animation.coordinate = placeLocation
                            animation.title = name
                            animation.subtitle = address
                            self.mapView.addAnnotation(animation)
                        }
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var anview = mapView.dequeueReusableAnnotationView(withIdentifier: "place")
        if anview == nil {
            anview = MKAnnotationView(annotation: annotation, reuseIdentifier: "place")
            anview?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            anview?.rightCalloutAccessoryView = button
            anview?.image = UIImage(named: "ico-find.png")
            anview?.frame.size = CGSize(width: 35.0, height: 35.0)
        }
        else {
        anview?.annotation = annotation
        }
        return anview
    }
    
}
