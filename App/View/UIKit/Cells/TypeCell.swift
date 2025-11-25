//
//  TypeCell.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import UIKit
import SnapKit

class TypeCell: UICollectionViewCell {

    static let reuseIdentifier = "TypeCell"

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

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
        containerView.addSubview(typeLabel)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        typeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configuration
    func configure(with typeName: String) {
        typeLabel.text = typeName.capitalized
        containerView.backgroundColor = getTypeColor(for: typeName)
    }

    private func getTypeColor(for typeName: String) -> UIColor {
        switch typeName.lowercased() {
        case "normal": return UIColor(red: 0.66, green: 0.66, blue: 0.47, alpha: 1.0)
        case "fighting": return UIColor(red: 0.75, green: 0.19, blue: 0.15, alpha: 1.0)
        case "flying": return UIColor(red: 0.66, green: 0.56, blue: 0.95, alpha: 1.0)
        case "poison": return UIColor(red: 0.64, green: 0.31, blue: 0.71, alpha: 1.0)
        case "ground": return UIColor(red: 0.89, green: 0.75, blue: 0.42, alpha: 1.0)
        case "rock": return UIColor(red: 0.72, green: 0.63, blue: 0.42, alpha: 1.0)
        case "bug": return UIColor(red: 0.65, green: 0.71, blue: 0.16, alpha: 1.0)
        case "ghost": return UIColor(red: 0.44, green: 0.35, blue: 0.60, alpha: 1.0)
        case "steel": return UIColor(red: 0.72, green: 0.72, blue: 0.82, alpha: 1.0)
        case "fire": return UIColor(red: 0.93, green: 0.51, blue: 0.19, alpha: 1.0)
        case "water": return UIColor(red: 0.25, green: 0.53, blue: 0.82, alpha: 1.0)
        case "grass": return UIColor(red: 0.48, green: 0.78, blue: 0.27, alpha: 1.0)
        case "electric": return UIColor(red: 0.98, green: 0.82, blue: 0.18, alpha: 1.0)
        case "psychic": return UIColor(red: 0.98, green: 0.33, blue: 0.45, alpha: 1.0)
        case "ice": return UIColor(red: 0.60, green: 0.85, blue: 0.85, alpha: 1.0)
        case "dragon": return UIColor(red: 0.44, green: 0.21, blue: 0.98, alpha: 1.0)
        case "dark": return UIColor(red: 0.44, green: 0.35, blue: 0.27, alpha: 1.0)
        case "fairy": return UIColor(red: 0.85, green: 0.51, blue: 0.68, alpha: 1.0)
        default: return .systemGray
        }
    }
}
