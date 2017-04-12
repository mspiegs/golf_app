//
//  ChooseCourseViewController.swift
//  golf_app
//
//  Created by Matt Spiegel on 4/1/17.
//  Copyright © 2017 Matt Spiegel. All rights reserved.
//

import UIKit

class ChooseCourseViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var courseLabel: UIButton!
    var delegate: ChooseCourseViewControllerDelegate?
    var courseString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressCourse(_ sender: Any) {
        if (self.delegate) != nil {
           delegate?.setCourse(courseString: (courseLabel.titleLabel?.text)!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
