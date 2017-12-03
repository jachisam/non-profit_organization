//
//  ListViewController.swift
//  NonProfitOrganizationFinder
//
//  Created by Jordan Chisam on 12/2/17.
//  Copyright © 2017 Jordan Chisam. All rights reserved.
//

import Foundation
import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
}
class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let myArray = ["Mary", "Bob", "Jane"]
    var nonprofits: [NonProfit] = [] //List of nonprofits
    var nonprofits_name: [String] = [] //String nonprofits
    let dispatchGroup = DispatchGroup() //create dispatch group where urlrequests are done together
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        retrieveData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func retrieveData() {
        nonprofits.removeAll()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchNonProfitData()
            DispatchQueue.main.async {
                self.dispatchGroup.notify(queue: .main) { //Called when all url processing is complete. Do UI processing inside of it.
                }
            }
        }
    }
    
    func fetchNonProfitData() {
        //If searchType & searchValue != null or not empty string, then set searchType and searchValue to searchType selected and query text entered
        let searchType = "city"
        let searchValue = "chicago"

        nonprofits = []
        getJSON("https://sandboxdata.guidestar.org/v1_1/search.json?q=\(searchType):\(searchValue)")
        print(self.nonprofits)
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
                       // print(id)
                        self.getDetailJSON(detailUrl)
                    }
                    self.dispatchGroup.leave()
                    //print(self.nonprofits)  // this one will pull data

                }
                else {
                    print("No Search JSON Data")
                }
                //print(self.nonprofits)
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
                   // print( "\(self.nonprofits_s.count) = THIS IS THE COUNT")
                }
                else {
                    print("No Detail JSON Data")
                }
            }
            self.dispatchGroup.leave()
        }

        task.resume()
    }
    

    
    // SET UP FOR THE TABLE VIEW

    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("You just unpicked this \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("You just picked this \(indexPath)")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
//       
//        myCell.textLabel?.text = myArray[indexPath.row]
//        print(myArray[indexPath.row])
//        return myCell

        let nonprofit:NonProfit = nonprofits[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        cell.label?.text = nonprofit.name
       // print(nonprofit.name)
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonprofits.count
        
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }

}
