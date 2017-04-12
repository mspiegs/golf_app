//
//  RoundViewController.swift
//  golf_app
//
//  Created by Matt Spiegel on 4/2/17.
//  Copyright © 2017 Matt Spiegel. All rights reserved.
//

import UIKit
import Alamofire

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerCell1: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class RoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate,ChoosePlayersViewControllerDelegate {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var roundName: String?
    var roundPlayers = [Any]()
    var golfBuddies: [[String:Any]]?
    var roundId: Int?
    var authToken: String?
    var course: [String:Any] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = roundName
        self.navigationItem.backBarButtonItem?.title = "Rounds"
        courseNameLabel.text = course["name"] as? String
        loadRound()
    }

    @IBAction func addPlayerButton(_ sender: UIButton) {
        let selectPlayersVC = storyboard?.instantiateViewController(withIdentifier: "selectPlayersPopover") as! ChoosePlayersViewController
        selectPlayersVC.delegate = self
        
        selectPlayersVC.modalPresentationStyle = .popover
        selectPlayersVC.golfBuddies = self.golfBuddies
        selectPlayersVC.roundId = self.roundId
        if let popoverController = selectPlayersVC.popoverPresentationController {
            popoverController.sourceView = sender as UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self as UIPopoverPresentationControllerDelegate
        }
        present(selectPlayersVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roundPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playersCell", for: indexPath) as! PlayerTableViewCell
        let player = roundPlayers[indexPath.row] as! [String:Any]
//        cell.textLabel?.text = player["first_name"] as? String
        cell.firstNameLabel.text = player["first_name"] as? String
        cell.playerCell1?.text = player["last_name"] as? String
        tableView.alwaysBounceVertical = false;
        cell.layoutIfNeeded()
        cell.contentView.bringSubview(toFront: cell.playerCell1)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func reload() {
        loadRound()
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tableView.reloadData()
    }
    
    func loadRound() {
        if let tbc = tabBarController as? HomeTabController {
            self.authToken = tbc.authToken!
        }
        let headers: HTTPHeaders = ["Authorization": "\(authToken!)"]
        Alamofire.request("https://still-refuge-37868.herokuapp.com/api/v1/rounds/\(self.roundId!)", headers: headers).responseJSON { response in switch response.result {
                case.success(let JSON):
                    let response = JSON as! [String: Any]
                    self.roundPlayers = response["users"] as! [[String: Any]]
                    print(self.roundPlayers)
                    self.tableView.reloadData()
                case.failure(let error):
                    print("Request failed with error: \(error)")
            
            }
        }
    }

}

protocol ChoosePlayersViewControllerDelegate {
    func reload()
}
