//
//  Dino.swift
//  
//
//  Created by Кирилл Трискало on 07.06.2018.
//



import UIKit

class Dinos: Codable {
    let dinos: [Dino]
    
    init(dinos: [Dino]) {
        self.dinos = dinos
    }
    
    private enum CodingKeys: String, CodingKey {
        case dinos = "dinos"
    }
}

class Dino: Codable {
    let dino: DinoData
}

class DinoData: Codable {
    let dinoName: String
    let dinoAbout: String
    let dinoImage: DinoImage

    init(dino_title: String, dino_about: String, dino_image: DinoImage){
        self.dinoName = dino_title
        self.dinoAbout = dino_about
        self.dinoImage = dino_image
    }
    
    private enum CodingKeys: String, CodingKey {
        case dinoName = "dino_title"
        case dinoAbout = "dino_about"
        case dinoImage = "dino_image"
    }

}

class DinoImage: Codable{
    let alt: String
    let src: String

    init(alt: String,src: String){
        self.alt = alt
        self.src = src
    }

    private enum CodingKeys: String, CodingKey {
        case alt = "alt"
        case src = "src"
    }
    
}


















