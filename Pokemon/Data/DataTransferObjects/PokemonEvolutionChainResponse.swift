//
//  PokemonEvolutionChainResponse.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

struct PokemonEvolutionChainResponse: Decodable {
    let chain: EvolutionNode
    
    struct EvolutionNode: Decodable {
        let species: NamedResource
        let evolvesTo: [EvolutionNode]
        let evolutionDetails: [EvolutionDetail]
        
        enum CodingKeys: String, CodingKey {
            case species
            case evolvesTo = "evolves_to"
            case evolutionDetails = "evolution_details"
        }
    }
    
    struct EvolutionDetail: Decodable {
        let trigger: NamedResource
        let minLevel: Int?
        let location: NamedResource?
        
        enum CodingKeys: String, CodingKey {
            case trigger
            case minLevel = "min_level"
            case location
        }
    }
    
    struct NamedResource: Decodable {
        let name: String
        let url: String
    }
}
