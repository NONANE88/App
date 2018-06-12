//
//  AddDino.swift
//  ART-Coral
//
//  Created by Кирилл Трискало on 09.06.2018.
//  Copyright © 2018 Кирилл Трискало. All rights reserved.
//

import UIKit

class AddDino: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate  {
    
    
    @IBOutlet weak var nameDino: UITextField!
    @IBOutlet weak var typeDino: UITextField!
    @IBOutlet weak var aboutDino: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    
    
    override func viewDidLoad() {
        nameDino.delegate = self
        typeDino.delegate = self
        aboutDino.delegate = self

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @objc func importImage(_ sender: AnyObject){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true){
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImageView.image = image
        }
        else{
            print("Какая-то ошибка")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
   

    @IBAction func onPostTapped(_ sender: Any) {
        if (nameDino.text != nil && typeDino.text != nil && aboutDino.text != nil && myImageView.image != nil ){
            
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let sessionID = UserDefaults.standard.object(forKey: "sessionID") as? String
        let sessionName = UserDefaults.standard.object(forKey: "sessionName") as? String
        let cookie = sessionName!+"="+sessionID!
        
        // Параметры + наверно обязательные параметры дата и цвет динозавра 
        let image: UIImage = myImageView.image!
        let imageData  = UIImageJPEGRepresentation(image, 1.0)!
        let fileContent = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let about3: String = aboutDino.text!
        let about2 = ["value":about3]
        let about =  ["und":about2]
        
        let type: String = typeDino.text!
        let name: String = nameDino.text!
        
        let parameters =
            ["title"                : name,
             "type"                 : type,
             "field_dino_about"     : about,
             "field_dito_image"     : fileContent
                ] as [String : Any]
        

        guard let url = URL(string: "http://dinotest.art-coral.com/rest/node") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accepts")
        request.addValue(token!, forHTTPHeaderField: "X-CSRF-Token")
        request.addValue(cookie, forHTTPHeaderField: "Cookie")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            
        }.resume()
        }else{
            displayAlertMessage(userMessage: "Заполнители все текстовые поля и вставьте картинку")
        }
    }
    func displayAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Ошибка", message:userMessage, preferredStyle:UIAlertControllerStyle.alert)
        let okAction=UIAlertAction(title: "Oк", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true, completion:nil)
    }
    
}



