//
//  HomeCollectionViewBrandOfTheWeekCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/23.
//

import SnapKit
import UIKit
import Kingfisher

final class HomeCollectionViewBrandOfTheWeekCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewBrandOfTheWeekCell"

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

    private lazy var mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 18.0,
            weight: .bold
        )
        label.textColor = .label
        label.setContentHuggingPriority(
            .init(251.0),
            for: .vertical
        )

        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0,
            weight: .semibold
        )
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.setContentHuggingPriority(
            .init(250.0),
            for: .vertical
        )

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(with goods: Goods) {
        thumnailImageView.kf.setImage(
            with: goods.imageURL,
            placeholder: UIImage.placeholder
        )
        mallNameLabel.text = goods.mallName
        titleLabel.text = String(
            htmlEncodedString: goods.title
        )
    }

}

private extension HomeCollectionViewBrandOfTheWeekCell {

    func configureHierarchy() {
        let labelStackView = UIStackView(
            arrangedSubviews: [mallNameLabel, titleLabel]
        )
        labelStackView.axis = .vertical
        labelStackView.alignment = .fill
        labelStackView.distribution = .fill
        labelStackView.spacing = 4.0

        [
            thumnailImageViewShadowView,
            labelStackView
        ].forEach { contentView.addSubview($0) }

        thumnailImageViewShadowView.addSubview(thumnailImageView)

        thumnailImageViewShadowView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(100.0)
        }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(thumnailImageViewShadowView.snp.trailing).offset(8.0)
            make.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

}
