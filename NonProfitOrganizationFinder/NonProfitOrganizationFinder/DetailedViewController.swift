//
//  DetailedViewController.swift
//  NonProfitOrganizationFinder
//
//  Created by Jordan Chisam, Eesha Sabherwal on 11/19/17.
//  Copyright © 2017 Jordan Chisam, Eesha Sabherwal. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    var nonprofit: NonProfit!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = nonprofit.name
        name.text = nonprofit.name
        info.text = "\(nonprofit.name) \n\n Mission: \(nonprofit.mission) \n\n Affiliation Code: \(nonprofit.affilitationCode) \n\n \(nonprofit.address) \n \(nonprofit.city), \(nonprofit.state) \(nonprofit.zip) \n \(nonprofit.telephone) \t \(nonprofit.websiteURL)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveToFavorites(_ sender: Any) {
        let defaults = UserDefaults.standard
        if let temp = defaults.array(forKey: "nonprofits") {
            var array = temp
            array.append(nonprofit.name)
            defaults.set(array, forKey: "nonprofits")
        }
        else {
            defaults.set([String](), forKey: "nonprofits")
            var array = defaults.array(forKey: "nonprofits") as! [String]
            array.append(nonprofit.name)
            defaults.set(array, forKey: "nonprofits")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushWeb" {
            let webVC = segue.destination as? WebViewController
            webVC!.nonprofitURL = "http://\(nonprofit.websiteURL)"
        }
    }
}
