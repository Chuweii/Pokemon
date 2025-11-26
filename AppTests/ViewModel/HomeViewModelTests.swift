//
//  HomeViewModelTests.swift
//  PenpeerInterviewTests
//
//  Created by Wei Chu on 2025/11/24.
//

import Testing
@testable import PenpeerInterview

struct HomeViewModelTests {
    @Test func loadAllDataSuccess() async throws {
        // Given
        let pokeAPIRepository = FakePokeAPIRepository()
        let viewModel = await HomeViewModel(
            pokeAPIRepository: pokeAPIRepository
        )

        // When
        pokeAPIRepository.getPokemonListResult = .success(HomeViewModelTests.mockPokemonListResponse())
        pokeAPIRepository.getPokemonDetailResult = .success(HomeViewModelTests.mockPokemonDetailResponse())
        pokeAPIRepository.getTypeListResult = .success(HomeViewModelTests.mockTypeListResponse())
        pokeAPIRepository.getRegionListResult = .success(HomeViewModelTests.mockRegionListResponse())
        pokeAPIRepository.getRegionDetailResult = .success(HomeViewModelTests.mockRegionDetailResponse())
        await viewModel.loadAllData()

        // Then
        #expect(viewModel.featuredPokemons.count == 2)
        await #expect(viewModel.featuredPokemons.first?.name == "bulbasaur")
        await #expect(viewModel.featuredPokemons.first?.id == 1)

        #expect(viewModel.types.count == 3)
        #expect(viewModel.types.contains("normal"))
        #expect(viewModel.types.contains("fire"))
        #expect(viewModel.types.contains("water"))

        #expect(viewModel.regions.count == 1)
        await #expect(viewModel.regions.first?.name == "kanto")
        await #expect(viewModel.regions.first?.locationCount == 3)
    }

    @Test func loadAllDataFailure() async throws {
        // Given
        let pokeAPIRepository = FakePokeAPIRepository()
        let viewModel = await HomeViewModel(
            pokeAPIRepository: pokeAPIRepository
        )

        // When
        await viewModel.loadAllData()

        // Then
        #expect(viewModel.featuredPokemons.isEmpty)
        #expect(viewModel.types.isEmpty)
        #expect(viewModel.regions.isEmpty)
        #expect(viewModel.errorMessage != nil)
    }
    
    @Test func clickFeaturedPokemonSeeMoreButton() async throws {
        // Given
        let pokeAPIRepository = FakePokeAPIRepository()
        let viewModel = await HomeViewModel(
            pokeAPIRepository: pokeAPIRepository
        )

        // When
        await viewModel.didClickFeaturedSeeMoreButton()
        
        // Then
        #expect(viewModel.shouldShowPokemonListView == true)
    }
    
    @Test func clickPokemonItems() async throws {
        // Given
        let pokeAPIRepository = FakePokeAPIRepository()
        let viewModel = await HomeViewModel(
            pokeAPIRepository: pokeAPIRepository
        )

        let mockPokemon = await Pokemon(
            id: 1,
            name: "bulbasaur",
            types: [PokemonType(name: "grass")],
            imageUrl: "https://example.com/bulbasaur.png",
            isFavorited: false
        )

        // When
        await viewModel.didClickPokemonItems(mockPokemon)

        // Then
        #expect(viewModel.shouldShowPokemonDetailView == true)
        await #expect(viewModel.selectedPokemon?.id == 1)
        await #expect(viewModel.selectedPokemon?.name == "bulbasaur")
    }

    @Test func clickFavoriteButtonAddToFavorite() async throws {
        // Given
        let pokeAPIRepository = FakePokeAPIRepository()
        let favoriteRepository = FakeFavoriteStorageRepository(initialFavorites: [])
        let viewModel = await HomeViewModel(
            pokeAPIRepository: pokeAPIRepository,
            favoriteRepository: favoriteRepository
        )

        // When
        pokeAPIRepository.getPokemonListResult = .success(HomeViewModelTests.mockPokemonListResponse())
        pokeAPIRepository.getPokemonDetailResult = .success(HomeViewModelTests.mockPokemonDetailResponse())
        await viewModel.loadAllData()

        // Then - Verify that the initial state is not marked as favorited
        await #expect(viewModel.featuredPokemons.first?.isFavorited == false)
        #expect(favoriteRepository.isFavorited(pokemonId: 1) == false)

        // When
        await viewModel.didClickFavoriteButton(for: 1)

        // Then
        #expect(favoriteRepository.isFavorited(pokemonId: 1) == true)
        await #expect(viewModel.featuredPokemons.first?.isFavorited == true)
        #expect(favoriteRepository.didCallToggleFavorite == true)
    }

