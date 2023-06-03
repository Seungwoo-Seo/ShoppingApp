//
//  SearchInfoTableViewPopularSearchHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/25.
//

import Foundation

import SnapKit
import UIKit

final class SearchInfoTableViewPopularSearchHeader: UITableViewHeaderFooterView {
    static let identifier = "SearchInfoTableViewPopularSearchHeader"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 20.0,
            weight: .bold
        )

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(with title: String?) {
        titleLabel.text = title
    }

}

private extension SearchInfoTableViewPopularSearchHeader {

    func configureHierarchy() {
        [titleLabel].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }

}
