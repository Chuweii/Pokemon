//
//  RegionCell.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import UIKit
import SnapKit
import Pokemon

class RegionCell: UICollectionViewCell {

    static let reuseIdentifier = "RegionCell"

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let locationCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
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
        containerView.addSubview(nameLabel)
        containerView.addSubview(locationCountLabel)

        // Add shadow to contentView (outside containerView)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 8
        contentView.layer.masksToBounds = false

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        locationCountLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configuration
    func configure(with region: Region) {
        nameLabel.text = region.capitalizedName
        locationCountLabel.text = "\(region.locationCount) Locations"
    }
}
