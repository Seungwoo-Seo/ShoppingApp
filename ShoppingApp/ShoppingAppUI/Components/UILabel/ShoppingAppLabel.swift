//
//  ShoppingAppLabel.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/16.
//

import UIKit

enum ShoppingAppLabelStyle {
    case error
}

final class ShoppingAppLabel: UILabel {
    private let style: ShoppingAppLabelStyle

    init(style: ShoppingAppLabelStyle) {
        self.style = style
        super.init(frame: .zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        switch style {
        case .error:
            textColor = .red
            font = .systemFont(
                ofSize: 14.0,
                weight: .bold
            )
            numberOfLines = 2
            lineBreakMode = .byCharWrapping
            isHidden = true
        }
    }

}
