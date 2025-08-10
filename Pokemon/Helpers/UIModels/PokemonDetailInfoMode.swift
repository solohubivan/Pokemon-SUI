//
//  PokemonDetailInfoMode.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//


enum PokemonDetailInfoMode: String, CaseIterable, Identifiable {
    case about = "About"
    case stats = "Stats"
    case evolution = "Evolution"
    case moves = "Moves"

    var id: String { self.rawValue }
}
