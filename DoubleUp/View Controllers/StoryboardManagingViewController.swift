//
//  StoryboardManagingViewController.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-02-11.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import UIKit

class StoryboardManagingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        setUsername(username: nil)
//        setUserToken(userToken: n
//        setBankAmount(amount: nil)
//
//        performSegue(withIdentifier: "SegueToTutorial", sender: nil)
//        return
        
        if let token = getUserToken(){
            print("Started before, token is \(token)")
            performSegue(withIdentifier: "SegueToMain", sender: nil)
        }
        else{
            print("First start, seguing to tutorial")
            performSegue(withIdentifier: "SegueToTutorial", sender: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
