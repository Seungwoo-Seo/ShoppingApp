//
//  HomeCollectionViewBuyTodayCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import Kingfisher
import SnapKit
import UIKit

final class HomeCollectionViewBuyTodayCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewBuyTodayCell"

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
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        return imageView
    }()

    private lazy var likedButton: UIButton = {
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
        button.layer.configureShadow()
        button.setImage(
            Button.liked.icon.image,
            for: .normal
        )
        button.setImage(
            Button.liked.icon.selectedImage,
            for: .selected
        )
        button.addTarget(
            self,
            action: #selector(didTapLikedButton(_:)),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var clothesInfoStackView: GoodsInfoStackView = {
        let stackView = GoodsInfoStackView(frame: .zero)

        return stackView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(with goods: Goods?) {
        guard let goods = goods else {return}
        thumnailImageView.kf.setImage(
            with: goods.imageURL,
            placeholder: UIImage.placeholder
        )
        clothesInfoStackView.configure(with: goods)
    }

}

private extension HomeCollectionViewBuyTodayCell {

    func configureHierarchy() {
        [
            thumnailImageViewShadowView,
            likedButton,
            clothesInfoStackView
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

        clothesInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(thumnailImageViewShadowView.snp.bottom).offset(8.0)
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