    @Test func clickFavoriteButtonRemoveFromFavorite() async throws {
        // Given
        let pokeAPIRepository = FakePokeAPIRepository()
        let favoriteRepository = FakeFavoriteStorageRepository(initialFavorites: [1])
        let viewModel = await HomeViewModel(
            pokeAPIRepository: pokeAPIRepository,
            favoriteRepository: favoriteRepository
        )

        // When
        pokeAPIRepository.getPokemonListResult = .success(HomeViewModelTests.mockPokemonListResponse())
        pokeAPIRepository.getPokemonDetailResult = .success(HomeViewModelTests.mockPokemonDetailResponse())
        await viewModel.loadAllData()

        // Then - Verify that the initial state is marked as favorited
        await #expect(viewModel.featuredPokemons.first?.isFavorited == true)
        #expect(favoriteRepository.isFavorited(pokemonId: 1) == true)

        // When
        await viewModel.didClickFavoriteButton(for: 1)

        // Then
        #expect(favoriteRepository.isFavorited(pokemonId: 1) == false)
        await #expect(viewModel.featuredPokemons.first?.isFavorited == false)
        #expect(favoriteRepository.didCallToggleFavorite == true)
    }
}

// MARK: - Mock Data
extension HomeViewModelTests {
    static func mockPokemonListResponse() -> PokemonListResponse {
        return PokemonListResponse(
            count: 2,
            next: nil,
            previous: nil,
            results: [
                PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                PokemonListItem(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")
            ]
        )
    }

    static func mockPokemonDetailResponse(id: Int = 1, name: String = "bulbasaur") -> PokemonDetailResponse {
        return PokemonDetailResponse(
            id: id,
            name: name,
            height: 7,
            weight: 69,
            baseExperience: 64,
            types: [
                PokemonTypeSlot(
                    slot: 1,
                    type: TypeInfo(name: "grass", url: "")
                )
            ],
            stats: [
                PokemonStat(
                    baseStat: 45,
                    effort: 0,
                    stat: StatInfo(name: "hp", url: "")
                )
            ],
            sprites: PokemonSprites(
                frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png",
                frontShiny: nil,
                backDefault: nil,
                backShiny: nil,
                other: OtherSprites(
                    officialArtwork: OfficialArtwork(
                        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png",
                        frontShiny: nil
                    )
                )
            ),
            abilities: [
                PokemonAbility(
                    isHidden: false,
                    slot: 1,
                    ability: AbilityInfo(name: "overgrow", url: "")
                )
            ]
        )
    }

    static func mockTypeListResponse() -> TypeListResponse {
        return TypeListResponse(
            count: 3,
            next: nil,
            previous: nil,
            results: [
                TypeListItem(name: "normal", url: ""),
                TypeListItem(name: "fire", url: ""),
                TypeListItem(name: "water", url: "")
            ]
        )
    }

    static func mockRegionListResponse() -> RegionListResponse {
        return RegionListResponse(
            count: 1,
            next: nil,
            previous: nil,
            results: [
                RegionListItem(name: "kanto", url: "https://pokeapi.co/api/v2/region/1/")
            ]
        )
    }

    static func mockRegionDetailResponse(id: Int = 1, name: String = "kanto") -> RegionDetailResponse {
        return RegionDetailResponse(
            id: id,
            name: name,
            locations: [
                LocationInfo(name: "pallet-town", url: ""),
                LocationInfo(name: "viridian-city", url: ""),
                LocationInfo(name: "pewter-city", url: "")
            ]
        )
    }
}
