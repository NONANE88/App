//
//  AllDinosaure.swift
//  ART-Coral
//
//  Created by Кирилл Трискало on 07.06.2018.
//  Copyright © 2018 Кирилл Трискало. All rights reserved.
//


//if let data = data {
//    do {
//        // тут в option было [] , а стало mutableContainers
//        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
//        print(json)
//
//        let info = Info(json: json)
//        print("\n\nsessionID = \(info.sessionID)")
//        UserDefaults.standard.set(info.sessionID, forKey: "sessionID")
//
//

import UIKit

class AllDinosaure: UIViewController, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var dinos = [Dino]()
    
    // MARK: Кнопка обновляет tableview при стягивании ее вниз

    @objc func requestData() {        
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        tableView.rowHeight = 110
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        getDinos()
    }
    
    // MARK: Кнопка загружает объекты c сервера

    func getDinos() {
        
        guard let url = URL(string: "http://dinotest.art-coral.com/rest/dinos") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accepts")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                    print("(\n\n\n\n\n\(json)")
                    
                    let decoder = JSONDecoder()
                    let downloadedDinos = try decoder.decode(Dinos.self, from: data)
                    self.dinos = downloadedDinos.dinos
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
      }
    
    
    // MARK: Функции предназначенные для выгрузки объектов в таблицу 

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dinos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomCell else { return UITableViewCell() }
        
        cell.name.text = "Name: " + dinos[indexPath.row].dino.dinoName
        
        cell.about.text = "About: " + dinos[indexPath.row].dino.dinoAbout
        
        if let imageURL = URL(string: dinos[indexPath.row].dino.dinoImage.src) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.img.image = image
                    }
                }
            }
        }

        return cell
    }
            
    
}
    




