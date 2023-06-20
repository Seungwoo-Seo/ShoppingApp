//
//  MyCollectionViewRecentlyViewedHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import UIKit

protocol MyCollectionViewRecentlyViewedHeaderDelegate: AnyObject {
    func didTapDetailButton()
}

final class MyCollectionViewRecentlyViewedHeader: UICollectionReusableView {
    static let identifier = "MyCollectionViewRecentlyViewedHeader"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0,
            weight: .bold
        )
        label.setContentHuggingPriority(
            .defaultLow,
            for: .horizontal
        )

        return label
    }()

    private lazy var detailButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "chevron.right"
        )

        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(
            .defaultHigh,
            for: .horizontal
        )
        button.addTarget(
            self,
            action: #selector(didTapDetailButton),
            for: .touchUpInside
        )

        return button
    }()

    weak var delegate: MyCollectionViewRecentlyViewedHeaderDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()

        configureCollectionReusableView()
        configureHierarchy()
    }

    func configure(with title: String?) {
        titleLabel.text = title
    }

}

private extension MyCollectionViewRecentlyViewedHeader {

    func configureCollectionReusableView() {
        backgroundColor = .systemBackground
    }

    func configureHierarchy() {
        [
            titleLabel,
            detailButton
        ].forEach { addSubview($0) }

        let inset: CGFloat = 16.0
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview()
        }

        detailButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    @objc
    func didTapDetailButton() {
        delegate?.didTapDetailButton()
    }

}
