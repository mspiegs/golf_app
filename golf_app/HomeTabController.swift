//
//  HomeTabController.swift
//  golf_app
//
//  Created by Matt Spiegel on 3/30/17.
//  Copyright © 2017 Matt Spiegel. All rights reserved.
//

import UIKit

class HomeTabController: UITabBarController {

    var authToken: String!
    var userId: Int!
    var userEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            print("HomeTab Segue")
            let tabVC = segue.destination as! DashboardViewController
            tabVC.authToken = authToken
        }
    
}
