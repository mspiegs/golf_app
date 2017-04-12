//
//  Helper.swift
//  golf_app
//
//  Created by Matt Spiegel on 3/30/17.
//  Copyright © 2017 Matt Spiegel. All rights reserved.
//

import Foundation
import Alamofire

var courses: [String:Int] = [
    "Torrey Pines South": 1
]

class Rounds {
    
    var name: String?
    var players: [[String: Any]]
    var id: Int
    var course: [String:Any]
    
    required init(name: String, players: [[String: Any]], id: Int, course: [String:Any]) {
        self.name = name
        self.players = players
        self.id = id
        self.course = course
    }

}
