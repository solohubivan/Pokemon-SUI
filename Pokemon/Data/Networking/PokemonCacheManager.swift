//
//  PokemonCacheManager.swift
//  Pokemon
//
//  Created by Ivan Solohub on 10.08.2025.
//

import Foundation

final class PokemonCacheManager {
    
    static let shared = PokemonCacheManager()
    
    private let keyPrefix = "PokemonCache"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save(_ pokemon: Pokemon) {
        guard let data = try? encoder.encode(pokemon) else { return }
        UserDefaults.standard.set(data, forKey: cacheKey(for: pokemon.url))
    }
    
    func load(for url: String) -> Pokemon? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey(for: url)) else { return nil }
        return try? decoder.decode(Pokemon.self, from: data)
    }

    func clear(for url: String) {
        UserDefaults.standard.removeObject(forKey: cacheKey(for: url))
    }
    
    func clearAll() {
        let ud = UserDefaults.standard
        ud.dictionaryRepresentation().keys
            .filter { $0.hasPrefix(keyPrefix) }
            .forEach { ud.removeObject(forKey: $0) }
    }

    private func cacheKey(for url: String) -> String {
        keyPrefix + url
    }
}
