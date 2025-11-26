//
//  PokemonDetailView.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject var viewModel: PokemonDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }

    var body: some View {
        ZStack {
            backGroundGradient

            ScrollView {
                VStack(spacing: 0) {
                    // Top section with image
                    VStack(spacing: 16) {
                        pokemonIDText

                        pokemonImage
                    }

                    pokemonInfoView
                }
            }
            .ignoresSafeArea(edges: .bottom)

            navigationButtons
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.refreshFavoriteStatus()
        }
    }
}

// MARK: - Subviews
extension PokemonDetailView {
    var backGroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: gradientColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    var pokemonIDText: some View {
        Text(viewModel.formattedID)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.white)
            .padding(.top, 20)
    }
    
    var pokemonImage: some View {
        AsyncImage(url: URL(string: viewModel.pokemon.imageUrl ?? "")) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 200, height: 200)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.white.opacity(0.5))
            default:
                EmptyView()
            }
        }
        .padding(.bottom, 20)
    }
    
    var pokemonInfoView: some View {
        // Content section
        VStack(spacing: 20) {
            // Pokemon Name
            Text(viewModel.capitalizedName)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 24)

            // Type badges
            HStack(spacing: 12) {
                ForEach(viewModel.pokemon.types, id: \.name) { type in
                    TypeBadge(typeName: type.name)
                }
            }

            // Weight and Height
            HStack(spacing: 60) {
                VStack(spacing: 8) {
                    Text(viewModel.formattedWeight)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("Weight")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }

                VStack(spacing: 8) {
                    Text(viewModel.formattedHeight)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("Height")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.vertical, 8)

            // Base Stats Section
            VStack(alignment: .leading, spacing: 16) {
                Text("Base Stats")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 8)

                ForEach(viewModel.statsList, id: \.name) { stat in
                    StatBar(
                        name: stat.name,
                        value: stat.value,
                        maxValue: stat.maxValue
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 20)
    }
    
    var navigationButtons: some View {
        VStack {
            HStack {
                // Back button
                Button(action: {
                    dismiss()
                }) {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }

                Spacer()

                // Favorite button
                Button(action: {
                    viewModel.didClickFavoriteButton()
                }) {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.clear)
                                .overlay(
                                    Image(viewModel.pokemon.isFavorited ? "favorite_icon" : "unfavorite_icon")
                                        .resizable()
                                        .scaledToFit()
                                )
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()
        }
    }
}

// MARK: - Methods
extension PokemonDetailView {
    // Helper to determine gradient colors based on pokemon types
    private var gradientColors: [Color] {
        let types = viewModel.pokemon.types

        // If no types, return default gray gradient
        guard !types.isEmpty else {
            return [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]
        }

        // Get colors for each type
        var colors: [Color] = []
        for type in types {
            colors.append(getTypeColor(for: type.name))
        }

        // If only one type, create gradient with lighter version of same color
        if colors.count == 1 {
            let baseColor = colors[0]
            return [baseColor, baseColor.opacity(0.7)]
        }

        // If multiple types, use all type colors
        return colors
    }

    // Helper to get color for a specific type
    private func getTypeColor(for typeName: String) -> Color {
        switch typeName.lowercased() {
        case "grass":
            return Color(red: 0.48, green: 0.78, blue: 0.45)
        case "poison":
            return Color(red: 0.64, green: 0.44, blue: 0.68)
        case "fire":
            return Color(red: 0.94, green: 0.52, blue: 0.31)
        case "water":
            return Color(red: 0.39, green: 0.56, blue: 0.93)
        case "electric":
            return Color(red: 0.97, green: 0.81, blue: 0.33)
        case "normal":
            return Color(red: 0.66, green: 0.66, blue: 0.47)
        case "bug":
            return Color(red: 0.65, green: 0.76, blue: 0.15)
        case "flying":
            return Color(red: 0.66, green: 0.73, blue: 0.92)
        case "fighting":
            return Color(red: 0.75, green: 0.19, blue: 0.15)
        case "psychic":
            return Color(red: 0.98, green: 0.33, blue: 0.45)
        case "rock":
            return Color(red: 0.71, green: 0.63, blue: 0.42)
        case "ground":
            return Color(red: 0.87, green: 0.75, blue: 0.38)
        case "ice":
            return Color(red: 0.60, green: 0.85, blue: 0.85)
        case "dragon":
            return Color(red: 0.44, green: 0.22, blue: 0.98)
        case "dark":
            return Color(red: 0.44, green: 0.35, blue: 0.30)
        case "fairy":
            return Color(red: 0.93, green: 0.51, blue: 0.93)
        case "steel":
            return Color(red: 0.72, green: 0.72, blue: 0.82)
        case "ghost":
            return Color(red: 0.44, green: 0.35, blue: 0.60)
        default:
            return Color.gray
        }
    }
}

// MARK: - Type Badge Component
struct TypeBadge: View {
    let typeName: String

    var body: some View {
        Text(typeName.capitalized)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(typeColor)
            .cornerRadius(20)
    }

    private var typeColor: Color {
        switch typeName.lowercased() {
        case "grass":
            return Color(red: 0.48, green: 0.78, blue: 0.45)
        case "poison":
            return Color(red: 0.64, green: 0.44, blue: 0.68)
        case "fire":
            return Color(red: 0.94, green: 0.52, blue: 0.31)
        case "water":
            return Color(red: 0.39, green: 0.56, blue: 0.93)
        case "electric":
            return Color(red: 0.97, green: 0.81, blue: 0.33)
        case "normal":
            return Color(red: 0.66, green: 0.66, blue: 0.47)
        case "bug":
            return Color(red: 0.65, green: 0.76, blue: 0.15)
        case "flying":
            return Color(red: 0.66, green: 0.73, blue: 0.92)
        case "fighting":
            return Color(red: 0.75, green: 0.19, blue: 0.15)
        case "psychic":
            return Color(red: 0.98, green: 0.33, blue: 0.45)
        case "rock":
            return Color(red: 0.71, green: 0.63, blue: 0.42)
        case "ground":
            return Color(red: 0.87, green: 0.75, blue: 0.38)
        case "ice":
            return Color(red: 0.60, green: 0.85, blue: 0.85)
        case "dragon":
            return Color(red: 0.44, green: 0.22, blue: 0.98)
        case "dark":
            return Color(red: 0.44, green: 0.35, blue: 0.30)
        case "fairy":
            return Color(red: 0.93, green: 0.51, blue: 0.93)
        case "steel":
            return Color(red: 0.72, green: 0.72, blue: 0.82)
        case "ghost":
            return Color(red: 0.44, green: 0.35, blue: 0.60)
        default:
            return Color.gray
        }
    }
}

// MARK: - Stat Bar Component
struct StatBar: View {
    let name: String
    let value: Int
    let maxValue: Int

    var body: some View {
        HStack(spacing: 16) {
            // Stat name
            Text(name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 60, alignment: .leading)

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 8)

                    // Filled bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(statColor)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)

            // Value text
            Text("\(value)/\(maxValue)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 70, alignment: .trailing)
        }
    }

    private var progress: CGFloat {
        return CGFloat(value) / CGFloat(maxValue)
    }

    private var statColor: Color {
        switch name {
        case "HP":
            return Color(red: 1.0, green: 0.38, blue: 0.38)
        case "ATK":
            return Color(red: 1.0, green: 0.65, blue: 0.31)
        case "DEF":
            return Color(red: 0.25, green: 0.59, blue: 1.0)
        case "SPD":
            return Color(red: 0.37, green: 0.84, blue: 0.91)
        default:
            return Color.blue
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    PokemonDetailView(
        pokemon: Pokemon(
            id: 3,
            name: "venusaur",
            types: [PokemonType(name: "grass"), PokemonType(name: "poison")],
            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png",
            isFavorited: false
        )
    )
}
