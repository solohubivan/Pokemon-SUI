//
//  MainViewModel.swift
//  Pokemon
//
//  Created by Ivan Solohub on 06.08.2025.
//

import Foundation
import Observation

@MainActor
@Observable
final class MainViewModel {
    
    var pokemons: [Pokemon] = []
    var isLoading = false
    
    let mainTitleText: String = "Know Them All"

    private let api = APIManager()

    func fetchPokemons() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let page = try await api.fetchPokemonsPageForGrid()
            pokemons += page
        } catch {
            
        }
    }
}
