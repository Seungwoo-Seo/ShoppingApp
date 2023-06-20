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
        imageView.image = UIImage(named: "myBanner")

        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

}

private extension MyCollectionViewBannerCell {

    func configureHierarchy() {
        contentView.addSubview(thumnailImageView)

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
