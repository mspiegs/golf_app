//
//  AddRoundViewController.swift
//  golf_app
//
//  Created by Matt Spiegel on 4/1/17.
//  Copyright © 2017 Matt Spiegel. All rights reserved.
//

import UIKit
import Alamofire

class AddRoundViewController: UIViewController, UIPopoverPresentationControllerDelegate, ChooseCourseViewControllerDelegate {

    
    var authToken: String = ""
    var userId: Int = 0
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var roundNameField: UITextField!
    @IBOutlet weak var addRoundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addRoundButton.layer.cornerRadius = 4
        addRoundButton.center = self.view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectCourseButton(_ sender: Any) {
        
        let selectCourseVC = storyboard?.instantiateViewController(withIdentifier: "selectCoursePopover") as! ChooseCourseViewController
        selectCourseVC.delegate = self
        
        selectCourseVC.modalPresentationStyle = .popover
        if let popoverController = selectCourseVC.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self as UIPopoverPresentationControllerDelegate
        }
        present(selectCourseVC, animated: true, completion: nil)
    }
    
    func setCourse(courseString: String) {
        courseField.text = courseString
    }
    
    @IBAction func addRoundButton(_ sender: Any) {
        addRound()
    }
    
    func addRound() {
        if let tbc = tabBarController as? HomeTabController {
            self.authToken = tbc.authToken
            self.userId = tbc.userId
        }
        
        let courseId = courses[courseField.text!]
        
        let parameters: Parameters = [
            "name": "\(String(describing: roundNameField.text!))",
            "course_id":courseId!,
            "user_ids":self.userId
            
        ]
        Alamofire.request("https://still-refuge-37868.herokuapp.com/api/v1/rounds", method: .post, parameters: parameters).response
        
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

protocol ChooseCourseViewControllerDelegate {
    func setCourse(courseString: String)
}
