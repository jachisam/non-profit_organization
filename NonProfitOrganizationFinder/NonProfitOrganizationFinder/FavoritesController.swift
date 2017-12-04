//
//  FavoritesController.swift
//  NonProfitOrganizationFinder
//
//  Created by Jordan Chisam, Eesha Sabherwal on 11/12/17.
//  Copyright © 2017 Jordan Chisam, Eesha Sabherwal. All rights reserved.
//

import Foundation
import UIKit

class FavesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var nonProfitNames: [String] = []
    
    @IBOutlet weak var favesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        favesTable.dataSource = self
        favesTable.delegate = self
        favesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nonProfitNames = []
        let defaults = UserDefaults.standard
        if let temp = defaults.array(forKey: "nonprofits") {
            for nonProfit in temp {
                nonProfitNames.append(nonProfit as! String)
            }
        }
        else {
            defaults.set([String](), forKey: "nonprofits")
        }
        print(nonProfitNames)
        favesTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel!.text = nonProfitNames[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonProfitNames.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            nonProfitNames.remove(at: indexPath.row)
            
            let defaults = UserDefaults.standard
            defaults.set(nonProfitNames, forKey: "nonprofits")
            favesTable.reloadData()
        }
    }
}
