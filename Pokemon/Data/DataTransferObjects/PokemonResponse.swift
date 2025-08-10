//
//  PokemonResponse.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

struct PokemonResponse: Decodable {
    let results: [Pokemon]
    let next: String?
}
