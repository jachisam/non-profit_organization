//
//  FavoritesController.swift
//  NonProfitOrganizationFinder
//
//  Created by Jordan Chisam, Eesha Sabherwal on 11/12/17.
//  Copyright © 2017 Jordan Chisam, Eesha Sabherwal. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //DATA
    var theData: [String] = []
    let storage = UserDefaults.standard.array(forKey: "nonprofits") as! [String] //storage ...
    var faves: [String] = []    // favourite movies
    
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
        
        faves = storage.object(forKey: "nonprofits") as? [String] ?? [String]()
        theData = []
        
        for item in faves {
            let apiKey = "43837a3ce3a42866abb9ead7c3de29fa"
            let json = getJSON("https://api.themoviedb.org/3/movie/"+item+"?api_key="+apiKey)
            let url = json["poster_path"].stringValue
            let title = json["original_title"].stringValue
            let rating = json["vote_average"].doubleValue
            
            theData.append(NonProfit(title: title, movieID: item, url: url, rating: rating))
        }
    }
    
    // (todd sproull)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie:NonProfit = theData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        //cell.detailTextLabel?.text = theData[indexPath.row].movieID
        cell.label?.text = movie.title
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
        
        detailedVC.title = movie.title
        detailedVC.name = movie.movieID
        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    
    // https://code.tutsplus.com/tutorials/working-with-icloud-key-value-storage--pre-37542
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            var array = storage.object(forKey: "nonprofits") as? [String] ?? [String]()
            array.remove(at: indexPath.row)
            storage.set(array, forKey: "nonprofits")
            refreshFaves()
        }
    }
    
    //setup TableView (todd sproull)
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    // getJSON from github
    private func getJSON(_ url:String) -> JSON {
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url) {
                let json = try? JSON(data: data)
                return json!
            } else {
                return JSON.null
            }
        } else {
            return JSON.null
        }
        
    }
    
    // used (todd sproull) then updated image cache to suuport dictionary use
    private func cacheImages() {
        for item in theData {
            let url = URL(string: item.url)
            let id = item.movieID
            var image: UIImage? = nil
            if (url != nil) {
                let data = try? Data(contentsOf: url!)
                if (data != nil){
                    image = UIImage(data: data!)
                    theImageCache.updateValue(image, forKey: id)
                }
            }
        }
    }
    
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

}

