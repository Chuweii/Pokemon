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
    private var types: [String] = []
    private var regions: [Region] = []

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
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.backgroundColor = .appBackground
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
        collectionView.backgroundColor = .appBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false // Disable bounce
        collectionView.alwaysBounceVertical = false // Disable vertical bounce
        collectionView.register(FeaturedPokemonCell.self, forCellWithReuseIdentifier: FeaturedPokemonCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.tag = 1 // Tag to identify in delegate
        return collectionView
    }()

    private lazy var typesSectionHeader: SectionHeaderView = {
        let header = SectionHeaderView(title: "Types", showSeeMore: true)
        header.onSeeMoreTapped = { [weak self] in
            self?.handleTypesSeeMoreTapped()
        }
        return header
    }()

    private lazy var typesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createTypesLayout())
        collectionView.backgroundColor = .appBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false // Disable bounce
        collectionView.alwaysBounceVertical = false // Disable vertical bounce
        collectionView.alwaysBounceHorizontal = true // Enable horizontal bounce
        collectionView.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.tag = 2 // Tag to identify in delegate
        return collectionView
    }()

    private lazy var regionsSectionHeader: SectionHeaderView = {
        let header = SectionHeaderView(title: "Regions", showSeeMore: true)
        header.onSeeMoreTapped = { [weak self] in
            self?.handleRegionsSeeMoreTapped()
        }
        return header
    }()

    private lazy var regionsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createRegionsLayout())
        collectionView.backgroundColor = .appBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false // Disable scrolling for static display
        collectionView.register(RegionCell.self, forCellWithReuseIdentifier: RegionCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.tag = 3 // Tag to identify in delegate
        return collectionView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFeaturedPokemons()
        loadTypes()
        loadRegions()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .appBackground
        title = "Pokédex"

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        scrollView.backgroundColor = .appBackground
        scrollView.bounces = false

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        let spaceView = UIView()
        spaceView.backgroundColor = .clear
    
        contentStackView.addArrangedSubview(spaceView)
        spaceView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        // Add Featured Pokémon Section
        contentStackView.addArrangedSubview(featuredSectionHeader)
        contentStackView.addArrangedSubview(featuredCollectionView)

        featuredSectionHeader.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        featuredCollectionView.snp.makeConstraints { make in
            make.height.equalTo(360) // Height for 3 rows
            make.leading.trailing.equalToSuperview()
        }

        // Add Types Section
        contentStackView.addArrangedSubview(typesSectionHeader)
        contentStackView.addArrangedSubview(typesCollectionView)

        typesSectionHeader.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        typesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.leading.trailing.equalToSuperview()
        }

        // Add Regions Section
        contentStackView.addArrangedSubview(regionsSectionHeader)
        contentStackView.addArrangedSubview(regionsCollectionView)

        regionsSectionHeader.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        regionsCollectionView.snp.makeConstraints { make in
            make.height.equalTo(430) // Height for 3 rows (3 * 120 + 2 * 20 spacing = 360 + 40 = 400)
            make.leading.trailing.equalToSuperview()
        }
    }

    private func createFeaturedLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.width - 64),
            heightDimension: .absolute(360) // 120 * 3 (no spacing between items)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(0)

        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 12 // Space between pages
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func createTypesLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(160),
            heightDimension: .absolute(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(160),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func createRegionsLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
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

    private func loadTypes() {
        print("Starting to load types...")
        Task {
            do {
                types = try await viewModel.getTypes()
                print("Successfully loaded \(types.count) types")
                await MainActor.run {
                    typesCollectionView.reloadData()
                }
            } catch {
                print("Failed to load types: \(error)")
            }
        }
    }

    private func loadRegions() {
        print("Starting to load regions...")
        Task {
            do {
                regions = try await viewModel.getRegions()
                print("Successfully loaded \(regions.count) regions")
                await MainActor.run {
                    regionsCollectionView.reloadData()
                }
            } catch {
                print("Failed to load regions: \(error)")
            }
        }
    }

    // MARK: - Actions
    private func handleSeeMoreTapped() {
        print("See more tapped - Navigate to list page")
        // TODO: Navigate to SwiftUI list page
    }

    private func handleTypesSeeMoreTapped() {
        print("Types see more tapped")
        // TODO: Navigate to types page
    }

    private func handleRegionsSeeMoreTapped() {
        print("Regions see more tapped")
        // TODO: Navigate to regions page
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
        if collectionView.tag == 1 {
            // Featured Pokemon
            return featuredPokemons.count
        } else if collectionView.tag == 2 {
            // Types
            return types.count
        } else if collectionView.tag == 3 {
            // Regions
            return regions.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            // Featured Pokemon Cell
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPokemonCell.reuseIdentifier,
                for: indexPath
            ) as? FeaturedPokemonCell else {
                return UICollectionViewCell()
            }

            let pokemon = featuredPokemons[indexPath.item]

            // Determine position in group (3 items per group/page)
            let positionInGroup = indexPath.item % 3
            let isFirst = (positionInGroup == 0)
            let isLast = (positionInGroup == 2)

            cell.configure(with: pokemon, isFirst: isFirst, isLast: isLast, favoriteRepository: favoriteRepository)
            cell.onFavoriteToggle = { [weak self] pokemonId in
                self?.toggleFavorite(for: pokemonId)
            }

            return cell
        } else if collectionView.tag == 2 {
            // Type Cell
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TypeCell.reuseIdentifier,
                for: indexPath
            ) as? TypeCell else {
                return UICollectionViewCell()
            }

            let typeName = types[indexPath.item]
            cell.configure(with: typeName)

            return cell
        } else if collectionView.tag == 3 {
            // Region Cell
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RegionCell.reuseIdentifier,
                for: indexPath
            ) as? RegionCell else {
                return UICollectionViewCell()
            }

            let region = regions[indexPath.item]
            cell.configure(with: region)

            return cell
        }

        return UICollectionViewCell()
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
