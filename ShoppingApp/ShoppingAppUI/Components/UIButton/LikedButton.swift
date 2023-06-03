//
//  LikedButton.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/24.
//

import UIKit

protocol LikedButtonDelegate: AnyObject {
    func didTapLikedButton(_ sender: LikedButton)
}

final class LikedButton: UIButton {
    var goods: Goods?

    weak var delegate: LikedButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        config.contentInsets = .init(
            top: 0,
            leading: 0,
            bottom: 8.0,
            trailing: 8.0
        )
        configuration = config

        layer.configureShadow()

        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 20.0
        )

        setImage(
            UIImage(
                systemName: "heart",
                withConfiguration: symbolConfig
            )?.imageWithColor(color: .white),
            for: .normal
        )
        setImage(
            UIImage(
                systemName: "heart.fill",
                withConfiguration: symbolConfig
            )?.imageWithColor(color: .red),
            for: .selected
        )
        addTarget(
            self,
            action: #selector(didTapLikedButton),
            for: .touchUpInside
        )
    }

}

private extension LikedButton {

    @objc
    func didTapLikedButton(_ sender: LikedButton) {
        delegate?.didTapLikedButton(sender)
    }

}
