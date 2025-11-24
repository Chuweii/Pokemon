//
//  SectionHeaderView.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import UIKit
import SnapKit

class SectionHeaderView: UIView {

    // MARK: - Properties
    var onSeeMoreTapped: (() -> Void)?

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See more", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    // MARK: - Initialization
    init(title: String, showSeeMore: Bool = true) {
        super.init(frame: .zero)
        titleLabel.text = title
        seeMoreButton.isHidden = !showSeeMore
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(seeMoreButton)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        seeMoreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func seeMoreButtonTapped() {
        onSeeMoreTapped?()
    }
}
