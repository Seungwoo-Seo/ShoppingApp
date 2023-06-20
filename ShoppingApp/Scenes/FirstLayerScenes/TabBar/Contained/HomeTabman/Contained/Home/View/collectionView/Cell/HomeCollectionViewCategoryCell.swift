//
//  HomeCollectionViewCategoryCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/21.
//

import SnapKit
import UIKit

final class HomeCollectionViewCategoryCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCategoryCell"

    private lazy var thumnailImageViewShadowView: UIView = {
        let view = UIView()
        view.layer.configureShadow()

        return view
    }()

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 14.0,
            weight: .bold
        )
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(
            .init(751),
            for: .vertical
        )

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(
        with title: String,
        imageName: String
    ) {
        titleLabel.text = title
        thumnailImageView.image = UIImage(
            named: imageName
        )
    }

}

private extension HomeCollectionViewCategoryCell {

    func configureHierarchy() {
        [
            thumnailImageViewShadowView,
            titleLabel
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

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumnailImageViewShadowView.snp.bottom).offset(8.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}
