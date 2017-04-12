//
//  DashboardViewController.swift
//  golf_app
//
//  Created by Matt Spiegel on 3/29/17.
//  Copyright © 2017 Matt Spiegel. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var authTokenLabel: UILabel!
    var authToken: String!
    var userId: Int!
    var userEmail: String!
    var numberOfRounds: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tbc = tabBarController as? HomeTabController {
            self.authToken = tbc.authToken!
            self.userEmail = tbc.userEmail!
            self.userId = tbc.userId!
        }
        // Do any additional setup after loading the view.
        
        print(userEmail)
        
        getRounds()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRounds() {
        var request = URLRequest(url: URL(string: "https://still-refuge-37868.herokuapp.com/api/v1/rounds")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(authToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, error in
            guard(error == nil) else {
                print("\(String(describing: error))")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            let parseResult: [Any]!
            do{
                parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
                print(parseResult.count)
                if let round = parseResult[2] as? [String:Any] {
                    print(round["name"]!)
                }
                for round in parseResult {
                    var round = round as? [String:Any]
                    let thisRound = (round?["name"]!)
                    print(thisRound!)
                }
            }catch {
                print("Could not parse data as json \(data)")
                return
            }
            DispatchQueue.main.async{
                let numOfRounds = parseResult.count
                self.authTokenLabel.text = "You have played \(numOfRounds) Rounds"
                                
            }
        }.resume()
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
