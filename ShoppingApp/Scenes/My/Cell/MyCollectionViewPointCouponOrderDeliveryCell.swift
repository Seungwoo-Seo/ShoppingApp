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

    private lazy var button: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.background.backgroundColor = .systemBackground
        config.background.cornerRadius = 0

        let button = UIButton(configuration: config)
        button.isUserInteractionEnabled = false

        return button
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayout()
    }

    func configure(with data: Any?) {
        guard let data = data as? MyModel.MyCollectionViewFirstSectionButtonData else {return}
        button.configuration?.title = data.title
        button.configuration?.image = data.icon
    }

}

private extension MyCollectionViewPointCouponOrderDeliveryCell {

    func setupLayout() {
        [button].forEach { contentView.addSubview($0) }

        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
