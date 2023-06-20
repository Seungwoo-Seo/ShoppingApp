//
//  HomeCollectionViewSubBannerCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/28.
//

import Kingfisher
import SnapKit
import UIKit

final class HomeCollectionViewSubBannerCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewSubBannerCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "homeBanner")

        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

}

private extension HomeCollectionViewSubBannerCell {

    func configureHierarchy() {
        [thumnailImageView].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

