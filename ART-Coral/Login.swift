//
//  ViewController.swift
//  ART-Coral
//
//  Created by Кирилл Трискало on 06.06.2018.
//  Copyright © 2018 Кирилл Трискало. All rights reserved.
//

import UIKit

// MARK: Структура хранит все необходмые данные о токене,
// которые я могу использовать, например для выхода из учетной записи пользователя

struct Info {
    let sessionID: String
    let sessionName: String
    let token: String
    
    init(json: [String:Any]){
        sessionID = json["sessid"] as? String ?? "ничего"
        sessionName = json["session_name"] as? String ?? "ничего"
        token = json["token"] as? String ?? "ничего"
    }
}

class Login: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var x = false
    
    override func viewDidLoad() {
        textFieldUsername.delegate = self
        textFieldPassword.delegate = self
    }
    
    
    // MARK: Кнопка для перехода из окна Регестрации в окно Вход
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {

    }
    
    // MARK: Кнопка запускает авторизацию

    @IBAction func onPostTapped(_ sender: Any) {
        
        let parameters =
            ["username":textFieldUsername.text!,
             "password":textFieldPassword.text!,
             ]
        
        guard let url = URL(string: "http://dinotest.art-coral.com/rest/user/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accepts")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
               
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                        self.unlockApp(); return
                    }
                    self.x = true
                    
                    print(json)
                    
                    let info = Info(json: json)
                    print("\n\nsessionID = \(info.sessionID)")
                    UserDefaults.standard.set(info.sessionID, forKey: "sessionID")
                    
                    print("sessionName = \(info.sessionName)")
                    UserDefaults.standard.set(info.sessionName, forKey: "sessionName")

                    print("token = \(info.token)")
                    UserDefaults.standard.set(info.token, forKey: "token")
                    
                } catch {
                    print(error)
                  }
                }
            
                self.unlockApp()
            
            }.resume()
        
    }
    // MARK: Функция вызывает уведомление пользователю
    
    func unlockApp(){
        if self.x == true {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                tabBarController.selectedIndex = 0
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBarController
            }
        }else{
            DispatchQueue.main.async {
            self.displayAlertMessage(userMessage: "Неправильный логин или пароль")
            }
        }
    }
    
    // MARK: Функция вызывает уведомление для пользователя
    
    func displayAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Ошибка", message:userMessage, preferredStyle:UIAlertControllerStyle.alert)
        let okAction=UIAlertAction(title: "Oк", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true, completion:nil)
    }

    // MARK: Функция убирает клавиатуру при касание на пустое место
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Функция по кнопке return переходит на следующее текстовое поле

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}



