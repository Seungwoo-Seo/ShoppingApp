//
//  HomeCollectionViewMoreFooter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/16.
//

import SnapKit
import UIKit

protocol HomeCollectionViewMoreFooterDelegate: AnyObject {
    func didTapMoreButton(_ tag: Int)
}

final class HomeCollectionViewMoreFooter: UICollectionReusableView {
    static let identifier = "HomeCollectionViewFooter"

    weak var delegate: HomeCollectionViewMoreFooterDelegate?

    private lazy var moreButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "더보기"
        config.image = UIImage(
            systemName: "chevron.forward"
        )
        config.preferredSymbolConfigurationForImage = .init(scale: .medium)
        config.imagePadding = 4.0
        config.imagePlacement = .trailing
        config.cornerStyle = .capsule
        config.baseForegroundColor = .systemGray4
        config.background.strokeColor = .systemGray4
        config.contentInsets = .init(
            top: 4.0,
            leading: 40.0,
            bottom: 4.0,
            trailing: 40.0
        )

        let button = UIButton(configuration: config)
        button.addTarget(
            self,
            action: #selector(didTapMoreButton),
            for: .touchUpInside
        )

        return button
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(
        tag: Int,
        delegate: HomeCollectionViewMoreFooterDelegate
    ) {
        moreButton.tag = tag
        self.delegate = delegate
    }

}

private extension HomeCollectionViewMoreFooter {

    func configureHierarchy() {
        addSubview(moreButton)

        moreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }

    @objc
    func didTapMoreButton(_ sender: UIButton) {
        delegate?.didTapMoreButton(sender.tag)
    }

}
