//
//  FavoritesController.swift
//  NonProfitOrganizationFinder
//
//  Created by Jordan Chisam, Eesha Sabherwal on 11/12/17.
//  Copyright © 2017 Jordan Chisam, Eesha Sabherwal. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController{
//class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    /*
    
    //DATA
    var theData: [NonProfit] = []
    let storage = UserDefaults.standard.array(forKey: "nonprofits") as! [String] //storage ...
    
    // https://stackoverflow.com/questions/25392124/swift-func-viewwillappear
    // needed in order to refresh favourites list during same app launch
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshFaves()
    }
    
    // update the favourites between tabs
    private func refreshFaves() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchFavourites()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // fetch data for the favourites
    private func fetchFavourites() {
    
        theData = []
        
        for item in storage {
            //change to our website and pull by name
            let apiKey = "43837a3ce3a42866abb9ead7c3de29fa"
            let json = getJSON("https://api.themoviedb.org/3/movie/"+item+"?api_key="+apiKey)
            
        }
    }
    
    // (todd sproull)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nonprofFav:NonProfit = theData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellFav", for: indexPath) as! MyTableViewCell
      
        cell.label?.text = nonprofFav.name
        return cell
    }
    
    // num rows in section (todd sproull)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
        
    }
    
    // Open information for movie (todd sproull)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie:NonProfit = theData[indexPath.row]
        let detailedVC = storyboard!.instantiateViewController(withIdentifier: "OrganizationPage") as! DetailedViewController //DetailedViewController()
        
        //detailedVC.title = nonprofFav.name
        //detailedVC.name = movie.movieID
        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    
    // https://code.tutsplus.com/tutorials/working-with-icloud-key-value-storage--pre-37542
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
           // var array = storage.array(forKey: "nonprofits") as? [String]
      //      array.remove(at: indexPath.row)
       //     storage.set(array, forKey: "nonprofits")
       //     refreshFaves()
        }
    }
    
    //setup TableView (todd sproull)
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func getJSON(_ url:String) {
        let username = "80f27268088b460b9138a26c44e3266c"
        let password = ""
        let credentials = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = credentials.base64EncodedString()
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
       // dispatchGroup.enter()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonFavData = try? JSON(data: data) {
                    for result in jsonFavData["hits"].arrayValue {
                        let id = result["organization_id"].stringValue
                        let detailUrl = "https://sandboxdata.guidestar.org/v1/detail/\(id).json"
                        //print(id)
                        self.getDetailJSON(detailUrl)
                    }
                    //self.dispatchGroup.leave()
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
        
        //dispatchGroup.enter()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonFavData = try? JSON(data: data) {
                    let name = jsonFavData["organization_name"].stringValue
                    let mission = jsonFavData["mission"].stringValue
                    let affiliationCode = jsonFavData["affilitation_code"].stringValue
                    let address = jsonFavData["address_line1"].stringValue
                    let city = jsonFavData["city"].stringValue
                    let state = jsonFavData["state"].stringValue
                    let zip = jsonFavData["zip"].stringValue
                    let telephone = jsonFavData["telephone"].stringValue
                    let website = jsonFavData["website"].stringValue
                    let id = jsonFavData["organization_id"].stringValue
                    
                    let nonprofit = NonProfit(name: name, mission: mission, affilitationCode: affiliationCode, address: address, city: city, state: state, zip: zip, telephone: telephone, websiteURL: website, id: id)
                    
                    //print(nonprofit.name)
                    self.theData.append(nonprofit)
                }
                else {
                    print("No Detail JSON Data")
                }
            }
      //      self.dispatchGroup.leave()
        }
        task.resume()
    }
    
    // used (todd sproull) then updated image cache to suuport dictionary use
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
 */

}

