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
    var isLoading: Bool = false
    
    private let apiDataManager = ApiDataManager()

    func fetchPokemons() {
        isLoading = true
        apiDataManager.fetchPokemons { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let newPokemons):
                    self.apiDataManager.fetchDetailsForPokemons(pokemons: newPokemons) { detailedPokemons in
                        self.pokemons.append(contentsOf: detailedPokemons)
                    }
                case .failure(let error):
                    print("Error:", error.localizedDescription)
                }
            }
        }
    }
    
}
