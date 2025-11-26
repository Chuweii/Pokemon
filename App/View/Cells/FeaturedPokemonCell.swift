//
//  FeaturedPokemonCell.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import UIKit
import SnapKit
import Pokemon

class FeaturedPokemonCell: UICollectionViewCell {

    static let reuseIdentifier = "FeaturedPokemonCell"

    // MARK: - Properties
    var onFavoriteToggle: ((Int) -> Void)?
    private var pokemonId: Int?

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let smallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .darkGray
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let pokeballImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isHidden = true // Hide until we have actual image
        return imageView
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        button.setImage(UIImage(named: "unfavorite_icon", in: nil, with: config), for: .normal)
        button.setImage(UIImage(named: "isfavorite_icon", in: nil, with: config), for: .selected)
        return button
    }()

    private let largeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Properties for shadow
    private var isFirstCell: Bool = false
    private var isLastCell: Bool = false

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(containerView)

        containerView.addSubview(smallImageView)
        containerView.addSubview(numberLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(typeStackView)
        containerView.addSubview(pokeballImageView)
        containerView.addSubview(favoriteButton)
        containerView.addSubview(largeImageView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        smallImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(64)
        }

        numberLabel.snp.makeConstraints { make in
            make.leading.equalTo(smallImageView.snp.trailing).offset(12)
            make.top.equalTo(smallImageView.snp.top)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel)
            make.top.equalTo(numberLabel.snp.bottom).offset(2)
        }

        typeStackView.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.bottom.lessThanOrEqualTo(smallImageView.snp.bottom)
        }

        largeImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        largeImageView.isHidden = true // Hide the large image

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }

        pokeballImageView.snp.makeConstraints { make in
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        guard let pokemonId = pokemonId else { return }
        onFavoriteToggle?(pokemonId)
    }

    // MARK: - Configuration
    func configure(with pokemon: Pokemon, isFirst: Bool, isLast: Bool) {
        self.pokemonId = pokemon.id
        numberLabel.text = pokemon.formattedNumber
        nameLabel.text = pokemon.capitalizedName

        // Store position for shadow update
        isFirstCell = isFirst
        isLastCell = isLast

        // Use Pokemon's isFavorited state
        favoriteButton.isSelected = pokemon.isFavorited

        // Configure rounded corners based on position
        if isFirst && isLast {
            // Only one item in group - all corners rounded
            containerView.layer.cornerRadius = 16
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if isFirst {
            // First item - top corners rounded
            containerView.layer.cornerRadius = 16
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLast {
            // Last item - bottom corners rounded
            containerView.layer.cornerRadius = 16
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Middle item - no rounded corners
            containerView.layer.cornerRadius = 0
        }

        containerView.clipsToBounds = true

        // Load image for small imageView only
        if let imageUrl = pokemon.imageUrl {
            ImageLoader.shared.loadImage(from: imageUrl, into: smallImageView)
        } else {
            // Use sprite images as fallback
            if let spriteUrl = pokemon.sprites?.frontDefault {
                ImageLoader.shared.loadImage(from: spriteUrl, into: smallImageView)
            } else {
                smallImageView.image = nil
            }
        }

        // Clear previous type labels
        typeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Add type labels
        for type in pokemon.types {
            let typeLabel = createTypeLabel(for: type)
            typeStackView.addArrangedSubview(typeLabel)
        }
    }

    private func createTypeLabel(for type: PokemonType) -> UILabel {
        let label = UILabel()
        label.text = type.displayName
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = getTypeColor(for: type.name)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true

        // Set padding
        label.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(60)
        }

        return label
    }

    private func getTypeColor(for typeName: String) -> UIColor {
        switch typeName.lowercased() {
        case "grass": return UIColor(red: 0.48, green: 0.78, blue: 0.27, alpha: 1.0)
        case "poison": return UIColor(red: 0.64, green: 0.31, blue: 0.71, alpha: 1.0)
        case "fire": return UIColor(red: 0.93, green: 0.51, blue: 0.19, alpha: 1.0)
        case "water": return UIColor(red: 0.25, green: 0.53, blue: 0.82, alpha: 1.0)
        case "electric": return UIColor(red: 0.98, green: 0.82, blue: 0.18, alpha: 1.0)
        case "normal": return UIColor(red: 0.66, green: 0.66, blue: 0.47, alpha: 1.0)
        case "fighting": return UIColor(red: 0.75, green: 0.19, blue: 0.15, alpha: 1.0)
        case "flying": return UIColor(red: 0.66, green: 0.56, blue: 0.95, alpha: 1.0)
        default: return .systemGray
        }
    }
}
