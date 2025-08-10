//
//  DetailPokemonInfoViewModel.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

import Observation
import SwiftUI

@Observable
final class DetailPokemonInfoViewModel {
    
    var selectedMode: PokemonDetailInfoMode = .about
    var pokemon: Pokemon?
    var isLoading = false

    private let api = ApiDataManager()
    private let cache = PokemonCacheManager.shared

    func configure(with pokemon: Pokemon) {
        if let cached = cache.load(for: pokemon.url) {
            self.pokemon = cached
        } else {
            self.pokemon = pokemon
        }
        loadIfNeeded()
    }

    func loadIfNeeded() {
        guard let p = pokemon else { return }
        let alreadyHydrated = (p.description != nil) && (p.hp != nil)
        guard !alreadyHydrated, !isLoading else { return }

        isLoading = true
        api.fetchFullDetails(for: p) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                if case let .success(updated) = result {
                    self.pokemon = updated
                    self.cache.save(updated)
                }
            }
        }
    }
}
