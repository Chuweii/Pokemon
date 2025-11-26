//
//  PokemonListCoordinator.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/26.
//

import SwiftUI
import Combine

// MARK: - Protocol
protocol PokemonListCoordinating: AnyObject {
    func showPokemonDetail(pokemon: Pokemon)
    func dismiss()
}

// MARK: - Coordinator Implementation
class PokemonListCoordinator: ObservableObject, PokemonListCoordinating {
    @Published var selectedPokemon: Pokemon?

    func showPokemonDetail(pokemon: Pokemon) {
        selectedPokemon = pokemon
    }

    func dismiss() {
        selectedPokemon = nil
    }
}
