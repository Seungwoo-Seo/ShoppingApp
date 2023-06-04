//
//  CategoryCollectionViewCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0,
            weight: .semibold
        )
        label.sizeToFit()

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: String) {
        categoryLabel.text = category
    }

}

private extension CategoryCollectionViewCell {

    func configureHierarchy() {
        [categoryLabel].forEach { contentView.addSubview($0) }

        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
