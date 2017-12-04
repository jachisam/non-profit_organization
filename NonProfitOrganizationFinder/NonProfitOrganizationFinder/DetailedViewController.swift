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

    
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var logoView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Do any additional setup after loading the view.
        self.logoView.image = #imageLiteral(resourceName: "logo.png")
        self.title = nonprofit.name
        info.text = "\(nonprofit.mission) \n\n Affiliation Code: \(nonprofit.affilitationCode) \n\n \(nonprofit.address) \n \(nonprofit.city), \(nonprofit.state) \(nonprofit.zip)"
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
    
    @IBAction func pushDonate(_ sender: Any) {
        
        if let webVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as? WebViewController {
            
            if nonprofit.websiteURL.range(of: "http") == nil {
                webVC.nonprofitURL = "http://\(nonprofit.websiteURL)"
            }
            else {
                webVC.nonprofitURL = "\(nonprofit.websiteURL)"
            }
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
