//
//  HomeCollectionViewSubBannerCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/28.
//

import SnapKit
import UIKit

final class HomeCollectionViewSubBannerCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewSubBannerCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
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
    }

}

private extension HomeCollectionViewSubBannerCell {

    func setupLayout() {
        [thumnailImageView].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

