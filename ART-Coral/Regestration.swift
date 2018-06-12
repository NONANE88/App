//
//  ViewController.swift
//  ART-Coral
//
//  Created by Кирилл Трискало on 06.06.2018.
//  Copyright © 2018 Кирилл Трискало. All rights reserved.
//


import UIKit

class Regestration: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!

    var textAlert: String = ""

    override func viewDidLoad() {
        textFieldUsername.delegate = self
        textFieldPassword.delegate = self
        textFieldEmail.delegate = self
    }
    
    // MARK: Функция убирает клавиатуру при касание на пустое место
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Кнопка открывает окно Входа
    
    @IBAction func logIn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Login = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = Login
    }
    
    // MARK: Кнопка запускает регестрацию
    
    @IBAction func onPostTapped(_ sender: Any) {
        
        let result = checkAllValidation(pass: textFieldPassword.text, eml: textFieldEmail.text)
        if result == true{
            let parameters =
                ["name":textFieldUsername.text!,
                 "pass":textFieldPassword.text!,
                 "mail":textFieldEmail.text!,
                ]
            
            guard let url = URL(string: "http://dinotest.art-coral.com/rest/user") else { return }
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
                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                
                        print(json)
                    } catch {
                        print(error)
                    }
                 }
                }.resume()
            DispatchQueue.main.async {
                self.displayAlertMessage2(userMessage: "Регестрация прошла успешно")
            }
        }else{
            print("Уведомление: \n\(textAlert)")
            displayAlertMessage(userMessage: textAlert)
            
        }
        textAlert = ""

    }
  
    // MARK: Функция проверяет на валидацию email

    func isValidEmail(email: String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailTest.evaluate(with: email)
    }
    
    // MARK: Функция проверяет на валидацию пароль
    
    func isValidPassword(password: String)->Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z].*[a-z])(?=.*[0-9].*[0-9].*[0-9]).{8,}$")
        let result = passwordTest.evaluate(with: password)
        
        return result
    }
    
    // MARK: Функция проверяет на валидацию подфункции
    // и реагирует в зависимости от возвращаемых значений

    func checkAllValidation( pass:String?, eml:String?)->Bool{
        
        var result1: Bool = false
        var result2: Bool = false
        var result3: Bool = false
        
        var passwordForCheck: String?
        var emailForCheck: String?
        
        passwordForCheck = pass ?? "ничего"
        emailForCheck = eml ?? "ничего"
        
        if textFieldUsername.text ==  "", textFieldPassword.text == "", textFieldEmail.text == ""{
            textAlert = "1.Не заполненны текстовые поля\n"
        }else{
            result1 = true
        }
        
        if isValidEmail(email: emailForCheck!) == false{
            result2 = isValidEmail(email: emailForCheck!)
            textAlert += "2.Некоректный введенный email-адрес\n"
        }else{
            result2 = true
        }
        
        if isValidPassword(password: passwordForCheck!) == false{
            result3 = isValidPassword(password: passwordForCheck!)
            textAlert += "3.Ненадежный пароль. Пароль должен содержать: 1 большую букву, 2 маленьких , 3 цифры и быть не меньше 8 символов\n"
        }else{
            result3 = true
        }
        
        print("\(result1), \(result2), \(result3)")
        if result1 == true, result2 == true, result3 == true{
            return true
        }else{
            return false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func displayAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Ошибка", message:userMessage, preferredStyle:UIAlertControllerStyle.alert)
        let okAction=UIAlertAction(title: "Oк", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true, completion:nil)
    }
    
    func displayAlertMessage2(userMessage:String){
        let myAlert = UIAlertController(title: nil, message:userMessage, preferredStyle:UIAlertControllerStyle.alert)
        let okAction=UIAlertAction(title: "Oк", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true, completion:nil)
    }
  
}
    














