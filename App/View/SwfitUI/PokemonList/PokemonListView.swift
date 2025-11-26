//
//  PokemonListView.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/26.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Background color
            Color(UIColor.appBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Navigation Bar
                navigationBar

                if viewModel.isLoading && viewModel.pokemons.isEmpty {
                    loadingView
                } else {
                    pokemonList
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            // Only load initial data if no data exists
            if viewModel.pokemons.isEmpty {
                await viewModel.loadInitialData()
            }
        }
        .onAppear {
            viewModel.refreshFavoriteStatus()
        }
    }
}

// MARK: - Subviews
extension PokemonListView {
    var navigationBar: some View {
        HStack {
            // Back button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            // Title
            Text("All Pokémon")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)

            Spacer()

            // Placeholder for symmetry
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(Color(UIColor.appBackground))
    }

    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Spacer()
        }
    }

    var pokemonList: some View {
        List {
            ForEach(viewModel.pokemons, id: \.id) { pokemon in
                PokemonListRow(
                    pokemon: pokemon,
                    onFavoriteToggle: {
                        viewModel.didClickFavoriteButton(for: pokemon.id)
                    }
                )
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.didClickPokemonListRow(pokemon)
                }
                .onAppear {
                    Task {
                        await viewModel.onReachedBottom(currentItem: pokemon)
                    }
                }
            }

            // Loading more indicator
            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(
            NavigationLink(
                destination: viewModel.selectedPokemon.map { PokemonDetailView(pokemon: $0) },
                isActive: Binding(
                    get: { viewModel.selectedPokemon != nil },
                    set: { if !$0 { viewModel.selectedPokemon = nil } }
                )
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
}

// MARK: - Pokemon List Row Component
struct PokemonListRow: View {
    let pokemon: Pokemon
    let onFavoriteToggle: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            // Pokemon Image
            AsyncImage(url: URL(string: pokemon.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .background(Color.white)
            .cornerRadius(12)

            // Pokemon Info
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pokemon.capitalizedName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Text(pokemon.formattedNumber)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }

                HStack(spacing: 8) {
                    ForEach(pokemon.types, id: \.name) { type in
                        TypeBadge(typeName: type.name)
                    }
                }
            }
            .layoutPriority(1)

            Spacer()

            Button(action: {
                onFavoriteToggle()
            }) {
                Image(pokemon.isFavorited ? "favorite_icon" : "unfavorite_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(7)
        .frame(height: 120)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    NavigationView {
        PokemonListView()
    }
}
