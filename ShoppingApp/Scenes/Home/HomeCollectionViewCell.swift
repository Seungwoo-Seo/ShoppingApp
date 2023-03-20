//
//  HomeCollectionViewCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import Kingfisher
import SnapKit
import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var likedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white

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

    func setData(with clothes: Clothes) {
        thumnailImageView.kf.setImage(with: clothes.imageURL, placeholder: UIImage())
        mallNameLabel.text = clothes.mallName
        titleLabel.text = clothes.title
        lpriceLabel.text = clothes.lprice
        hpriceLabel.text = clothes.hprice
    }

}

private extension HomeCollectionViewCell {

    func setupLayout() {
        let priceStackView = UIStackView(
            arrangedSubviews: [lpriceLabel, hpriceLabel]
        )
        priceStackView.axis = .horizontal
        priceStackView.spacing = 8.0
        priceStackView.alignment = .fill
        priceStackView.distribution = .fillProportionally

        [
            thumnailImageView,
            likedButton,
            mallNameLabel,
            titleLabel,
            priceStackView
        ].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(200.0)
        }

        let likedInset: CGFloat = 8.0

        likedButton.snp.makeConstraints { make in
            make.trailing.equalTo(thumnailImageView.snp.trailing).inset(likedInset)
            make.bottom.equalTo(thumnailImageView.snp.bottom).inset(likedInset)
        }

        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumnailImageView.snp.bottom).offset(4.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        priceStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}
