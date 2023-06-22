//
//  SearchResultsTableViewCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/25.
//

import SnapKit
import UIKit

final class SearchResultsTableViewCell: UITableViewCell {
    static let identifier = "SearchResultsTableViewCell"

    private lazy var resultTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0,
            weight: .regular
        )

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(with title: String?) {
        resultTitleLabel.text = String(
            htmlEncodedString: title
        )
    }

}

private extension SearchResultsTableViewCell {

    func configureHierarchy() {
        contentView.addSubview(resultTitleLabel)

        resultTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }

}
