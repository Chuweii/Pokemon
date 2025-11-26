//
//  PokemonListViewModelTests.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/26.
//

import Testing
import Moya
@testable import PenpeerInterview

@MainActor
struct PokemonListViewModelTests {
    @Test func loadInitialDataSuccess() async throws {
        // Given
        let fakePokeAPIRepository = FakePokeAPIRepository()
        let fakeFavoriteRepository = FakeFavoriteStorageRepository(initialFavorites: [1])

        // Mock successful response
        let mockListResponse = PokemonListResponse(
            count: 3,
            next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            previous: nil,
            results: [
                PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                PokemonListItem(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
                PokemonListItem(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/")
            ]
        )

        let mockDetailResponse = createMockPokemonDetail(id: 1, name: "bulbasaur", types: ["grass", "poison"])
        let _ = createMockPokemonDetail(id: 2, name: "ivysaur", types: ["grass", "poison"])
        let _ = createMockPokemonDetail(id: 3, name: "venusaur", types: ["grass", "poison"])

        fakePokeAPIRepository.getPokemonListResult = .success(mockListResponse)
        fakePokeAPIRepository.getPokemonDetailResult = .success(mockDetailResponse)

        let viewModel = PokemonListViewModel(
            pokeAPIRepository: fakePokeAPIRepository,
            favoriteRepository: fakeFavoriteRepository
        )

        // When
        await viewModel.loadInitialData()

        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.pokemons.count == 3)
        #expect(viewModel.pokemons[0].name == "bulbasaur")
        #expect(viewModel.pokemons[0].isFavorited == true) // Pokemon 1 is favorited
        #expect(viewModel.hasMoreData == true) // next is not nil
        #expect(viewModel.errorMessage == nil)
        #expect(fakePokeAPIRepository.didCallGetPokemonList == true)
        #expect(fakePokeAPIRepository.didCallGetPokemonDetail == true)
    }

    @Test func loadInitialDataFailure() async throws {
        // Given
        let fakePokeAPIRepository = FakePokeAPIRepository()
        let fakeFavoriteRepository = FakeFavoriteStorageRepository()

        let viewModel = PokemonListViewModel(
            pokeAPIRepository: fakePokeAPIRepository,
            favoriteRepository: fakeFavoriteRepository
        )

        // When
        await viewModel.loadInitialData()

        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.pokemons.count == 0)
        #expect(viewModel.errorMessage != nil)
        #expect(fakePokeAPIRepository.didCallGetPokemonList == true)
    }
    
    @Test("When user clicked pokemon row, then it should navigate to PokemonDetailView")
    func clickPokemonListRow() async throws {
        // Given
        let fakePokeAPIRepository = FakePokeAPIRepository()
        let fakeFavoriteRepository = FakeFavoriteStorageRepository(initialFavorites: [1])

        // Mock successful response
        let mockListResponse = PokemonListResponse(
            count: 1,
            next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            previous: nil,
            results: [
                PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
            ]
        )

        let mockDetailResponse = createMockPokemonDetail(id: 1, name: "bulbasaur", types: ["grass", "poison"])

        fakePokeAPIRepository.getPokemonListResult = .success(mockListResponse)
        fakePokeAPIRepository.getPokemonDetailResult = .success(mockDetailResponse)

        let viewModel = PokemonListViewModel(
            pokeAPIRepository: fakePokeAPIRepository,
            favoriteRepository: fakeFavoriteRepository
        )

        // When
        await viewModel.loadInitialData()
        await viewModel.didClickPokemonListRow(makeMockPokemon())
        
        // Then
        #expect(viewModel.selectedPokemon != nil)
    }
    
    @Test("When user scroll to bottom, then it should load more")
    func onReachedBottom() async throws {
        // Given
        let fakePokeAPIRepository = FakePokeAPIRepository()
        let fakeFavoriteRepository = FakeFavoriteStorageRepository(initialFavorites: [])

        let page1 = PokemonListResponse(
            count: 2,
            next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            previous: nil,
            results: [
                PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
            ]
        )
        let page2 = PokemonListResponse(
            count: 2,
            next: nil,
            previous: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20",
            results: [
                PokemonListItem(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")
            ]
        )

        let detail1 = createMockPokemonDetail(id: 1, name: "bulbasaur", types: ["grass"])
        let detail2 = createMockPokemonDetail(id: 2, name: "ivysaur", types: ["grass", "poison"])

        fakePokeAPIRepository.getPokemonListResult = .success(page1)
        fakePokeAPIRepository.getPokemonDetailResult = .success(detail1)

        let viewModel = PokemonListViewModel(
            pokeAPIRepository: fakePokeAPIRepository,
            favoriteRepository: fakeFavoriteRepository
        )

        // When - Load initial data when entry PokemonList page
        await viewModel.loadInitialData()

        // Then - Verify initial data
        #expect(viewModel.isLoading == false)
        #expect(viewModel.pokemons.count == 1)
        #expect(viewModel.pokemons.first?.name == "bulbasaur")
        #expect(viewModel.hasMoreData == true)
        #expect(fakePokeAPIRepository.didCallGetPokemonList == true)

        fakePokeAPIRepository.getPokemonListResult = .success(page2)
        fakePokeAPIRepository.getPokemonDetailResult = .success(detail2)

        // When - Scroll to bottom
        let lastItem = try #require(viewModel.pokemons.last)
        await viewModel.onReachedBottom(currentItem: lastItem)

        // Then - Should load more data
        #expect(viewModel.isLoadingMore == false)
        #expect(viewModel.pokemons.count == 2)
        #expect(viewModel.pokemons.last?.name == "ivysaur")
        #expect(viewModel.hasMoreData == false)
        #expect(fakePokeAPIRepository.didCallGetPokemonList == true)
        #expect(fakePokeAPIRepository.didCallGetPokemonDetail == true)
    }
}

// MARK: - Fake Data
extension PokemonListViewModelTests {
    private func createMockPokemonDetail(
        id: Int,
        name: String,
        types: [String]
    ) -> PokemonDetailResponse {
        let typeSlots = types.enumerated().map { index, typeName in
            PokemonTypeSlot(
                slot: index + 1,
                type: TypeInfo(
                    name: typeName,
                    url: "https://pokeapi.co/api/v2/type/\(index + 1)/"
                )
            )
        }

        let mockStats = [
            PokemonStat(
                baseStat: 45,
                effort: 0,
                stat: StatInfo(name: "hp", url: "https://pokeapi.co/api/v2/stat/1/")
            )
        ]

        let mockSprites = PokemonSprites(
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
        )

        let mockAbilities = [
            PokemonAbility(
                isHidden: false,
                slot: 1,
                ability: AbilityInfo(
                    name: "overgrow",
                    url: "https://pokeapi.co/api/v2/ability/65/"
                )
            )
        ]

        return PokemonDetailResponse(
            id: id,
            name: name,
            height: 7,
            weight: 69,
            baseExperience: 64,
            types: typeSlots,
            stats: mockStats,
            sprites: mockSprites,
            abilities: mockAbilities
        )
    }
    
    private func makeMockPokemon() async -> Pokemon {
        Pokemon(
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
}
