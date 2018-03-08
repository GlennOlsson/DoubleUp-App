//
//  Constants.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-01-29.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

let defaults = UserDefaults.standard

let USER_TOKEN_KEY = "Token"
let USERNAME_KEY = "Username"
let BANK_KEY = "Bank"
let GAMES_KEY = "Games"
let NOTIFICATION_TOKEN_KEY = "NotificationToken"


var gamesList: [Game] = []

func getMainURL() -> String{
    return "https://glennolsson.se/DoubleUp/api"
}

func getUserToken() -> String?{
    return defaults.string(forKey: USER_TOKEN_KEY)
}

func setUserToken(userToken: String?){
    defaults.set(userToken, forKey: USER_TOKEN_KEY)
}

func setUsername(username: String?){
    defaults.set(username, forKey: USERNAME_KEY)
}

func getUsername() -> String?{
    return defaults.string(forKey: USERNAME_KEY)
}

func setBankAmount(amount: Int?){
    defaults.set(amount, forKey: BANK_KEY)
}

func getBank() -> Int?{
    return defaults.integer(forKey: BANK_KEY)
}

func setNotificationToken(token: String?){
    defaults.set(token, forKey: NOTIFICATION_TOKEN_KEY)
}

func getNotificationToken() -> String?{
    return defaults.string(forKey: NOTIFICATION_TOKEN_KEY)
}

func isFirstStart() -> Bool{
    if getUserToken() != nil{
        return false
    }
    return true
}

func setGames(gamesArray: [Game]){
    var jsonArray: [JSON] = []
    for game in gamesArray{
        let gameAsJSON = game.asJson()
        jsonArray.append(gameAsJSON)
    }
    
    var jsonObject = JSON()
    jsonObject.arrayObject = jsonArray
    
    defaults.set(jsonObject.arrayObject, forKey: GAMES_KEY)
}

func getGames(){
    if let stringArray = defaults.array(forKey: GAMES_KEY){
        //Games has been added before
        print("Loading earlier games")
        
        let JsonObject = JSON(stringArray)
        let JsonArray = JsonObject.arrayValue
        var gameArray: [Game] = []

        for element in JsonArray{
            let gameAsJson = JSON(element)
            let game = Game(json: gameAsJson)
            gameArray.append(game)
        }
        gamesList = gameArray
    }
    
    else{
        print("NOPE")
    }
    
    
    if let token = getUserToken(){
        Alamofire.request("\(getMainURL())/games/\(token)", method: .get, encoding: JSONEncoding.default).responseJSON { response in
            print("/Games/\(token)")
            
            if let data = response.data{
                do{
                    if let statusCode = response.response?.statusCode{
                        print("Status code: \(statusCode)")
                        if(statusCode == 401){
                            //TODO Connection error
                        }
                        else if(statusCode == 200){
                            let responseJSON = try JSON(data: data)
                            let gamesArray = responseJSON.arrayValue
                            
                            var localGamesList: [Game] = []
                            
                            for gameJSON in gamesArray{
                                let newGame = Game(json: gameJSON)
                                localGamesList.append(newGame)
                            }
                            
                            setGames(gamesArray: localGamesList)
                            gamesList = localGamesList
                            
                        }
                        else{
                            //TODO Connection error
                        }
                    }
                }
                catch{
                    print("ERROR, fuck!")
                }
            }
        }
    }
}


func getUserInfo(){
    if let token = getUserToken(){
        Alamofire.request("\(getMainURL())/userInfo/\(token)", method: .get, encoding: JSONEncoding.default).responseJSON { response in
            print("/userInfo/\(token)")
            
            if let data = response.data{
                do{
                    if let statusCode = response.response?.statusCode{
                        print("Status code: \(statusCode)")
                        if(statusCode == 401){
                            //TODO Connection error
                        }
                        else if(statusCode == 200){
                            let responseJSON = try JSON(data: data)
                            
                            let bankAmount = responseJSON["BankAmount"].int!
                            let username = responseJSON["Username"].string!
                            
                            setBankAmount(amount: bankAmount)
                            setUsername(username: username)
                            
                        }
                        else{
                            //TODO Connection error
                        }
                    }
                }
                catch{
                    print("ERROR, fuck!")
                }
            }
        }
    }
}








