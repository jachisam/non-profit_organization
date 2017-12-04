//
//  SettingsViewController.swift
//  NonProfitOrganizationFinder
//
//  Created by Jordan Chisam, Eesha Sabherwal on 11/19/17.
//  Copyright © 2017 Jordan Chisam, Eesha Sabherwal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var radius:Double!
    @IBOutlet weak var newRadius: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func radiusChanged(_ sender: Any) {
        radius = Double(newRadius.text!)!
        newRadius.text! = ""
        UserDefaults.standard.set(radius, forKey: "currRadius")
    }
}
