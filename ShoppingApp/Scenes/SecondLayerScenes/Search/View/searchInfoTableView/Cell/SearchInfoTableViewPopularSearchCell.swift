//
//  SearchInfoTableViewPopularSearchCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/25.
//

import SnapKit
import UIKit

final class SearchInfoTableViewPopularSearchCell: UITableViewCell {
    static let identifier = "SearchInfoTableViewPopularSearchCell"

    private lazy var rankingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0,
            weight: .bold
        )

        return label
    }()

    private lazy var popularSearchLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0,
            weight: .regular
        )

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureCell()
        configureHierarchy()
    }

    func configure(
        with popularSearch: String?,
        ranking: String?
    ) {
        rankingLabel.text = ranking
        popularSearchLabel.text = popularSearch
    }

}

private extension SearchInfoTableViewPopularSearchCell {

    func configureCell() {
        selectionStyle = .none
    }

    func configureHierarchy() {
        [
            rankingLabel,
            popularSearchLabel
        ].forEach { contentView.addSubview($0) }

        rankingLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }

        popularSearchLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(
                rankingLabel.snp.trailing
            ).offset(8.0)
        }
    }

}
