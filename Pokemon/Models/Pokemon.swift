//
//  Pokemon.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

import Foundation

struct Pokemon: Codable, Hashable {
    let name: String
    let url: String
    var imageURL: String?
    var abilities: [String]?
    var height: Int?
    var weight: Int?
    var attack: Int?
    var damage: Int?
    var description: String?
    
    var hp: Int?
    var defense: Int?
    var specialAttack: Int?
    var specialDefense: Int?
    var speed: Int?
    
    var nextEvolutions: [String]?
    var evolutionTrigger: String?
    var minLevel: Int?
    var evolutionLocation: String?
    
    var moves: [String]?
}
