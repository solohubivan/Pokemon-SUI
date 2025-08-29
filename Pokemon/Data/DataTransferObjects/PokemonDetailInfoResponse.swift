//
//  PokemonDetailInfoResponse.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

struct PokemonDetailInfoResponse: Decodable {
    let abilities: [Ability]
    let sprites: Sprites
    let height: Int
    let weight: Int
    let stats: [Stat]
    let moves: [Move]

    struct Ability: Decodable {
        let ability: NamedResource
    }
    
    struct NamedResource: Decodable {
        let name: String
        let url: String
    }
    
    struct Sprites: Decodable {
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    struct Stat: Decodable {
        let baseStat: Int
        let stat: NamedResource
        
        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
        }
    }
    
    struct Move: Decodable {
        let move: NamedResource
    }
}
