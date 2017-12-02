//
//  WebViewController.swift
//  NonProfitOrganizationFinder
//
//  Created by labuser on 12/1/17.
//  Copyright © 2017 Jordan Chisam. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var nonprofitURL: String!
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: nonprofitURL)!
        let myURLRequest = URLRequest(url: url)
        webView.load(myURLRequest)
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    func openPage(action: UIAlertAction!) {
        let url = URL(string: "https://" + action.title!)!
        
        
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
