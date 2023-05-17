//
//  MyCollectionViewBannerCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/30.
//

import SnapKit
import UIKit
import Kingfisher

final class MyCollectionViewBannerCell: UICollectionViewCell {
    static let identifier = "MyCollectionViewBannerCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "placeholdertext.fill")

        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayout()
    }

    func setData(with clothes: Clothes) {
        thumnailImageView.kf.setImage(
            with: clothes.imageURL,
            placeholder: UIImage(systemName: "placeholdertext.fill")
        )
    }

}

private extension MyCollectionViewBannerCell {

    func setupLayout() {
        [thumnailImageView].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
