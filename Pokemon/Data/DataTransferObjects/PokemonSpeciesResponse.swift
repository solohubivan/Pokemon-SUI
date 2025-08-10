//
//  PokemonSpeciesResponse.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

struct PokemonSpeciesResponse: Decodable {
    let flavorTextEntries: [FlavorTextEntry]
    let evolutionChain: EvolutionChain
    
    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
        case evolutionChain = "evolution_chain"
    }
    
    struct FlavorTextEntry: Decodable {
        let flavorText: String
        let language: NamedResource
        
        enum CodingKeys: String, CodingKey {
            case flavorText = "flavor_text"
            case language
        }
    }
    
    struct NamedResource: Decodable {
        let name: String
        let url: String
    }
    
    struct EvolutionChain: Decodable {
        let url: String
    }
}
