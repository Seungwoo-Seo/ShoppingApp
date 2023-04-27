//
//  MainBannerCellCollectionViewCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/21.
//

import SnapKit
import UIKit
import Kingfisher

final class MainBannerCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainBannerCellCollectionViewCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with goods: Goods?) {
        guard let goods = goods else {return}
        thumnailImageView.kf.setImage(
            with: goods.imageURL,
            placeholder: UIImage.placeholder
        )
    }

}

private extension MainBannerCellCollectionViewCell {

    func configureHierarchy() {
        [thumnailImageView].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
