//
//  DetailPokemonInfoViewModel.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class DetailPokemonInfoViewModel {

    var selectedMode: PokemonDetailInfoMode = .about
    var pokemon: Pokemon?
    var isLoading = false

    private let api = APIManager()
    private let cache = PokemonCacheManager.shared

    func configure(with pokemon: Pokemon) async {
        if let cached = cache.load(for: pokemon.url) {
            self.pokemon = cached
        } else {
            self.pokemon = pokemon
        }
        await loadIfNeeded()
    }

    private func loadIfNeeded() async {
        guard let current = pokemon else { return }
        let alreadyHydrated = (current.description != nil) && (current.hp != nil)
        guard !alreadyHydrated, !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let updated = try await api.fetchFullDetails(for: current)
            self.pokemon = updated
            cache.save(updated)
        } catch {
            
        }
    }
}
