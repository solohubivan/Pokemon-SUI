//
//  ApiDataManager.swift
//  Pokemon
//
//  Created by Ivan Solohub on 05.08.2025.
//

import Foundation

final class ApiDataManager {

    private var nextPageURL: String? = "https://pokeapi.co/api/v2/pokemon"
    private var isLoadingPage = false

    func fetchPokemonsPageForGrid(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        guard !isLoadingPage, let url = nextPageURL else {
            completion(.success([]))
            return
        }
        isLoadingPage = true

        fetchData(urlString: url) { [weak self] (result: Result<PokemonResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let page):
                self.nextPageURL = page.next
                self.fetchLightDetails(for: page.results) { enriched in
                    self.isLoadingPage = false
                    completion(.success(enriched))
                }
            case .failure(let err):
                self.isLoadingPage = false
                completion(.failure(err))
            }
        }
    }
    
    func fetchFullDetails(for pokemon: Pokemon, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        fetchData(urlString: pokemon.url) { (res: Result<PokemonDetailInfoResponse, Error>) in
            switch res {
            case .success(let details):
                var item = self.mergeBasicDetails(pokemon: pokemon, details: details)
                
                self.fetchSpecies(for: pokemon) { speciesRes in
                    switch speciesRes {
                    case .success(let sp):
                        item.description = sp.description
                        
                        self.fetchEvolutionInfo(from: sp.evolutionChainURL) { evoRes in
                            switch evoRes {
                            case .success(let evo):
                                item.nextEvolutions = evo.nextEvolutions
                                item.evolutionTrigger = evo.evolutionTrigger
                                item.minLevel = evo.minLevel
                                item.evolutionLocation = evo.evolutionLocation
                                completion(.success(item))
                            case .failure(let e):
                                completion(.success(item))
                                print("evolution error:", e)
                            }
                        }

                    case .failure(let e):
                        completion(.success(item))
                        print("species error:", e)
                    }
                }

            case .failure(let e):
                completion(.failure(e))
            }
        }
    }

    // MARK: - Private local helpers
    private func fetchLightDetails(for pokemons: [Pokemon], completion: @escaping ([Pokemon]) -> Void) {
        guard !pokemons.isEmpty else { completion([]); return }
        var updated: [Pokemon?] = Array(repeating: nil, count: pokemons.count)
        let group = DispatchGroup()

        for (i, p) in pokemons.enumerated() {
            group.enter()
            fetchData(urlString: p.url) { (res: Result<PokemonDetailInfoResponse, Error>) in
                switch res {
                case .success(let d):
                    var item = p
                    item.abilities = d.abilities.map { $0.ability.name }
                    item.imageURL  = d.sprites.frontDefault
                    updated[i] = item
                case .failure:
                    updated[i] = p
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(updated.compactMap { $0 })
        }
    }
    
    private func mergeBasicDetails(pokemon: Pokemon, details: PokemonDetailInfoResponse) -> Pokemon {
        var item = pokemon
        item.abilities = details.abilities.map { $0.ability.name }
        item.imageURL = details.sprites.frontDefault
        item.height = details.height
        item.weight = details.weight
        item.moves = details.moves.map { $0.move.name }

        let stats = Dictionary(uniqueKeysWithValues: details.stats.map { ($0.stat.name, $0.baseStat) })
        item.attack = stats["attack"] ?? 0
        item.damage = stats["attack"] ?? 0
        item.hp = stats["hp"] ?? 0
        item.defense = stats["defense"] ?? 0
        item.specialAttack = stats["special-attack"] ?? 0
        item.specialDefense = stats["special-defense"] ?? 0
        item.speed = stats["speed"] ?? 0
        return item
    }
    
    private func fetchSpecies(for pokemon: Pokemon,
                              completion: @escaping (Result<(description: String, evolutionChainURL: String), Error>) -> Void) {
        let speciesURL = pokemon.url.replacingOccurrences(of: "/pokemon/", with: "/pokemon-species/")
        fetchData(urlString: speciesURL) { (res: Result<PokemonSpeciesResponse, Error>) in
            switch res {
            case .success(let sp):
                let desc = sp.flavorTextEntries
                    .first { $0.language.name == "en" }?
                    .flavorText
                    .replacingOccurrences(of: "\n", with: " ")
                    .replacingOccurrences(of: "\u{000C}", with: " ")
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                completion(.success((desc, sp.evolutionChain.url)))
            case .failure(let e):
                completion(.failure(e))
            }
        }
    }
    
    private func fetchEvolutionInfo(from url: String,
                                    completion: @escaping (Result<EvolutionInfo, Error>) -> Void) {
        fetchData(urlString: url) { (res: Result<PokemonEvolutionChainResponse, Error>) in
            switch res {
            case .success(let chain):
                let next = self.flattenEvolutions(chain.chain)
                let details = chain.chain.evolvesTo.first?.evolutionDetails.first
                let trigger = details?.trigger.name ?? ""
                let minLvl = details?.minLevel
                let location = details?.location?.name
                completion(.success(EvolutionInfo(nextEvolutions: next,
                                                  evolutionTrigger: trigger,
                                                  minLevel: minLvl,
                                                  evolutionLocation: location)))
            case .failure(let e):
                completion(.failure(e))
            }
        }
    }

    private func flattenEvolutions(_ node: PokemonEvolutionChainResponse.EvolutionNode) -> [String] {
        node.evolvesTo.flatMap { child in
            [child.species.name] + flattenEvolutions(child)
        }
    }
    
    private func fetchData<T: Decodable>(urlString: String,
                                         completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else { completion(.failure(ApiError.invalidURL)); return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error { completion(.failure(error)); return }
            guard let data else { completion(.failure(ApiError.emptyData)); return }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}
