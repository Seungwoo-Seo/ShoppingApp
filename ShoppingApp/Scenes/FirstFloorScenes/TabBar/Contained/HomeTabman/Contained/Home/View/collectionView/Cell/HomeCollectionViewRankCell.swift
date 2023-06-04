//
//  HomeCollectionViewRankCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/24.
//

import SnapKit
import UIKit
import Kingfisher

final class HomeCollectionViewRankCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewRankCell"

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

        return imageView
    }()

    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 40.0,
            weight: .bold
        )
        label.textColor = .white
        label.layer.configureShadow()

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(
        with goods: Goods,
        rank: Int
    ) {
        thumnailImageView.kf.setImage(
            with: goods.imageURL,
            placeholder: UIImage.placeholder
        )
        rankLabel.text = "\(rank)"
    }

}

private extension HomeCollectionViewRankCell {

    func configureHierarchy() {
        [
            thumnailImageViewShadowView,
            rankLabel
        ].forEach { contentView.addSubview($0) }

        thumnailImageViewShadowView.addSubview(thumnailImageView)

        thumnailImageViewShadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        rankLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumnailImageViewShadowView.snp.leading).inset(8.0)
            make.bottom.equalTo(thumnailImageViewShadowView.snp.bottom).inset(4.0)
        }
    }

}
