//
//  LikedCollectionViewCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/14.
//

import Kingfisher
import SnapKit
import UIKit

final class LikedCollectionViewCell: UICollectionViewCell {
    static let identifier = "LikedCollectionViewCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        return imageView
    }()

    private lazy var likedButton: UIButton = {
        let pointSize: CGFloat = 24.0
        let imageConfig = UIImage.SymbolConfiguration(pointSize: pointSize)
        let normalImage = UIImage(
            systemName: "heart",
            withConfiguration: imageConfig
        )
        let selectedImage = UIImage(
            systemName: "heart.fill",
            withConfiguration: imageConfig
        )

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        config.contentInsets = .init(
            top: 0,
            leading: 0,
            bottom: 8.0,
            trailing: 4.0
        )

        let button = UIButton(configuration: config)
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.addTarget(
            self,
            action: #selector(didTapLikedButton(_:)),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)

        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)

        return label
    }()

    private lazy var lpriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .bold)

        return label
    }()

    private lazy var hpriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayout()
    }

    func configure(with clothes: Goods) {
        thumnailImageView.kf.setImage(
            with: clothes.imageURL,
            placeholder: UIImage(systemName: "placeholdertext.fill")
        )
        mallNameLabel.text = clothes.mallName
        titleLabel.text = clothes.title
        lpriceLabel.text = clothes.lprice
        hpriceLabel.text = clothes.hprice
    }

}

private extension LikedCollectionViewCell {

    func setupLayout() {
        let priceStackView = UIStackView(
            arrangedSubviews: [lpriceLabel, hpriceLabel]
        )
        priceStackView.axis = .horizontal
        priceStackView.spacing = 8.0
        priceStackView.alignment = .fill
        priceStackView.distribution = .fillProportionally

        let containerStackView = UIStackView(
            arrangedSubviews: [
                mallNameLabel,
                titleLabel,
                priceStackView
            ]
        )
        containerStackView.axis = .vertical
        containerStackView.spacing = 4.0
        containerStackView.alignment = .fill
        containerStackView.distribution = .fillProportionally

        [
            thumnailImageView,
            likedButton,
            containerStackView
        ].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        let inset: CGFloat = 8.0
        likedButton.snp.makeConstraints { make in
            make.trailing.equalTo(thumnailImageView.snp.trailing)
            make.bottom.equalTo(thumnailImageView.snp.bottom)
        }

        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(thumnailImageView.snp.bottom).offset(inset)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }

    @objc func didTapLikedButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.configuration?.baseForegroundColor = .white
        } else {
            sender.isSelected = true
            sender.configuration?.baseForegroundColor = .red
        }
    }

}

