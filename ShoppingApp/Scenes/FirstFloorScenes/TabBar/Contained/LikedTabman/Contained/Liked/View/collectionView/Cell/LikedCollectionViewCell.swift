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

    private lazy var thumnailImageViewShadowView: UIView = {
        let view = UIView()
        view.layer.configureShadow()

        return view
    }()

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(
            .defaultLow,
            for: .vertical
        )

        return imageView
    }()

    private lazy var likedButton: LikedButton = {
        let button = LikedButton(frame: .zero)

        return button
    }()

    private lazy var goodsInfoStackView: GoodsInfoStackView = {
        let stackView = GoodsInfoStackView(
            frame: .zero
        )

        return stackView
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
        goodsInfoStackView.configure(with: goods)
        likedButton.goods = goods
        likedButton.delegate = likedButtonDelegate
    }

    func likedButton(isSelected: Bool) {
        likedButton.isSelected = isSelected
    }

}

private extension LikedCollectionViewCell {

    func configureHierarchy() {
        [
            thumnailImageViewShadowView,
            likedButton,
            goodsInfoStackView
        ].forEach { contentView.addSubview($0) }

        thumnailImageViewShadowView.addSubview(thumnailImageView)

        thumnailImageViewShadowView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        likedButton.snp.makeConstraints { make in
            make.trailing.equalTo(thumnailImageViewShadowView.snp.trailing)
            make.bottom.equalTo(thumnailImageViewShadowView.snp.bottom)
        }

        goodsInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(thumnailImageViewShadowView.snp.bottom).offset(8.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }

}

