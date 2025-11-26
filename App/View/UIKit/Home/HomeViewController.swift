//
//  HomeViewController.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import UIKit
import SnapKit
import Combine
import SwiftUI

class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel()
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()

        Task {
            await viewModel.loadAllData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh favorite status when returning from detail view
        viewModel.refreshFavoriteStatus()
    }
    
    // MARK: - Bindings
    private func setupBinding() {
        viewModel.$featuredPokemons
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pokemons in
                guard let self = self else { return }

                // For initial load or when count changes, reload all
                if self.featuredCollectionView.numberOfItems(inSection: 0) != pokemons.count {
                    self.featuredCollectionView.reloadData()
                } else {
                    // For favorite toggle, find and reload only changed cells
                    let visibleIndexPaths = self.featuredCollectionView.indexPathsForVisibleItems
                    self.featuredCollectionView.reloadItems(at: visibleIndexPaths)
                }
            }
            .store(in: &cancellables)

        viewModel.$types
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] _ in
                self?.typesCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$regions
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] _ in
                self?.regionsCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { errorMessage in
                print("Error: \(errorMessage)")
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowPokemonDetailView
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let pokemon = self?.viewModel.selectedPokemon else { return }
                let pokemonDetailView = UIHostingController(rootView: PokemonDetailView(pokemon: pokemon))
                self?.navigationController?.pushViewController(pokemonDetailView, animated: true)
                self?.viewModel.shouldShowPokemonDetailView = false
            }
            .store(in: &cancellables)

        viewModel.$shouldShowPokemonListView
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let pokemonListView = UIHostingController(rootView: PokemonListView())
                self?.navigationController?.pushViewController(pokemonListView, animated: true)
                self?.viewModel.shouldShowPokemonListView = false
            }
            .store(in: &cancellables)
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
        
        // Add Space View
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
    
    // MARK: - UICollectionViewLayout
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
            self?.viewModel.didClickFeaturedSeeMoreButton()
        }
        return header
    }()

    private lazy var featuredCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFeaturedLayout())
        collectionView.backgroundColor = .appBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.alwaysBounceVertical = false
        collectionView.register(FeaturedPokemonCell.self, forCellWithReuseIdentifier: FeaturedPokemonCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.tag = 1
        return collectionView
    }()

    private lazy var typesSectionHeader: SectionHeaderView = {
        let header = SectionHeaderView(title: "Types", showSeeMore: true)
        header.onSeeMoreTapped = { [weak self] in
            self?.viewModel.didClickTypesSeeMoreButton()
        }
        return header
    }()

    private lazy var typesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createTypesLayout())
        collectionView.backgroundColor = .appBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.tag = 2
        return collectionView
    }()

    private lazy var regionsSectionHeader: SectionHeaderView = {
        let header = SectionHeaderView(title: "Regions", showSeeMore: true)
        header.onSeeMoreTapped = { [weak self] in
            self?.viewModel.didClickRegionsSeeMoreButton()
        }
        return header
    }()

    private lazy var regionsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createRegionsLayout())
        collectionView.backgroundColor = .appBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(RegionCell.self, forCellWithReuseIdentifier: RegionCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.tag = 3
        return collectionView
    }()
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            // Featured Pokemon
            return viewModel.featuredPokemons.count
        } else if collectionView.tag == 2 {
            // Types
            return viewModel.types.count
        } else if collectionView.tag == 3 {
            // Regions
            return viewModel.regions.count
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

            let pokemon = viewModel.featuredPokemons[indexPath.item]

            let positionInGroup = indexPath.item % 3
            let isFirst = (positionInGroup == 0)
            let isLast = (positionInGroup == 2)

            cell.configure(with: pokemon, isFirst: isFirst, isLast: isLast)
            cell.onFavoriteToggle = { [weak self] pokemonId in
                self?.viewModel.didClickFavoriteButton(for: pokemonId)
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

            let typeName = viewModel.types[indexPath.item]
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

            let region = viewModel.regions[indexPath.item]
            cell.configure(with: region)

            return cell
        }

        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            let pokemon = viewModel.featuredPokemons[indexPath.item]
            print("Selected Pokemon: \(pokemon.name)")
            viewModel.didClickPokemonItems(pokemon)
        }
    }
}
