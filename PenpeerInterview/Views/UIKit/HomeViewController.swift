//
//  HomeViewController.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()

    // MARK: - Properties
    private var featuredPokemons: [Pokemon] = []

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
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FeaturedPokemonCell.self, forCellWithReuseIdentifier: FeaturedPokemonCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 16
        collectionView.clipsToBounds = true
        return collectionView
    }()

    private lazy var featuredContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.cornerRadius = 16
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await viewModel.getPokemon()
        }
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
        contentStackView.addArrangedSubview(featuredContainerView)

        featuredContainerView.addSubview(featuredCollectionView)

        featuredSectionHeader.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        featuredContainerView.snp.makeConstraints { make in
            make.height.equalTo(360) // Height for 3 rows
            make.leading.trailing.equalToSuperview().inset(16)
        }

        featuredCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // TODO: Add Types Section
        // TODO: Add Regions Section
    }

    private func createFeaturedLayout() -> UICollectionViewLayout {
        // Item size - each row
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group size - 3 items vertically (one page)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(360) // 120 * 3 (no spacing between items)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - Data
    private func loadMockData() {
        // Mock data for 9 featured Pokémon
        featuredPokemons = [
            Pokemon(id: 1, name: "BULBASAUR", types: [PokemonType(name: "grass"), PokemonType(name: "poison")], isFavorited: false),
            Pokemon(id: 2, name: "IVYSAUR", types: [PokemonType(name: "grass"), PokemonType(name: "poison")], isFavorited: false),
            Pokemon(id: 3, name: "VENUSAUR", types: [PokemonType(name: "grass"), PokemonType(name: "poison")], isFavorited: false),
            Pokemon(id: 4, name: "CHARMANDER", types: [PokemonType(name: "fire")], isFavorited: false),
            Pokemon(id: 5, name: "CHARMELEON", types: [PokemonType(name: "fire")], isFavorited: false),
            Pokemon(id: 6, name: "CHARIZARD", types: [PokemonType(name: "fire"), PokemonType(name: "flying")], isFavorited: false),
            Pokemon(id: 7, name: "SQUIRTLE", types: [PokemonType(name: "water")], isFavorited: false),
            Pokemon(id: 8, name: "WARTORTLE", types: [PokemonType(name: "water")], isFavorited: false),
            Pokemon(id: 9, name: "BLASTOISE", types: [PokemonType(name: "water")], isFavorited: false),
        ]

        featuredCollectionView.reloadData()
    }

    // MARK: - Actions
    private func handleSeeMoreTapped() {
        print("See more tapped - Navigate to list page")
        // TODO: Navigate to SwiftUI list page
    }

    private func toggleFavorite(for pokemonId: Int) {
        guard let index = featuredPokemons.firstIndex(where: { $0.id == pokemonId }) else { return }
        featuredPokemons[index].isFavorited.toggle()

        // TODO: Save to UserDefaults
        print("Toggled favorite for Pokemon #\(pokemonId): \(featuredPokemons[index].isFavorited)")

        // Reload the specific cell
        let indexPath = IndexPath(item: index, section: 0)
        featuredCollectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredPokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeaturedPokemonCell.reuseIdentifier,
            for: indexPath
        ) as? FeaturedPokemonCell else {
            return UICollectionViewCell()
        }

        let pokemon = featuredPokemons[indexPath.item]
        cell.configure(with: pokemon)
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
