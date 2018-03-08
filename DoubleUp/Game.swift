//
//  Game.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-02-03.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import Foundation
import SwiftyJSON

class Game{
    var opponent: String
    var over: Bool
    var ID: String
    var amount: Int
    var turn: Bool
    
    private let OPPONENT_KEY = "OpponentUsername"
    private let IS_OVER_KEY = "IsOver"
    private let GAME_ID_KEY = "GameID"
    private let CURRENT_AMOUNT_KEY = "CurrentAmount"
    private let TURN_KEY = "Turn"
    
    init(opponent: String, over: Bool, ID: String, currentAmount: Int, turn: Bool) {
        self.opponent = opponent
        self.over = over
        self.ID = ID
        amount = currentAmount
        self.turn = turn
    }
    init(json: JSON) {
        opponent = json[OPPONENT_KEY].string!
        over = json[IS_OVER_KEY].bool!
        ID = json[GAME_ID_KEY].string!
        amount = json[CURRENT_AMOUNT_KEY].int!
        turn = json[TURN_KEY].bool!
    }
    
    func asJson() -> JSON{
        var json = JSON()
        json[OPPONENT_KEY].string = self.opponent
        json[IS_OVER_KEY].bool = self.over
        json[GAME_ID_KEY].string = self.ID
        json[CURRENT_AMOUNT_KEY].int = self.amount
        json[TURN_KEY].bool = self.turn
        
        return json
    }
}
