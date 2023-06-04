//
//  MyCollectionViewMyShoppingHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/02.
//

import SnapKit
import UIKit

final class MyCollectionViewMyShoppingHeader: UICollectionReusableView {
    static let identifier = "MyCollectionViewMyShoppingHeader"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0,
            weight: .bold
        )

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureCollectionReusableView()
        configureHierarchy()
    }

    func configure(with title: String?) {
        titleLabel.text = title
    }

}

private extension MyCollectionViewMyShoppingHeader {

    func configureCollectionReusableView() {
        backgroundColor = .systemBackground
    }

    func configureHierarchy() {
        [titleLabel].forEach { addSubview($0) }

        let inset: CGFloat = 16.0
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }

}



