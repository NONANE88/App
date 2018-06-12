//
//  LogOut.swift
//  ART-Coral
//
//  Created by Кирилл Трискало on 06.06.2018.
//  Copyright © 2018 Кирилл Трискало. All rights reserved.
//

import UIKit

class LogOut: UIViewController {


    // MARK: Кнопка запускает выход с учетной записи и перевоходит в окно Вход

    @IBAction func onPostTapped(_ sender: Any) {
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let sessionID = UserDefaults.standard.object(forKey: "sessionID") as? String
        let sessionName = UserDefaults.standard.object(forKey: "sessionName") as? String
        let cookie = sessionName!+"="+sessionID!
        
        guard let url = URL(string: "http://dinotest.art-coral.com/rest/user/logout") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accepts")
        request.addValue(token!, forHTTPHeaderField: "X-CSRF-Token")
        request.addValue(cookie, forHTTPHeaderField: "Cookie")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("этой мой json = \(json)")
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = login
            }
        
    }
    
    
    
}
    

