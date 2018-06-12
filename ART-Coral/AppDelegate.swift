//
//  AppDelegate.swift
//  ART-Coral
//
//  Created by Кирилл Трискало on 06.06.2018.
//  Copyright © 2018 Кирилл Трискало. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    // MARK: В зависимости от наличия токена приложение при запуске будет запускать окно Вход или Таблица

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        if token != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            tabBarController.selectedIndex = 0
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBarController
            
        }else{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let Login: Login = mainStoryboard.instantiateViewController(withIdentifier: "Login") as! Login
            self.window?.rootViewController = Login
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }



}

