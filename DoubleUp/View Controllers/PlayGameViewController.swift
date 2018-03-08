//
//  PlayGameViewController.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-02-04.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PlayGameViewController: UIViewController {
    
    @IBOutlet weak var playingWithLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var doubleUpButton: UIButton!
    @IBOutlet weak var keepMoneyButton: UIButton!
    
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    var gameID: String = ""
    var opponentUsername: String = ""
    var currentAmount: Int = 0
    var myTurn: Bool = false
    var isOver: Bool = false
    
    override func viewDidLoad() {
        loadingCircle.stopAnimating()
        
        self.title? = "Game with \(opponentUsername)"
        
        playingWithLabel.text = "Playing with \(opponentUsername)"
        
        assignValuesToOutlets()
        
        print("Amount: \(currentAmount), isOver: \(isOver), myTurn: \(myTurn)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func assignValuesToOutlets(){
        
        if myTurn {
            amountLabel.text = isOver ? "You kept \(currentAmount)" : "You got sent \(currentAmount)"
        }
        else{
            amountLabel.text = isOver ? "\(opponentUsername) kept \(currentAmount)" : "You sent \(currentAmount)"
        }
        
        playAgainButton.isEnabled = isOver
        
        doubleUpButton.isEnabled = myTurn && !isOver
        keepMoneyButton.isEnabled = myTurn && !isOver
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == doubleUpButton{
            print("Doubling!")
            playOnGame(isDoubling: true)
        }
        else if sender == keepMoneyButton{
            print("Keeping")
            playOnGame(isDoubling: false)
        }
        else{
            //Play again button
            
        }
    }
    
    func playOnGame(isDoubling: Bool){
        let amount = isDoubling ? currentAmount * 2 : currentAmount
        
        if amount > getBank()! && isDoubling{
            let alert = UIAlertController(title: "You don't have enough money to Double Up!", message: "You need \(amount) to Double Up!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            loadingCircle.stopAnimating()
            return
        }
        
        var json: Parameters
        json = [
            "Token": "\(getUserToken()!)",
            "GameID": "\(gameID)",
            "DidDouble": isDoubling,
            "CurrentAmount": amount
        ]
        
        loadingCircle.startAnimating()
        
        Alamofire.request("\(getMainURL())/playGame", method: .post, parameters: json, encoding: JSONEncoding.default).responseJSON { response in
            print("/playGame: \(json)")
            if let statusCode = response.response?.statusCode{
                print("Status code: \(statusCode)")
                
                if(statusCode == 200){
                    self.isOver = !isDoubling
                    self.myTurn = isDoubling ? false : true
                    self.currentAmount = amount
                    
                    self.assignValuesToOutlets()
                    
                    getUserInfo()
                    getGames()
                }
                else{
                    print("Not 200 at /playGame")
                }
                self.loadingCircle.stopAnimating()
            }
        }
    }
    
    func getGameOfID(){
        getGames()
        for game in gamesList{
            if game.ID == gameID{
                opponentUsername = game.opponent
                currentAmount = game.amount
                myTurn = game.turn
                isOver = game.over
                
                assignValuesToOutlets()
            }
        }
    }
    
}
