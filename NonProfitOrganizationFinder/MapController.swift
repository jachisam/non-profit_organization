//
//  MapController.swift
//  NonProfitOrganizationFinder
//
//  Created by Jordan Chisam, Eesha Sabherwal on 11/12/17.
//  Copyright © 2017 Jordan Chisam, Eesha Sabherwal. All rights reserved.
//
//https://stackoverflow.com/questions/40894722/swift-mkmapview-drop-a-pin-annotation-to-current-location

import UIKit
import MapKit
//import CoreLocation

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //OUTLETS
    @IBOutlet weak var theSwitch: UISwitch!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var regionRadius: CLLocationDistance = 50000

    let locationManager =  CLLocationManager()
    let newPin = MKPointAnnotation()
    
    //ACTIONS
    
    // Switch between map and list view --> default: map view
    @IBAction func changeMap(_ sender: Any) {
        if(theSwitch.isOn){
            mapView.mapType = .standard    // this should be set to mapview w current location
            // along with organizations within a defined radius default: 50
        } else {
            //mapView.mapType = .satellite     // this should switch to the list view where user can query by zip
            // or name of the organization
            let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as? ListViewController
            self.navigationController?.pushViewController(listVC!, animated: true)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared")
        let theRadius = UserDefaults.standard.double(forKey: "currRadius")
        regionRadius = theRadius
        centerMapByLocation((locationManager.location)!, mapView: mapView)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // User's location
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        UserDefaults.standard.set(regionRadius, forKey: "currRadius")
        centerMapByLocation((locationManager.location)!, mapView:mapView)
        
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        // add gesture recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapController.mapLongPress(_:))) // colon needs to pass through info
        longPress.minimumPressDuration = 1.5 // in seconds
        //add gesture recognition
        mapView.addGestureRecognizer(longPress)
    }
    
    // func that centers map on location
    func centerMapByLocation(_ location: CLLocation, mapView: MKMapView) {
        print(regionRadius)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // func called when gesture recognizer detects a long press
    func mapLongPress(_ recognizer: UIGestureRecognizer) {
        
        print("A long press has been detected.")
        
        let touchedAt = recognizer.location(in: self.mapView) // adds the location on the view it was pressed
        let touchedAtCoordinate : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: self.mapView) // will get coordinates
        
        let newPin = MKPointAnnotation()
        newPin.coordinate = touchedAtCoordinate
        mapView.addAnnotation(newPin)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        mapView.setRegion(region, animated: true)
        
        newPin.coordinate = location.coordinate
        mapView.addAnnotation(newPin)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
    
}
