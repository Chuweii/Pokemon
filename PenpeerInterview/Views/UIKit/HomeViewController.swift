//
//  HomeViewController.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel
    private let favoriteRepository: FavoriteRepositoryProtocol

    // MARK: - Properties
    private var featuredPokemons: [Pokemon] = []

    // MARK: - Initialization
    init(
        viewModel: HomeViewModel = HomeViewModel(),
        favoriteRepository: FavoriteRepositoryProtocol = FavoriteRepository()
    ) {
        self.viewModel = viewModel
        self.favoriteRepository = favoriteRepository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel()
        self.favoriteRepository = FavoriteRepository()
        super.init(coder: coder)
    }

    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private lazy var featuredSectionHeader: SectionHeaderView = {
        let header = SectionHeaderView(title: "Featured Pokémon", showSeeMore: true)
        header.onSeeMoreTapped = { [weak self] in
            self?.handleSeeMoreTapped()
        }
        return header
    }()

    private lazy var featuredCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFeaturedLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false // Disable bounce
        collectionView.alwaysBounceVertical = false // Disable vertical bounce
        collectionView.register(FeaturedPokemonCell.self, forCellWithReuseIdentifier: FeaturedPokemonCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFeaturedPokemons()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Pokédex"

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        scrollView.backgroundColor = .white

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0))
            make.width.equalTo(scrollView.snp.width)
        }

        // Add Featured Pokémon Section
        contentStackView.addArrangedSubview(featuredSectionHeader)
        contentStackView.addArrangedSubview(featuredCollectionView)

        featuredSectionHeader.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        featuredCollectionView.snp.makeConstraints { make in
            make.height.equalTo(360) // Height for 3 rows
            make.leading.trailing.equalToSuperview()
        }

        // TODO: Add Types Section
        // TODO: Add Regions Section
    }

    private func createFeaturedLayout() -> UICollectionViewLayout {
        // Item size - each row with white background
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group size - 3 items vertically (one page)
        // Use absolute width slightly less than container to show peek
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.width - 64), // Leave space for peek
            heightDimension: .absolute(360) // 120 * 3 (no spacing between items)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(0)

        // Add background to the group
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 12 // Space between pages
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    // MARK: - Data
    private func loadFeaturedPokemons() {
        print("Starting to load featured pokemons...")
        Task {
            do {
                featuredPokemons = try await viewModel.getFeaturedPokemons()
                print("Successfully loaded \(featuredPokemons.count) pokemons")
                await MainActor.run {
                    print("Reloading collection view on main thread")
                    featuredCollectionView.reloadData()
                }
            } catch {
                print("Failed to load featured pokemons: \(error)")
                if let networkError = error as? NetworkError {
                    print("Network error details: \(networkError)")
                }
                await MainActor.run {
                    // TODO: Show error message to user
                }
            }
        }
    }

    // MARK: - Actions
    private func handleSeeMoreTapped() {
        print("See more tapped - Navigate to list page")
        // TODO: Navigate to SwiftUI list page
    }

    private func toggleFavorite(for pokemonId: Int) {
        guard let index = featuredPokemons.firstIndex(where: { $0.id == pokemonId }) else { return }

        // Toggle in FavoriteRepository and get new state
        let newState = favoriteRepository.toggleFavorite(pokemonId: pokemonId)

        // Update local data
        featuredPokemons[index].isFavorited = newState

        print("Toggled favorite for Pokemon #\(pokemonId): \(newState)")

        // Reload the specific cell
        let indexPath = IndexPath(item: index, section: 0)
        featuredCollectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection called, returning: \(featuredPokemons.count)")
        return featuredPokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt called for index: \(indexPath.item)")
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeaturedPokemonCell.reuseIdentifier,
            for: indexPath
        ) as? FeaturedPokemonCell else {
            print("Failed to dequeue FeaturedPokemonCell")
            return UICollectionViewCell()
        }

        let pokemon = featuredPokemons[indexPath.item]
        print("Configuring cell with pokemon: \(pokemon.name)")

        // Determine position in group (3 items per group/page)
        let positionInGroup = indexPath.item % 3
        let isFirst = (positionInGroup == 0)
        let isLast = (positionInGroup == 2)

        cell.configure(with: pokemon, isFirst: isFirst, isLast: isLast, favoriteRepository: favoriteRepository)
        cell.onFavoriteToggle = { [weak self] pokemonId in
            self?.toggleFavorite(for: pokemonId)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = featuredPokemons[indexPath.item]
        print("Selected Pokemon: \(pokemon.name)")
        // TODO: Navigate to detail page
    }
}
