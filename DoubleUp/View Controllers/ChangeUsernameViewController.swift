//
//  SettingsViewController.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-02-03.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class ChangeUsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        usernameField.placeholder = getUsername()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool){
            statusLabel.text = ""
            statusLabel.isHidden = true
    }
    
    @IBAction func saveNewUsernameClicked(_ sender: Any) {
        
        self.statusLabel.text = ""
        
        if let username = usernameField.text{
            if username.count > 2 && username.count < 15{
                changeUsername(username: username)
            }
            else{
                statusLabel.text = "Username needs to be 3-14 charachters!"
                statusLabel.textColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    func changeUsername(username: String){
        if let token = getUserToken(){
            
            var json: Parameters
            json = [
                "Token": "\(token)",
                "Username": "\(username)"
            ]
            
            Alamofire.request("\(getMainURL())/changeUsername", method: .post, parameters: json, encoding: JSONEncoding.default).responseJSON { response in
                print("Changing username")
                if let statusCode = response.response?.statusCode{
                    
                    if(statusCode == 401){
                        let alert = UIAlertController(title: "Username is busy", message: "That username is taken", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if(statusCode == 200){
                        let alert = UIAlertController(title: "Succesfully changed username", message: "You are now \(username)!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        setUsername(username: username)
                    }
                    else{
                        let alert = UIAlertController(title: "Something happened", message: "Something unpredicted occured. Try again later", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        else{
            //No token
            let alert = UIAlertController(title: "Create user first", message: "You need to set a username before you can change it. Go to the home screen and press the \"Set username\" button", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}















