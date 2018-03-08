//
//  SecondViewController.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-02-11.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON
import Alamofire

class SecondViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var setUsernameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in}
        
        UIApplication.shared.registerForRemoteNotifications()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setUsernamePressed(_ sender: Any) {
        if let username = usernameField.text{
            if username.count >= 3 && username.count <= 14{
                //TODO Include notification token
                firstStart(username: username)
            }
        }
    }
    
    func firstStart(username: String){
        var json: Parameters

        if let pushToken = getNotificationToken(){
            json = [
                "Username": "\(username)",
                "NotificationToken": "\(pushToken)"
            ]
        }
        else{
            //Is null, no notification token recieved
            json = [
                "Username": "\(username)",
            ]
        }
        
        Alamofire.request("\(getMainURL())/newUser", method: .post, parameters: json, encoding: JSONEncoding.default).responseJSON { response in
            print("New user")
            
            if let data = response.data{
                let statusCode = response.response?.statusCode
                
                print("Status code: \(statusCode)")
                
                if(statusCode == 401){
                    let alert = UIAlertController(title: "Username is busy", message: "That username is taken", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else if(statusCode == 200){
                    do{
                        let responseJSON = try JSON(data: data)
                        
                        let token = responseJSON["UserToken"].string!
                        setUserToken(userToken: token)
                        
                        self.mainLabel.text = "Username set!"
                        self.usernameField.isEnabled = false
                        self.setUsernameButton.isEnabled = false
                        
                        getUserInfo()
                        
                    }
                    catch{
                        let alert = UIAlertController(title: "Something happened", message: "Something unpredicted occured. Try again later", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else{
                    print("Unkown response code. Might be an internal error on server")
                    let alert = UIAlertController(title: "Something happened", message: "Something unpredicted occured. Try again later", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}