//
//  RoundsTableViewController.swift
//  golf_app
//
//  Created by Matt Spiegel on 3/30/17.
//  Copyright © 2017 Matt Spiegel. All rights reserved.
//

import UIKit
import Alamofire

class RoundsTableViewController: UITableViewController {

    var numberOfRounds: Int = 0
    var rounds = [Rounds]()
    var userId: Int = 0
    var authToken: String = ""
    var roundNames = [String]()
    var roundPlayers = [String: [Any]]()
    var roundIds = [Int]()
    var golfBuddies = [[String: Any]]()
    var refresh = UIRefreshControl()
    var course = [[String:Any]]()
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "My Rounds"
        loadBuddies()
        loadRounds()
        self.refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refresh.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refresh)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadRounds() {
        if let tbc = tabBarController as? HomeTabController {
            self.authToken = tbc.authToken!
            self.userId = tbc.userId
        }
        let headers: HTTPHeaders = ["Authorization": "\(authToken)"]
        Alamofire.request("https://still-refuge-37868.herokuapp.com/api/v1/rounds", headers: headers).responseJSON { response in switch response.result{
                case.success(let JSON):
                    let response = JSON as! [Any]
                    for item in response{
                        let obj = item as! [String: Any]
                        let round = Rounds(name: obj["name"] as! String, players: obj["users"] as! [[String: Any]], id: obj["id"] as! Int, course: obj["course"] as! [String : Any])
                        self.rounds.append(round)
                        self.roundNames.append(round.name!)
                        self.roundIds.append(round.id)
                        self.roundPlayers["\(round.name!)players"] = round.players
                        self.course.append(round.course)
                    }
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Request failed with error: \(error)")
            }
            
            
            
        }

    }
    
    func refresh(sender: AnyObject) {
        self.rounds = [Rounds]()
        self.roundNames = [String]()
        self.roundIds = [Int]()
        self.roundPlayers = [String: [Any]]()
        self.course = [[String:Any]]()
        if let tbc = tabBarController as? HomeTabController {
            self.authToken = tbc.authToken!
            self.userId = tbc.userId
        }
        let headers: HTTPHeaders = ["Authorization": "\(authToken)"]
        Alamofire.request("https://still-refuge-37868.herokuapp.com/api/v1/rounds", headers: headers).responseJSON { response in switch response.result{
        case.success(let JSON):
            let response = JSON as! [Any]
            for item in response{
                let obj = item as! [String: Any]
                let round = Rounds(name: obj["name"] as! String, players: obj["users"] as! [[String: Any]], id: obj["id"] as! Int, course: obj["course"] as! [String : Any])
                self.rounds.append(round)
                self.roundNames.append(round.name!)
                self.roundIds.append(round.id)
                self.roundPlayers["\(round.name!)players"] = round.players
                self.course.append(round.course)
            }
            if self.refresh.isRefreshing {
                self.refresh.endRefreshing()
            }
            self.tableView.reloadData()
        case .failure(let error):
            print("Request failed with error: \(error)")
            }
        }
    }
    
    func loadBuddies() {
        if let tbc = tabBarController as? HomeTabController {
            self.authToken = tbc.authToken!
        }
        let headers: HTTPHeaders = ["Authorization": "\(authToken)"]
        Alamofire.request("https://still-refuge-37868.herokuapp.com/api/v1/golf_buddies", headers: headers).responseJSON{ response in switch response.result{
                case.success(let JSON):
                    let response = JSON as! [[String: Any]]
                    self.golfBuddies = response
                case.failure(let error):
                    print("Request for golf buddies failed with error: \(error)")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rounds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoundsCell", for: indexPath)
        let roundName = roundNames[indexPath.row]
        cell.textLabel?.text = roundName
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRound" {
            let roundVC = segue.destination as? RoundViewController
            roundVC?.golfBuddies = self.golfBuddies
            let cell = sender as? UITableViewCell
            if let c = cell {
                let indexPath = tableView.indexPath(for: c)
                if let ip = indexPath {
                    let course = self.course[ip.row]
                    roundVC?.course = course
                    let roundName = roundNames[ip.row]
                    roundVC?.roundName = roundName
                    let roundId = roundIds[ip.row]
                    roundVC?.roundId = roundId
                }
            }
        }
    }

    
}
