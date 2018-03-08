//
//  GamesTableViewController.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-02-03.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class GamesTableViewController: UITableViewController {
    
    @IBOutlet weak var createUserButton: UIButton!
    
    var games: [Game]!
    
    var doneGames: [Game] = []
    
    var myTurnGames: [Game] = []
    var opponentTurnGames: [Game] = []
    
    @IBOutlet var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        updateLabels()
        
        getGames()
        games = gamesList
        assignGamesToLists()
        
        self.refreshControl?.addTarget(self, action: #selector(reloadTableContent(refreshControl:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        tableViewOutlet.reloadData()
        
    }
    
    @objc func reloadTableContent(refreshControl: UIRefreshControl){
        getGames()
        games = gamesList
        assignGamesToLists()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        if getUserToken() == nil{
            createUserButton.isHidden = false
        }
        
        updateLabels()
        getUserInfo()
        
        print("GETTING GAME")
        reloadTableContent(refreshControl: self.refreshControl!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadTableContent(refreshControl: self.refreshControl!)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        
        print("GETTING GAME")
        //getGames()
        reloadTableContent(refreshControl: self.refreshControl!)
        
    }
    
    func updateLabels(){
    }
    
    func assignGamesToLists(){
        doneGames.removeAll()
        myTurnGames.removeAll()
        opponentTurnGames.removeAll()
        for game in games{
            if game.over{
                doneGames.append(game)
            }
            else{
                if game.turn{
                    myTurnGames.append(game)
                }
                else{
                    opponentTurnGames.append(game)
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch section {
        case 0:
            numberOfRows = 1
        case 1:
            numberOfRows = myTurnGames.count
        case 2:
            numberOfRows = opponentTurnGames.count
        default:
            numberOfRows = doneGames.count
        }
        
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = ""
        switch section {
        case 0:
            title = nil
        case 1:
            title = "Your turn"
        case 2:
            title = "Opponent's turn"
        default:
            title = "Finished games"
        }
        
        return title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        // Do your customization
        
        view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "GameCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let row = indexPath.row
        
        var game: Game!
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            if let bank = getBank(){
                cell.textLabel?.text = String(bank)
            }
            cell.detailTextLabel?.text = getUsername()
            return cell
        case 1:
            game = myTurnGames[row]
        case 2:
            game = opponentTurnGames[row]
        default:
            game = doneGames[row]
        }
        
        cell.textLabel?.text = "\(game.opponent)"
        cell.detailTextLabel?.text = String(game.amount)
        
        if game.over{
            let textColor = game.turn ? UIColor(red: 0, green: 1, blue: 0, alpha: 1) :
                                        UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            cell.detailTextLabel?.textColor = textColor
        }
        else{
            let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.detailTextLabel?.textColor = textColor
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        
        let row = indexPath.row
        
        var game: Game!
        switch indexPath.section {
        case 0:
            //Top cell
            return
        case 1:
            game = myTurnGames[row]
        case 2:
            game = opponentTurnGames[row]
        default:
            game = doneGames[row]
        }
        
        print("ID: \(game.ID), over?  \(game.over)")
        performSegue(withIdentifier: "playGameStoryboard", sender: game)
        
    }   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playGameStoryboard"{
            let vc = segue.destination as! PlayGameViewController
            let game = sender as! Game
            vc.gameID = game.ID
            vc.currentAmount = game.amount
            vc.opponentUsername = game.opponent
            vc.myTurn = game.turn
            vc.isOver = game.over
        }
    }
    
    @IBAction func createUserButtonPressed(_ sender: Any) {
        createUserButton.isHidden = true
    }
}
