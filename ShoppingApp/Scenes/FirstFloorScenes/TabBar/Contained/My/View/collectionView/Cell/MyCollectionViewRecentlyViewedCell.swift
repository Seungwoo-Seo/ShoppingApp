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

    private lazy var thumnailImageViewShadowView: UIView = {
        let view = UIView()
        view.layer.configureShadow()
        view.setContentCompressionResistancePriority(
            .defaultLow,
            for: .vertical
        )

        return view
    }()

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var likedButton: LikedButton = {
        let button = LikedButton(frame: .zero)

        return button
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(
        with goods: Goods,
        likedButtonDelegate: LikedButtonDelegate
    ) {
        thumnailImageView.kf.setImage(
            with: goods.imageURL,
            placeholder: UIImage.placeholder
        )
        likedButton.goods = goods
        likedButton.delegate = likedButtonDelegate
    }

    func likedButton(isSelected: Bool) {
        likedButton.isSelected = isSelected
    }

}

private extension MyCollectionViewRecentlyViewedCell {

    func configureHierarchy() {
        [
            thumnailImageViewShadowView,
            likedButton
        ].forEach { contentView.addSubview($0) }

        thumnailImageViewShadowView.addSubview(thumnailImageView)

        thumnailImageViewShadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        likedButton.snp.makeConstraints { make in
            make.trailing.equalTo(thumnailImageView.snp.trailing)
            make.bottom.equalTo(thumnailImageView.snp.bottom)
        }
    }

}
