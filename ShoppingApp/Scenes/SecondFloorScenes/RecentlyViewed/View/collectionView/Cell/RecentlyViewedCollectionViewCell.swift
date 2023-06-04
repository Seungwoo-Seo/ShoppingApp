//
//  RecentlyViewedCollectionViewCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import Kingfisher
import SnapKit
import UIKit

protocol RecentlyViewedCollectionViewCellDelegate: AnyObject {
    func didTapDeleteButton(_ sender: UIButton)
}

final class RecentlyViewedCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecentlyViewedCollectionViewCell"

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

    private lazy var deleteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.background.backgroundColor = .lightGray
        config.cornerStyle = .capsule
        config.buttonSize = .mini
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 12.0
        )
        config.image = UIImage(
            systemName: "xmark",
            withConfiguration: symbolConfig
        )

        let button = UIButton(configuration: config)
        button.addTarget(
            self,
            action: #selector(didTapDeleteButton),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var goodsInfoStackView: GoodsInfoStackView = {
        let stackView = GoodsInfoStackView(
            frame: .zero
        )

        return stackView
    }()

    weak var delegate: RecentlyViewedCollectionViewCellDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(
        with goods: Goods,
        tag: Int,
        likedButtonDelegate: LikedButtonDelegate
    ) {
        thumnailImageView.kf.setImage(
            with: goods.imageURL,
            placeholder: UIImage.placeholder
        )
        goodsInfoStackView.configure(with: goods)
        deleteButton.tag = tag
        likedButton.goods = goods
        likedButton.delegate = likedButtonDelegate
    }

    func likedButton(isSelected: Bool) {
        likedButton.isSelected = isSelected
    }

}

private extension RecentlyViewedCollectionViewCell {

    func configureHierarchy() {
        [
            thumnailImageViewShadowView,
            likedButton,
            deleteButton,
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
            make.trailing.equalTo(
                thumnailImageViewShadowView.snp.trailing
            )
            make.bottom.equalTo(
                thumnailImageViewShadowView.snp.bottom
            )
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(3.0)
            make.trailing.equalToSuperview().inset(3.0)
        }

        goodsInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(
                thumnailImageViewShadowView.snp.bottom
            ).offset(8.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    @objc
    func didTapDeleteButton(_ sender: UIButton) {
        delegate?.didTapDeleteButton(sender)
    }

}


