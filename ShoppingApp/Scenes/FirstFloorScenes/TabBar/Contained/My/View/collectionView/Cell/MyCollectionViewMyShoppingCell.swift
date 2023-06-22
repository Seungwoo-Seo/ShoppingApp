//
//  MyCollectionViewMyShoppingCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/30.
//

import SnapKit
import UIKit

final class MyCollectionViewMyShoppingCell: UICollectionViewCell {
    static let identifier = "MyCollectionViewMyShoppingCell"

    private lazy var markButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .white
        config.background.cornerRadius = 0
        config.imagePlacement = .top
        config.imagePadding = 8.0

        let button = UIButton(configuration: config)
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

private extension MyCollectionViewMyShoppingCell {

    func configureHierarchy() {
        contentView.addSubview(markButton)

        markButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }

}
