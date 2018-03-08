//
//  AppDelegate.swift
//  DoubleUp
//
//  Created by Glenn Olsson on 2018-01-24.
//  Copyright © 2018 Glenn Olsson. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("Registering for push")
        //        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        application.registerForRemoteNotifications()
        
        getGames()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        setNotificationToken(token: deviceTokenString)
        
        newStart()
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
        newStart()
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        getGames()
    }
    
    func newStart(){
        if let userToken = getUserToken(){
            var json: Parameters
            if let pushToken = getNotificationToken(){
                json = [
                    "Token": "\(userToken)",
                    "NotificationToken": "\(pushToken)"
                ]
            }
            else{
                //Is null, no notification token recieved
                json = [
                    "Token": "\(userToken)"
                ]
            }
            
            Alamofire.request("\(getMainURL())/newStartup", method: .post, parameters: json, encoding: JSONEncoding.default).responseJSON { response in
                print("New Start")
                do{
                    if let data = response.data{
                        if let statusCode = response.response?.statusCode{
                            if statusCode == 200{
                                let responseJSON = try JSON(data: data)
                                if let token = responseJSON["Token"].string{
                                    //Force changing user token
                                    setUserToken(userToken: token)
                                }
                            }
                        }
                    }
                }
                catch{
                    print("Error with NewStart")
                }
                
            }
        }
        else{
            print("Could not send /newStartup, probably because of no token")
        }
    }
}

