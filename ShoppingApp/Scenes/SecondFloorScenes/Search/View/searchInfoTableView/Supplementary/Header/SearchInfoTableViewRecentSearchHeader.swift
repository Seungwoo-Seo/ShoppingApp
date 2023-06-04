//
//  SearchInfoTableViewRecentSearchHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/25.
//

import SnapKit
import UIKit

protocol SearchInfoTableViewRecentSearchHeaderDelegate: AnyObject {
    func didTapRemoveButton()
}

final class SearchInfoTableViewRecentSearchHeader: UITableViewHeaderFooterView {
    static let identifier = "SearchInfoTableViewRecentSearchHeader"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 20.0,
            weight: .bold
        )

        return label
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체삭제", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapRemoveButton),
            for: .touchUpInside
        )

        return button
    }()

    weak var delegate: SearchInfoTableViewRecentSearchHeaderDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(with title: String?) {
        titleLabel.text = title
    }

}

private extension SearchInfoTableViewRecentSearchHeader {

    func configureHierarchy() {
        [
            titleLabel,
            removeButton
        ].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }

        removeButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.leading.greaterThanOrEqualTo(
                titleLabel.snp.trailing
            )
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    @objc
    func didTapRemoveButton() {
        delegate?.didTapRemoveButton()
    }

}
