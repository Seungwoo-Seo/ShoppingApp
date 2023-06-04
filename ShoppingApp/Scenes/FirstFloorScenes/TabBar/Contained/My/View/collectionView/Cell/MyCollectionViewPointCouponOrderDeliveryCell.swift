//
//  MyCollectionViewPointCouponOrderDeliveryCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/30.
//

import SnapKit
import UIKit

final class MyCollectionViewPointCouponOrderDeliveryCell: UICollectionViewCell {
    static let identifier = "MyCollectionViewPointCouponOrderDeliveryCell"

    // 그저 title과 image를 표시하기 위한 버튼
    private lazy var markButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 8.0
        config.background.backgroundColor = .systemBackground
        config.background.cornerRadius = 0

        let button = UIButton(configuration: config)
        // 터치 이벤트를 받지 않게 함으로써
        // collectionView의 didSeletItem delegate를
        // 사용하는게 가능
        button.isUserInteractionEnabled = false

        return button
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(
        with title: String?,
        image: UIImage?
    ) {
        markButton.setTitle(title, for: .normal)
        markButton.setImage(image, for: .normal)
    }

}

private extension MyCollectionViewPointCouponOrderDeliveryCell {

    func configureHierarchy() {
        contentView.addSubview(markButton)

        markButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
