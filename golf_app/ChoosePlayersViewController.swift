//
//  ChoosePlayersViewController.swift
//  golf_app
//
//  Created by Matt Spiegel on 4/10/17.
//  Copyright © 2017 Matt Spiegel. All rights reserved.
//

import UIKit
import Alamofire

class ChoosePlayersViewController: UIViewController {
    
    var golfBuddies: [[String:Any]]?
//    var tableView: UITableView!
    var authToken: String?
    var roundId: Int?
    
    var delegate: ChoosePlayersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var y = 50
        for obj in golfBuddies! {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: y, width: 200, height: 60)
            let title = obj["email"] as? String
            button.setTitle("\(title!)", for: UIControlState.normal)
            button.tag = obj["id"] as! Int
            y = y + 60
            button.addTarget(self, action: #selector(ChoosePlayersViewController.addPlayer), for: UIControlEvents.touchUpInside)
            self.view.addSubview(button)
        }
    }

    @IBAction func closePlayerChoosePopover(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPlayer(sender: UIButton) {
        let id = sender.tag
        print("\(id)")
        if let tbc = tabBarController as? HomeTabController {
            self.authToken = tbc.authToken!
        }
        
        let headers: HTTPHeaders = ["Authorization": "\(String(describing: self.authToken))"]
        let parameters: Parameters = [
            "user_ids": "[\(id)]",
        ]
        Alamofire.request("https://still-refuge-37868.herokuapp.com/api/v1/rounds/\(self.roundId!)/add_players", method: .post, parameters: parameters, headers: headers).responseJSON { response in switch response.result {
        case.success:
            self.delegate?.reload()
            self.dismiss(animated: true, completion: nil)
        case.failure(let error):
            print("Failed with error message \(error)")
            }
        }


    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return golfBuddies!.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "golfBuddyCell", for: indexPath)
//        let buddy = golfBuddies![indexPath.row]
//        cell.textLabel?.text = buddy["email"] as? String
//        tableView.alwaysBounceVertical = false;
//        // Configure the cell...
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let buddy = golfBuddies![indexPath.row]
//        if let tbc = tabBarController as? HomeTabController {
//            self.authToken = tbc.authToken!
//        }
//        
//        let headers: HTTPHeaders = ["Authorization": "\(String(describing: self.authToken))"]
//        let parameters: Parameters = [
//            "user_ids": "[\(buddy["id"]!)]",
//        ]
//        Alamofire.request("https://still-refuge-37868.herokuapp.com/api/v1/rounds/\(self.roundId!)/add_players", method: .post, parameters: parameters, headers: headers).responseJSON { response in switch response.result {
//                case.success:
//                    self.delegate?.reload()
//                    self.dismiss(animated: true, completion: nil)
//                case.failure(let error):
//                    print("Failed with error message \(error)")
//            }
//        }
//        delegate?.reload()
//        self.dismiss(animated: true, completion: nil)


//    }

}
