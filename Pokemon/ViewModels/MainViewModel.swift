//
//  MainViewModel.swift
//  Pokemon
//
//  Created by Ivan Solohub on 06.08.2025.
//

import Foundation
import Observation

@Observable
final class MainViewModel {
    
    var pokemons: [Pokemon] = []
    var isLoading = false
    
    private let api = ApiDataManager()

    func fetchPokemons() {
        isLoading = true
        api.fetchPokemonsPageForGrid { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let page):
                self.pokemons.append(contentsOf: page)
            case .failure(_): break
            }
        }
    }
}
