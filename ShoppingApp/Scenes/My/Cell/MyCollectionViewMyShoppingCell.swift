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

    private lazy var button: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .leading
        config.background.backgroundColor = .white
        config.background.cornerRadius = 0

        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading

        return button
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayout()
    }

    func configure(with data: Any?) {
        guard let data = data as? MyModel.MyCollectionViewThirdSectionButtonData else {return}

        button.configuration?.title = data.title
        button.configuration?.image = data.icon
    }

}

private extension MyCollectionViewMyShoppingCell {

    func setupLayout() {
        [button].forEach { contentView.addSubview($0) }

        button.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }

}
