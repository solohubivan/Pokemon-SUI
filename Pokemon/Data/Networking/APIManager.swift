//
//  ApiDataManager.swift
//  Pokemon
//
//  Created by Ivan Solohub on 05.08.2025.
//

import Foundation

actor APIManager {

    private var nextPageURL: String? = "https://pokeapi.co/api/v2/pokemon"
    private var isLoadingPage = false

    // MARK: - Methods for External Use
    func fetchPokemonsPageForGrid() async throws -> [Pokemon] {
        guard !isLoadingPage, let url = nextPageURL else { return [] }
        isLoadingPage = true
        defer { isLoadingPage = false }

        let page: PokemonResponse = try await fetchData(urlString: url)
        nextPageURL = page.next

        let enriched = try await fetchCellDataForPokemons(for: page.results)
        return enriched
    }
    
    func fetchFullDetails(for pokemon: Pokemon) async throws -> Pokemon {
        let details: PokemonDetailInfoResponse = try await fetchData(urlString: pokemon.url)
        var item = updatePokemonInfo(pokemon, with: details)
        
        let species = try await fetchSpecies(for: pokemon)
        item.description = species.description

        if let evolution = try? await fetchEvolutionInfo(from: species.evolutionChainURL) {
            item.nextEvolutions = evolution.nextEvolutions
            item.evolutionTrigger = evolution.evolutionTrigger
            item.minLevel = evolution.minLevel
            item.evolutionLocation = evolution.evolutionLocation
        }

        return item
    }

    // MARK: - Private local helpers
    private func fetchCellDataForPokemons(for pokemons: [Pokemon]) async throws -> [Pokemon] {
        guard !pokemons.isEmpty else { return [] }

        return try await withThrowingTaskGroup(of: (Int, Pokemon).self) { group in
            for (index, pokemon) in pokemons.enumerated() {
                group.addTask {
                    let details: PokemonDetailInfoResponse = try await self.fetchData(urlString: pokemon.url)
                    
                    var updatedPokemon = pokemon
                    updatedPokemon.abilities = details.abilities.map { $0.ability.name }
                    updatedPokemon.imageURL = details.sprites.frontDefault
                    
                    return (index, updatedPokemon)
                }
            }

            var results: [(Int, Pokemon)] = []
            
            for try await pair in group {
                results.append(pair)
            }

            return results.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
    
    private func fetchSpecies(for pokemon: Pokemon) async throws -> (description: String, evolutionChainURL: String) {
        let speciesURL = pokemon.url.replacingOccurrences(of: "/pokemon/", with: "/pokemon-species/")
        let speciesResponse: PokemonSpeciesResponse = try await fetchData(urlString: speciesURL)

        let descriptionText = speciesResponse.flavorTextEntries
            .first { $0.language.name == "en" }?
            .flavorText
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{000C}", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        return (descriptionText, speciesResponse.evolutionChain.url)
    }
    
    private func fetchEvolutionInfo(from url: String) async throws -> EvolutionInfo {
        let chain: PokemonEvolutionChainResponse = try await fetchData(urlString: url)
        let next = flattenEvolutions(chain.chain)
        let details = chain.chain.evolvesTo.first?.evolutionDetails.first
        let trigger = details?.trigger.name ?? ""
        let minLvl = details?.minLevel
        let location = details?.location?.name
        return EvolutionInfo(nextEvolutions: next,
                             evolutionTrigger: trigger,
                             minLevel: minLvl,
                             evolutionLocation: location)
    }
    
    private func updatePokemonInfo(_ pokemon: Pokemon, with detailsResponse: PokemonDetailInfoResponse) -> Pokemon {
        var updatedPokemon = pokemon
        updatedPokemon.abilities = detailsResponse.abilities.map { $0.ability.name }
        updatedPokemon.imageURL = detailsResponse.sprites.frontDefault
        updatedPokemon.height = detailsResponse.height
        updatedPokemon.weight = detailsResponse.weight
        updatedPokemon.moves = detailsResponse.moves.map { $0.move.name }

        let stats = Dictionary(uniqueKeysWithValues: detailsResponse.stats.map { ($0.stat.name, $0.baseStat) })
        updatedPokemon.attack = stats["attack"] ?? 0
        updatedPokemon.damage = stats["attack"] ?? 0
        updatedPokemon.hp = stats["hp"] ?? 0
        updatedPokemon.defense = stats["defense"] ?? 0
        updatedPokemon.specialAttack = stats["special-attack"] ?? 0
        updatedPokemon.specialDefense = stats["special-defense"] ?? 0
        updatedPokemon.speed = stats["speed"] ?? 0
        
        return updatedPokemon
    }

    private func flattenEvolutions(_ node: PokemonEvolutionChainResponse.EvolutionNode) -> [String] {
        node.evolvesTo.flatMap { child in
            [child.species.name] + flattenEvolutions(child)
        }
    }
    
    // MARK: - Low-level fetch
    private func fetchData<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw ApiError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
