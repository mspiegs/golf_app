//
//  MainViewController.swift
//  golf_app
//
//  Created by Matt Spiegel on 3/28/17.
//  Copyright © 2017 Matt Spiegel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    //Properties
    
    var authToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        submitButton.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Actions
    @IBAction func userCredSubmit(_ sender: UIButton) {
        login()
        
    }
    
    
    func login(){
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.addSubview(activityIndicator) // add it as a  subview
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5) // put in the middle
        activityIndicator.startAnimating()
        if let emailAddress = userEmail?.text,
            let password = userPassword?.text{
            let url:String = "https://still-refuge-37868.herokuapp.com/api/v1/sessions"
            var urlRequest = URLRequest(url: (URL(string: url))!)
            urlRequest.httpMethod = "POST"
            let postString = "email=\(String(describing: emailAddress))&password=\(String(describing: password))"
            urlRequest.httpBody = postString.data(using: .utf8)
        
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard(error == nil) else {
                    print("\(String(describing: error))")
                    return
                }
                
                guard let data = data else {
                    print("No data returned")
                    return
                }
                
                let parseResult: [String: Any]!
                do{
                    parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    print(parseResult)
                    activityIndicator.stopAnimating()
                }catch {
                    print("Could not parse data as json \(data)")
                    return
                }
                //check jsonArray and switch to LoginViewController
                if(parseResult["auth_token"] == nil ){
                    print("jsonArray not found")
                    return
                } else{
                    DispatchQueue.main.async{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeTabController") as! HomeTabController
                        viewController.authToken = parseResult["auth_token"] as! String
                        viewController.userEmail = parseResult["email"] as! String
                        viewController.userId = parseResult["id"] as! Int
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }.resume()
        }
    }
    

}
