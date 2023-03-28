//
//  CollectionViewThreeRowListCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/23.
//

import SnapKit
import UIKit
import Kingfisher

final class CollectionViewThreeRowListCell: UICollectionViewCell {
    static let identifier = "CollectionViewThreeRowListCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .bold)
        label.textColor = .label
        label.setContentHuggingPriority(.init(251.0), for: .vertical)

        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.setContentHuggingPriority(.init(250.0), for: .vertical)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with clothes: Clothes) {
        thumnailImageView.kf.setImage(
            with: clothes.imageURL,
            placeholder: UIImage(systemName: "placeholdertext.fill")
        )
        mallNameLabel.text = clothes.mallName
        titleLabel.text = clothes.title
    }

}

private extension CollectionViewThreeRowListCell {

    func setupLayout() {
        let labelStackView = UIStackView(
            arrangedSubviews: [mallNameLabel, titleLabel]
        )
        labelStackView.axis = .vertical
        labelStackView.alignment = .fill
        labelStackView.distribution = .fill
        labelStackView.spacing = 4.0

        [
            thumnailImageView,
            labelStackView
        ].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(100.0)
        }

        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(thumnailImageView.snp.trailing).offset(8.0)
            make.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

}
