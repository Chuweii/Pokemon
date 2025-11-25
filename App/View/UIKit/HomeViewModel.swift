//
//  HomeViewModel.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import Foundation
import Combine

class HomeViewModel {
    // MARK: - Publishers
    @Published var featuredPokemons: [Pokemon] = []
    @Published var types: [String] = []
    @Published var regions: [Region] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var shouldShowPokemonListView = false
    @Published var shouldShowPokemonDetailView = false
    
    // MARK: - Init
    let pokeAPIRepository: PokeAPIRepositoryProtocol
    let favoriteRepository: FavoriteStorageRepositoryProtocol

    init(
        pokeAPIRepository: PokeAPIRepositoryProtocol = PokeAPIRepository(),
        favoriteRepository: FavoriteStorageRepositoryProtocol = FavoriteStorageRepository.shared
    ) {
        self.pokeAPIRepository = pokeAPIRepository
        self.favoriteRepository = favoriteRepository
    }

    // MARK: - Fetch data
    func loadAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadFeaturedPokemons() }
            group.addTask { await self.loadTypes() }
            group.addTask { await self.loadRegions() }
        }
    }
    
    @MainActor
    private func loadFeaturedPokemons() async {
        do {
            let listResponse = try await pokeAPIRepository.getPokemonList(limit: 9, offset: 0)

            // Fetch details for each Pokemon
            var pokemons: [Pokemon] = []

            for item in listResponse.results {
                guard let id = item.id else { continue }

                do {
                    let detail = try await pokeAPIRepository.getPokemonDetail(id: id)
                    // Check if this Pokemon is favorited
                    let isFavorited = favoriteRepository.isFavorited(pokemonId: id)
                    let pokemon = Pokemon(from: detail, isFavorited: isFavorited)
                    pokemons.append(pokemon)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }

            featuredPokemons = pokemons
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func loadTypes() async {
        do {
            let typeResponse = try await pokeAPIRepository.getTypeList(limit: 100, offset: 0)
            let typeNames = typeResponse.results.map { $0.name }

            types = typeNames
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func loadRegions() async {
        do {
            let regionListResponse = try await pokeAPIRepository.getRegionList()
            let firstSixRegions = Array(regionListResponse.results.prefix(6))

            // Fetch details for each region
            var regions: [Region] = []

            for item in firstSixRegions {
                guard let id = item.id else { continue }

                do {
                    let detail = try await pokeAPIRepository.getRegionDetail(id: id)
                    let region = Region(from: detail)
                    regions.append(region)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }

            self.regions = regions
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Actions
    func didClickFeaturedSeeMoreButton() {
        shouldShowPokemonListView = true
    }
    
    
    func didClickTypesSeeMoreButton() {
        print("Types see more tapped")
    }
    
    func didClickRegionsSeeMoreButton() {
        print("Regions see more tapped")
    }
    
    func didClickPokemonItems() {
        shouldShowPokemonDetailView = true
    }
    
    func didClickFavoriteButton(for pokemonId: Int) {
        toggleFavorite(for: pokemonId)
    }
    
    // MARK: - Favorite Management
    private func toggleFavorite(for pokemonId: Int) {
        guard let index = featuredPokemons.firstIndex(where: { $0.id == pokemonId }) else { return }

        // Toggle in FavoriteStorageRepository and get new state
        let newState = favoriteRepository.toggleFavorite(pokemonId: pokemonId)

        // Update local data
        featuredPokemons[index].isFavorited = newState

        print("Toggled favorite for Pokemon #\(pokemonId): \(newState)")
    }

    private func isFavorited(pokemonId: Int) -> Bool {
        return favoriteRepository.isFavorited(pokemonId: pokemonId)
    }
}
