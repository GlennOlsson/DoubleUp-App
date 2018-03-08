//
//  SettingsRootTableViewController.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-03-05.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import UIKit
import StoreKit

class SettingsRootTableViewController: UITableViewController {
    
    @IBOutlet weak var buildLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildLabel.textColor = UIColor(displayP3Red: 0.498, green: 0.498, blue: 0.498, alpha: 1)
        let nsObject = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        if let buildVersion = nsObject{
            print("Build: \(buildVersion)")
            buildLabel.text = buildVersion
        }
        else{
            buildLabel.text = "ERROR"
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 1 : 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 1{
            if row == 0{
                //Rate us cell
                SKStoreReviewController.requestReview()
            }
            else if row == 1 {
                //About cell
                let linkNoProtocol = "://glennolsson.se/DoubleUp"
                if UIApplication.shared.canOpenURL(NSURL(string: "googlechrome\(linkNoProtocol)")! as URL) {
                    UIApplication.shared.open(NSURL(string: "googlechrome\(linkNoProtocol)")! as URL, options: [:], completionHandler: nil)
                } else {
                    print("Chrome is not installed, opening in safari")
                    UIApplication.shared.open(NSURL(string: "https\(linkNoProtocol)")! as URL, options: [:], completionHandler: nil)
                }
            }
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
