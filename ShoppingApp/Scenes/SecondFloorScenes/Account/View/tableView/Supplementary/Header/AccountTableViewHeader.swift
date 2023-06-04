//
//  AccountTableViewHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/29.
//

import SnapKit
import UIKit

final class AccountTableViewHeader: UITableViewHeaderFooterView {
    static let identifier = "AccountTableViewHeader"

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

        configureContentView()
        configureHierarchy()
    }

    func configure(with title: String?) {
        titleLabel.text = title
    }

}

private extension AccountTableViewHeader {

    func configureContentView() {
        contentView.backgroundColor = .systemBackground
    }

    func configureHierarchy() {
        [titleLabel].forEach {
            contentView.addSubview($0)
        }

        let inset: CGFloat = 16.0
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}
