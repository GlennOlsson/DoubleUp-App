//
//  NewGameViewController.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-02-11.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NewGameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var opponentUsernameField: UITextField!
    
    @IBOutlet weak var sendNewGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        opponentUsernameField.delegate = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Double Up!", style: .plain, target: nil, action: #selector(buttonTapped(_:)))
        // Do any additional setup after loading the view.
    }
    
    @objc func buttonTapped(_ sender : Any?){
        print("HEYHEY")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendButtonPressed(sendNewGameButton)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let opponentField = opponentUsernameField.text
        
        if opponentField == nil || (opponentField!.count >= 3 && opponentField!.count <= 14) || opponentField!.count == 0 {
            
            if let token = getUserToken(){
                
                sendNewGameButton.isEnabled = false
                
                if getBank()! < 1{
                    let alert = UIAlertController(title: "You don't have enough money to start a new game", message: "You need 1 in-game currency to Double Up!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                var json: Parameters
                json = [
                    "Token": "\(token)",
                    "StartAmount": 1
                ]
                
                if let username = opponentField{
                    if username.count > 1{
                        json["RequestedOpponent"] = "\(username)"
                    }
                }
                
                Alamofire.request("\(getMainURL())/newGame", method: .post, parameters: json, encoding: JSONEncoding.default).responseJSON { response in
                    print("/newGame: \(json)")
                    if let data = response.data{
                        do{
                            if let statusCode = response.response?.statusCode{
                                print("Status code: \(statusCode)")
                                
                                if(statusCode == 200){
                                    let responseJSON = try JSON(data: data)
                                    let opponent = responseJSON["OpponentUsername"].string!
                                    let gameID = responseJSON["GameID"].string!
                                    
                                    sender.isEnabled = false
                                    
                                    let newGame = Game(opponent: opponent, over: false, ID: gameID, currentAmount: 1, turn: false)
                                    
                                    getUserInfo()
                                    getGames()
                                    
                                    self.performSegue(withIdentifier: "playGameStoryboard", sender: newGame)
                                    self.sendNewGameButton.isEnabled = true
                                }
                                else if statusCode == 401{
                                    let alert = UIAlertController(title: "No user found", message: "There is no user with that username. Try another", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    self.sendNewGameButton.isEnabled = true
                                }
                                else if statusCode == 402{
                                    let alert = UIAlertController(title: "No user found", message: "Could not find a random user. Try again later", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    self.sendNewGameButton.isEnabled = true
                                }
                            }
                        }
                        catch{
                            let alert = UIAlertController(title: "Something happened", message: "Something unpredicted occured. Try again later", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.sendNewGameButton.isEnabled = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playGameStoryboard"{
            let game = sender as! Game
            let vc = segue.destination as! PlayGameViewController
            vc.gameID = game.ID
            vc.currentAmount = game.amount
            vc.opponentUsername = game.opponent
            vc.myTurn = game.turn
            vc.isOver = game.over
        }
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
