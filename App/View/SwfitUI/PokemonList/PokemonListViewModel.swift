//
//  PokemonListViewModel.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/26.
//

import Foundation
import Combine

class PokemonListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String? = nil
    @Published var hasMoreData: Bool = true

    // MARK: - Private Properties
    private var currentOffset: Int = 0
    private let pageSize: Int = 20

    // MARK: - Dependencies
    let pokeAPIRepository: PokeAPIRepositoryProtocol
    let favoriteRepository: FavoriteStorageRepositoryProtocol
    let coordinator: PokemonListCoordinating

    // MARK: - Init
    init(
        pokeAPIRepository: PokeAPIRepositoryProtocol = PokeAPIRepository(),
        favoriteRepository: FavoriteStorageRepositoryProtocol = FavoriteStorageRepository.shared,
        coordinator: PokemonListCoordinating = PokemonListCoordinator()
    ) {
        self.pokeAPIRepository = pokeAPIRepository
        self.favoriteRepository = favoriteRepository
        self.coordinator = coordinator
    }

    // MARK: - Data Loading
    func loadInitialData() async {
        guard !isLoading else { return }

        isLoading = true
        currentOffset = 0
        pokemons = []
        hasMoreData = true

        await loadPokemons()
        isLoading = false
    }

    private func loadMoreData() async {
        guard !isLoadingMore && hasMoreData else { return }

        isLoadingMore = true
        await loadPokemons()
        isLoadingMore = false
    }

    private func loadPokemons() async {
        do {
            let listResponse = try await pokeAPIRepository.getPokemonList(
                limit: pageSize,
                offset: currentOffset
            )

            // Fetch details for each Pokemon
            var newPokemons: [Pokemon] = []

            for item in listResponse.results {
                guard let id = item.id else { continue }

                do {
                    let detail = try await pokeAPIRepository.getPokemonDetail(id: id)
                    let isFavorited = favoriteRepository.isFavorited(pokemonID: id)
                    let pokemon = Pokemon(from: detail, isFavorited: isFavorited)
                    newPokemons.append(pokemon)
                } catch {
                    print("Failed to load pokemon \(id): \(error)")
                }
            }

            // Update data
            pokemons.append(contentsOf: newPokemons)
            currentOffset += pageSize

            // Check if there's more data
            if listResponse.next == nil || newPokemons.isEmpty {
                hasMoreData = false
            }

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Actions
    func didClickFavoriteButton(for pokemonId: Int) {
        guard let index = pokemons.firstIndex(where: { $0.id == pokemonId }) else { return }

        // Toggle in FavoriteStorageRepository and get new state
        let newState = favoriteRepository.toggleFavorite(pokemonID: pokemonId)

        // Update local data
        pokemons[index].isFavorited = newState
    }
    
    func onReachedBottom(currentItem: Pokemon) async {
        // Check if need to load more data
        guard let lastPokemon = pokemons.last else { return }
        guard currentItem.id == lastPokemon.id else { return }
        guard !isLoadingMore && hasMoreData else { return }
        await loadMoreData()
    }

    func refreshFavoriteStatus() {
        for index in pokemons.indices {
            let pokemonID = pokemons[index].id
            let isFavorited = favoriteRepository.isFavorited(pokemonID: pokemonID)
            pokemons[index].isFavorited = isFavorited
        }
    }

    // MARK: - Navigation Actions
    func didSelectPokemon(_ pokemon: Pokemon) {
        coordinator.showPokemonDetail(pokemon: pokemon)
    }

    func didTapBack() {
        coordinator.dismiss()
    }
}
