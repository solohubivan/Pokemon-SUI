//
//  ApiDataManager.swift
//  Pokemon
//
//  Created by Ivan Solohub on 05.08.2025.
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case emptyData
}

struct PokemonResponse: Decodable {
    let results: [Pokemon]
    let next: String?
}


struct Pokemon: Codable, Hashable {
    let name: String
    let url: String
    var imageURL: String?
    var abilities: [String]?
    var height: Int?
    var weight: Int?
    var attack: Int?
    var damage: Int?
    var description: String?
    
    var hp: Int?
    var defense: Int?
    var specialAttack: Int?
    var specialDefense: Int?
    var speed: Int?
    
    var nextEvolutions: [String]?
    var evolutionTrigger: String?
    var minLevel: Int?
    var evolutionLocation: String?
    
    var moves: [String]?
}

struct PokemonDetailInfoResponse: Codable {
    let abilities: [Ability]
    let sprites: Sprites
    let height: Int
    let weight: Int
    let stats: [Stat]
    let moves: [Move]
    
    struct Ability: Codable {
        let ability: NamedResource
    }
    
    struct NamedResource: Codable {
        let name: String
        let url: String
    }
    
    struct Sprites: Codable {
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    struct Stat: Codable {
        let baseStat: Int
        let effort: Int
        let stat: NamedResource

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case effort
            case stat
        }
    }
    
    struct Move: Codable {
        let move: NamedResource
    }
}




final class ApiDataManager {
    
    private var nextPageURL: String? = "https://pokeapi.co/api/v2/pokemon"
    private var isLoading: Bool = false
    
    
    func fetchDetailsForPokemons(
        pokemons: [Pokemon],
        completion: @escaping ([Pokemon]) -> Void
    ) {
        var updatedPokemons: [Pokemon?] = Array(repeating: nil, count: pokemons.count)
        let group = DispatchGroup()

        for (i, pokemon) in pokemons.enumerated() {
            group.enter()
            fetchData(urlString: pokemon.url) { (result: Result<PokemonDetailInfoResponse, Error>) in
                switch result {
                case .success(let details):
                    var updated = pokemon
                    updated.abilities = details.abilities.map { $0.ability.name }
                    updated.imageURL = details.sprites.frontDefault
                    updated.height = details.height
                    updated.weight = details.weight
                    updated.moves = details.moves.map { $0.move.name }
                        
                    let statsDict = Dictionary(uniqueKeysWithValues: details.stats.map { ($0.stat.name, $0.baseStat) })
                    updated.attack = statsDict["attack"] ?? 0
                    updated.damage = statsDict["attack"] ?? 0
                    updated.hp = statsDict["hp"] ?? 0
                    updated.defense = statsDict["defense"] ?? 0
                    updated.specialAttack = statsDict["special-attack"] ?? 0
                    updated.specialDefense = statsDict["special-defense"] ?? 0
                    updated.speed = statsDict["speed"] ?? 0
                    updatedPokemons[i] = updated
                case .failure:
                    updatedPokemons[i] = pokemon
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(updatedPokemons.compactMap { $0 })
        }
    }
    
    
    func fetchPokemons(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        guard !isLoading, let url = nextPageURL else {
            completion(.success([]))
            return
        }
        isLoading = true
        fetchData(urlString: url) { [weak self] (result: Result<PokemonResponse, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.nextPageURL = response.next
                    completion(.success(response.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: -  Private methods
    private func fetchData<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(ApiError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ApiError.emptyData))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
