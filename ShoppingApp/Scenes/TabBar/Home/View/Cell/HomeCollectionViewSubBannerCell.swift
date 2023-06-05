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

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var task: DownloadTask?

    func configure(with goods: Goods?) {
        guard let goods = goods else {return}
        task = thumnailImageView.kf.setImage(
            with: goods.imageURL,
            placeholder: UIImage.placeholder
        )
    }

    func cancelDownloadTask() {
        task?.cancel()
//        thumnailImageView.kf.cancelDownloadTask()
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

