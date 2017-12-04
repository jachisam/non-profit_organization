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
    var regionRadius: CLLocationDistance = 5000
    var nonprofits: [NonProfit] = [] //List of nonprofits
    var nonProfitsDict = [String:NonProfit]() //Name:NonprofitObj
    var nonprofits_name: [String] = [] //String nonprofits
    let dispatchGroup = DispatchGroup() //create dispatch group where urlrequests are done together
    var searchType = "city"
    var searchValue = "san-francisco"
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
        searchBar.text = ""
        let theRadius = UserDefaults.standard.double(forKey: "currRadius")
        regionRadius = theRadius
        print(regionRadius)
        self.viewDidLoad()
        retrieveData()
    }
    
    
    

    override func viewDidLoad() {
        mapView.delegate = self
        searchBar.delegate = self

        // User's location
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchValue, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
           // if let placemark = placemarks?.first {
                self.centerMapByLocation(self.locationManager.location!, mapView: self.mapView)
           // }
        })
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        }        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        let text = searchBar.text!.replacingOccurrences(of: " ", with: "-")
        searchValue = text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBar.text!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                
                self.centerMapByLocation(placemark.location!, mapView: self.mapView)
            }
        })
        
        retrieveData()
        

    }
    
    // func that centers map on location
    func centerMapByLocation(_ location: CLLocation, mapView: MKMapView) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func retrieveData() {
        self.mapView.removeAnnotations(mapView.annotations)
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
        let finalAddress = address + searchValue        
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
