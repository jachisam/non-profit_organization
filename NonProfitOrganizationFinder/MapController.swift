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

class MapController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    //OUTLETS
    @IBOutlet weak var theSwitch: UISwitch!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    var regionRadius: CLLocationDistance = 50000
    var nonprofits: [NonProfit] = [] //List of nonprofits
    var nonProfitsDict = [String:NonProfit]() //Name:NonprofitObj
    var nonprofits_name: [String] = [] //String nonprofits
    let dispatchGroup = DispatchGroup() //create dispatch group where urlrequests are done together
    var searchType = "city"
    var searchValue = "seattle"
    let locationManager =  CLLocationManager()
    let newPin = MKPointAnnotation()
    
    //ACTIONS
    
    // Switch between map and list view --> default: map view
    @IBAction func changeMap(_ sender: Any) {
        if(theSwitch.isOn){
            mapView.mapType = .standard  
        } else {
            let listVC = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as? ListViewController
            self.navigationController?.pushViewController(listVC!, animated: true)
            theSwitch.setOn(true, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theRadius = UserDefaults.standard.double(forKey: "currRadius")
        regionRadius = theRadius
        centerMapByLocation((locationManager.location)!, mapView: mapView)
        retrieveData()
    }
    

    override func viewDidLoad() {
        mapView.delegate = self
        searchBar.delegate = self
<<<<<<< HEAD
        //self.mapView.removeAnnotations(mapView.annotations)
=======
        self.mapView.removeAnnotations(mapView.annotations)
>>>>>>> aa194093a916353fbf716e3f6346164e7359284f
        super.viewDidLoad()
        // User's location
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchValue, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                //print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                self.centerMapByLocation(placemark.location!, mapView: self.mapView)
            }
        })
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        UserDefaults.standard.set(regionRadius, forKey: "currRadius")
//        centerMapByLocation((locationManager.location)!, mapView:mapView)
        //nonprofits.removeAll()
        
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        //locationManager.startUpdatingLocation()
        
        // add gesture recognizer
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapController.mapLongPress(_:))) // colon needs to pass through info
//        longPress.minimumPressDuration = 1.5 // in seconds
//        //add gesture recognition
//        mapView.addGestureRecognizer(longPress)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        let text = searchBar.text!.replacingOccurrences(of: " ", with: "-")
        searchValue = text
        // centerMapByLocation(location: , mapView: mapView)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBar.text!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                //print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                
                self.centerMapByLocation(placemark.location!, mapView: self.mapView)
                //let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
            }
        })
        
        retrieveData()
        
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        let text = searchBar.text!.replacingOccurrences(of: " ", with: "-")
        searchValue = text
        // centerMapByLocation(location: , mapView: mapView)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBar.text!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                //print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                
                self.centerMapByLocation(placemark.location!, mapView: self.mapView)
                //let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
            }
        })
        
        retrieveData()
        
       
    }
    
    // func that centers map on location
    func centerMapByLocation(_ location: CLLocation, mapView: MKMapView) {
        print(regionRadius)
        print("centering")
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // func called when gesture recognizer detects a long press
//    func mapLongPress(_ recognizer: UIGestureRecognizer) {
//        
//        print("A long press has been detected.")
//        
//        let touchedAt = recognizer.location(in: self.mapView) // adds the location on the view it was pressed
//        let touchedAtCoordinate : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: self.mapView) // will get coordinates
//        
//        let newPin = MKPointAnnotation()
//        newPin.coordinate = touchedAtCoordinate
//        mapView.addAnnotation(newPin)
//    }

    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //mapView.removeAnnotation(newPin)
//        
//        let location = locations.last! as CLLocation
//        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        
//        //set region on the map
//        mapView.setRegion(region, animated: true)
//        
//        newPin.coordinate = location.coordinate
//        mapView.addAnnotation(newPin)
//        
//    }
    
    func retrieveData() {
<<<<<<< HEAD
        //self.mapView.removeAnnotations(mapView.annotations)
=======
        self.mapView.removeAnnotations(mapView.annotations)
>>>>>>> aa194093a916353fbf716e3f6346164e7359284f
        nonprofits.removeAll()
        nonProfitsDict.removeAll()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchNonProfitData()
            DispatchQueue.main.async {
                self.dispatchGroup.notify(queue: .main) {
                    print(self.nonProfitsDict)
                    //Called when all url processing is complete. Do UI processing inside of it.
                }
            }
        }
    }
    
    func fetchNonProfitData() {
        getJSON("https://sandboxdata.guidestar.org/v1_1/search.json?q=\(searchType):\(searchValue)")
    }
    
    // Remember to allow arbitrary loads in info.plist
    private func getJSON(_ url:String) {
        let username = "80f27268088b460b9138a26c44e3266c"
        let password = ""
        let credentials = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = credentials.base64EncodedString()
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        dispatchGroup.enter()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonSearchData = try? JSON(data: data) {
                    for result in jsonSearchData["hits"].arrayValue {
                        let id = result["organization_id"].stringValue
                        let detailUrl = "https://sandboxdata.guidestar.org/v1/detail/\(id).json"
                        //print(id)
                        self.getDetailJSON(detailUrl)
                    }
                    self.dispatchGroup.leave()
                }
                else {
                    print("No Search JSON Data")
                }
            }
        }
        task.resume()
    }
    
    private func getDetailJSON(_ url:String) {
        let username = "a45b1421439743eb970b0f1bef3133e8"
        let password = ""
        let credentials = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = credentials.base64EncodedString()
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        dispatchGroup.enter()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonSearchData = try? JSON(data: data) {
                    let name = jsonSearchData["organization_name"].stringValue
                    let mission = jsonSearchData["mission"].stringValue
                    let affiliationCode = jsonSearchData["affilitation_code"].stringValue
                    let address = jsonSearchData["address_line1"].stringValue
                    let city = jsonSearchData["city"].stringValue
                    let state = jsonSearchData["state"].stringValue
                    let zip = jsonSearchData["zip"].stringValue
                    let telephone = jsonSearchData["telephone"].stringValue
                    let website = jsonSearchData["website"].stringValue
                    let id = jsonSearchData["organization_id"].stringValue
                    let nonprofit = NonProfit(name: name, mission: mission, affilitationCode: affiliationCode, address: address, city: city, state: state, zip: zip, telephone: telephone, websiteURL: website, id: id)
                    
                    
                    //print(nonprofit.name)
                    self.nonprofits.append(nonprofit)
                    self.nonProfitsDict[nonprofit.name] = nonprofit
                    self.addPinByAddress(address: nonprofit.address, name: nonprofit.name)
<<<<<<< HEAD
=======
                    print("address: ")
                    print(nonprofit.address)
>>>>>>> aa194093a916353fbf716e3f6346164e7359284f
                }
                else {
                    print("No Detail JSON Data")
                }
            }
            self.dispatchGroup.leave()
        }
        task.resume()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView Id")
        if view == nil{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView Id")
            view!.canShowCallout = true
        } else {
            view!.annotation = annotation
        }
        
        //view?.leftCalloutAccessoryView = nil
        view?.rightCalloutAccessoryView = UIButton(type: UIButtonType.infoDark)
        //swift 1.2
        //view?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let name = view.annotation!.title
        let nonprofit = nonProfitsDict[name!!]
        
        if let detailedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as? DetailedViewController {
            detailedVC.nonprofit = nonprofit
            navigationController?.pushViewController(detailedVC, animated: true)
        }
        
        print("button clicked")

    }

    func addPinByAddress(address: String, name: String) {
<<<<<<< HEAD
        let finalAddress = address + searchValue
        
=======
>>>>>>> aa194093a916353fbf716e3f6346164e7359284f
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(finalAddress, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print(placemark.location!)
                let newPin = MKPointAnnotation()
                newPin.coordinate = coordinates
                newPin.title = name
                
                self.mapView.addAnnotation(newPin)
                print("add pin")
            }
        })
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
