//
//  MyCollectionViewRecentlyViewedCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/31.
//

import Kingfisher
import SnapKit
import UIKit

final class MyCollectionViewRecentlyViewedCell: UICollectionViewCell {
    static let identifier = "MyCollectionViewRecentlyViewedCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16.0
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

        return button
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
    }

}

private extension MyCollectionViewRecentlyViewedCell {

    func setupLayout() {
        [thumnailImageView, likedButton].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        likedButton.snp.makeConstraints { make in
            make.trailing.equalTo(thumnailImageView.snp.trailing)
            make.bottom.equalTo(thumnailImageView.snp.bottom)
        }
    }

}
