//
//  MyCollectionViewDetailHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import UIKit

final class MyCollectionViewDetailHeader: UICollectionReusableView {
    static let identifier = "MyCollectionViewDetailHeader"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0,
            weight: .bold
        )
        label.setContentHuggingPriority(
            .defaultLow,
            for: .horizontal
        )

        return label
    }()

    private lazy var detailButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")

        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(
            .defaultHigh,
            for: .horizontal
        )
        button.addTarget(
            self,
            action: #selector(didTapAccessoryButton),
            for: .touchUpInside
        )

        return button
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayout()
    }

    func configure(with title: String) {
        titleLabel.text = title
    }

}

private extension MyCollectionViewDetailHeader {

    func setupLayout() {
        backgroundColor = .systemBackground

        [titleLabel, detailButton].forEach { addSubview($0) }

        let inset: CGFloat = 16.0
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview()
        }

        detailButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    @objc
    func didTapAccessoryButton() {

    }

}
