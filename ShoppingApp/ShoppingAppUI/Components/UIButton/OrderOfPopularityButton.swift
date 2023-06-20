//
//  OrderOfPopularityButton.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/24.
//

import UIKit

final class OrderOfPopularityButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .clear

        config.title = "인기순"

        let symbolConfig = UIImage.SymbolConfiguration(
            scale: .small
        )
        config.imagePlacement = .trailing
        config.imagePadding = 4.0
        config.image = UIImage(
            systemName: "arrow.up.arrow.down",
            withConfiguration: symbolConfig
        )

        config.contentInsets = .init(
            top: 4.0,
            leading: 0,
            bottom: 4.0,
            trailing: 0
        )
        configuration = config
    }

}

