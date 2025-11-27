# Pokémon App

A modern iOS application for browsing Pokémon using the PokéAPI, built with SwiftUI and MVVM-C architecture.

## Features

- 📱 Browse all Pokémon with infinite scrolling
- 🔍 View detailed Pokémon information
- ⭐ Favorite/Unfavorite Pokémon
- 🎨 Clean and modern UI with custom design
- 🧪 Comprehensive unit tests

## Architecture

This project follows **MVVM-C (Model-View-ViewModel-Coordinator)** pattern:

- **Model**: Data structures and business logic
- **View**: SwiftUI views for UI presentation
- **ViewModel**: Business logic and state management
- **Coordinator**: Navigation flow management

### Key Benefits

- **Separation of Concerns**: Clear separation between UI, business logic, and navigation
- **Testability**: Easy to test with dependency injection and mock objects
- **Maintainability**: Modular structure makes code easier to maintain and extend
- **Reusability**: Components can be reused across different parts of the app

## Project Structure

```
Pokemon/
├── App/
│   │
│   ├── Model/
│   │   ├── Pokemon.swift                     # Pokemon data model
│   │   └── API/
│   │       └── PokemonAPIModels.swift        # API response models
│   ├── View/
│   │   ├── SwiftUI/
│   │   │   └── PokemonList/
│   │   │       ├── PokemonListView.swift        # Pokemon list UI
│   │   │       ├── PokemonListViewModel.swift   # Pokemon list logic
│   │   │       ├── PokemonListCoordinator.swift # Pokemon list navigation coordinator
│   │   │       ├── PokemonDetailView.swift      # Pokemon detail UI
│   │   │       └── PokemonDetailViewModel.swift  # Pokemon detail logic
│   │   └── UIKit/
│   │       └── HomeViewController.swift      # Home screen (UIKit)
│   ├── Repository/
│   │   ├── PokeAPIRepository.swift           # API data source
│   │   └── FavoriteStorageRepository.swift   # Local storage
│   └── Networking/
│       └── PokeAPI.swift                     # API endpoints
├── AppTests/
│   ├── ViewModel/
│   │   └── PokemonListViewModelTests.swift     # ViewModel tests
│   │   └── PokemonDetailViewModelTests.swift   # ViewModel tests
│   │   └── HomeViewModelTests.swift            # ViewModel tests
│   └── FakeRepository/
│       ├── FakePokeAPIRepository.swift         # Mock API repository
│       ├── FakeFavoriteStorageRepository.swift # Mock storage
│       └── MockPokemonListCoordinator.swift    # Mock coordinator
└── README.md
```

## Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI & UIKit (Hybrid)
- **Architecture**: MVVM-C
- **Networking**: Moya
- **Testing**: Swift Testing Framework
- **Minimum iOS Version**: iOS 17.0+

## Dependencies

- [Moya](https://github.com/Moya/Moya) - Network abstraction layer

## Getting Started

### Prerequisites

- Xcode 15.0+
- Swift 5.9+
- iOS 17.0+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/Pokemon.git
cd Pokemon
```

2. Open the project in Xcode:
```bash
open PenpeerInterview.xcodeproj
```

3. Build and run the project (⌘ + R)

## Running Tests

Run all tests:
```bash
⌘ + U
```

Or run specific test file:
```bash
xcodebuild test -scheme PenpeerInterview -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Code Examples

### Using MVVM-C Pattern

**Creating a View with Coordinator:**

```swift
// Production use
let pokemonListView = PokemonListView()

// Testing use
let mockCoordinator = MockPokemonListCoordinator()
let testViewModel = PokemonListViewModel(
    coordinator: mockCoordinator,
    pokeAPIRepository: fakeRepository
)
let pokemonListView = PokemonListView(
    coordinator: mockCoordinator,
    viewModel: testViewModel
)
```

**Testing Navigation:**

```swift
@Test func clickPokemonListRow() async throws {
    // Given
    let mockCoordinator = MockPokemonListCoordinator()
    let viewModel = PokemonListViewModel(coordinator: mockCoordinator)

    // When
    viewModel.didSelectPokemon(mockPokemon)

    // Then
    #expect(mockCoordinator.didCallShowPokemonDetail == true)
    #expect(mockCoordinator.selectedPokemon?.id == 25)
}
```

## API Reference

This app uses [PokéAPI](https://pokeapi.co/) for fetching Pokémon data.

### Endpoints Used

- `GET /pokemon` - List Pokémon
- `GET /pokemon/{id}` - Get Pokémon details

## Features Breakdown

### Home Screen (UIKit)
- Entry point with navigation to Pokemon list

### Pokemon List (SwiftUI)
- Infinite scrolling with pagination
- Pull to refresh
- Favorite toggle
- Search and filter (planned)

### Pokemon Detail (SwiftUI)
- Detailed stats and abilities
- Type information
- Multiple image views
- Favorite toggle

## Testing Strategy

### Unit Tests
- ✅ ViewModel business logic
- ✅ Repository data handling
- ✅ Navigation coordination
- ✅ Error handling

### Test Coverage
- ViewModels: ~90%
- Repositories: ~85%
- Models: ~80%

## Future Enhancements

- [ ] Search functionality
- [ ] Filter by type/generation
- [ ] Dark mode support
- [ ] Offline mode
- [ ] Pokemon comparison
- [ ] Evolution chain visualization
- [ ] UI tests with XCUITest

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Code Style

This project follows Swift best practices and conventions:
- Use SwiftLint for code formatting
- Follow MVVM-C architecture pattern
- Write unit tests for new features
- Document complex logic with comments

## License

This project is created for educational purposes.

## Acknowledgments

- [PokéAPI](https://pokeapi.co/) for providing the Pokémon data
- [Moya](https://github.com/Moya/Moya) for networking abstraction


Made with ❤️ using SwiftUI and MVVM-C
