//
//  PokemonDetailViewModelTests.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/26.
//

import Testing
@testable import PenpeerInterview

struct PokemonDetailViewModelTests {
    @Test func onAppearRefreshStatusWhenNotFavorited() async throws {
        // Given
        let pokemon = await makeMockPokemon()
        let repository = FakeFavoriteStorageRepository(initialFavorites: [])
        let viewModel = await PokemonDetailViewModel(
            pokemon: pokemon,
            favoriteRepository: repository
        )
        
        // When
        await viewModel.refreshFavoriteStatus()
        
        // Then
        await #expect(viewModel.pokemon.isFavorited == false)
        #expect(repository.didCallIsFavorited == true)
    }
    
    @Test func onAppearRefreshStatusWhenIsFavorited() async throws {
        // Given
        let pokemon = await makeMockPokemon()
        let repository = FakeFavoriteStorageRepository(initialFavorites: [1])
        let viewModel = await PokemonDetailViewModel(
            pokemon: pokemon,
            favoriteRepository: repository
        )

        // When
        await viewModel.refreshFavoriteStatus()

        // Then
        await #expect(viewModel.pokemon.isFavorited == true)
        #expect(repository.didCallIsFavorited == true)
    }

    @Test func clickFavoriteButtonAddToFavorite() async throws {
        // Given
        let pokemon = await makeMockPokemon()
        let repository = FakeFavoriteStorageRepository(initialFavorites: [])
        let viewModel = await PokemonDetailViewModel(
            pokemon: pokemon,
            favoriteRepository: repository
        )

        // Then - Verify initial state is not favorited
        await #expect(viewModel.pokemon.isFavorited == false)
        #expect(repository.isFavorited(pokemonId: 1) == false)

        // When - Click favorite button
        await viewModel.didClickFavoriteButton()

        // Then - Should add to favorites
        #expect(repository.isFavorited(pokemonId: 1) == true)
        await #expect(viewModel.pokemon.isFavorited == true)
        #expect(repository.didCallToggleFavorite == true)
    }

    @Test func clickFavoriteButtonRemoveFromFavorite() async throws {
        // Given
        let pokemon = await makeMockPokemon()
        let repository = FakeFavoriteStorageRepository(initialFavorites: [1])
        let viewModel = await PokemonDetailViewModel(
            pokemon: pokemon,
            favoriteRepository: repository
        )

        // Refresh to sync initial state
        await viewModel.refreshFavoriteStatus()

        // Then - Verify initial state is favorited
        await #expect(viewModel.pokemon.isFavorited == true)
        #expect(repository.isFavorited(pokemonId: 1) == true)

        // When - Click favorite button
        await viewModel.didClickFavoriteButton()

        // Then - Should remove from favorites
        #expect(repository.isFavorited(pokemonId: 1) == false)
        await #expect(viewModel.pokemon.isFavorited == false)
        #expect(repository.didCallToggleFavorite == true)
    }
}


// MARK: - Mock Data
extension PokemonDetailViewModelTests {
    private func makeMockPokemon() async -> Pokemon {
        await Pokemon(
            id: 1,
            name: "bulbasaur",
            types: [PokemonType(name: "grass"), PokemonType(name: "poison")],
            imageUrl: "https://example.com/bulbasaur.png",
            height: 7,
            weight: 69,
            stats: [
                PokemonStat(
                    baseStat: 45,
                    effort: 0,
                    stat: StatInfo(name: "hp", url: "")
                )
            ],
            isFavorited: false
        )
    }

    private func makeViewModel(
        pokemon: Pokemon,
        initialFavorites: Set<Int>
    ) async -> PokemonDetailViewModel {

        let repo = FakeFavoriteStorageRepository(initialFavorites: initialFavorites)
        let vm = await PokemonDetailViewModel(
            pokemon: pokemon,
            favoriteRepository: repo
        )
        return vm
    }
}
