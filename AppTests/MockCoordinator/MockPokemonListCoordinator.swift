//
//  MockPokemonListCoordinator.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/26.
//

import Testing
@testable import PenpeerInterview

class MockPokemonListCoordinator: PokemonListCoordinating {
    var didCallShowPokemonDetail = false
    var didCallDismiss = false
    var selectedPokemon: Pokemon?

    func showPokemonDetail(pokemon: Pokemon) {
        didCallShowPokemonDetail = true
        selectedPokemon = pokemon
    }

    func dismiss() {
        didCallDismiss = true
    }
}
