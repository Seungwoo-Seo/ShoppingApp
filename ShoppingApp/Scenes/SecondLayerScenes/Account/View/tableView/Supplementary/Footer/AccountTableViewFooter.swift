//
//  AccountTableViewFooter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/29.
//

import SnapKit
import UIKit

final class AccountTableViewFooter: UITableViewHeaderFooterView {
    static let identifier = "AccountTableViewFooter"

    private lazy var accountDeleteButton: UIButton = {
        let button = UIButton()
        let underlineAttribute = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let underlineAttributedString = NSAttributedString(
            string: "탈퇴하기",
            attributes: underlineAttribute
        )

        button.setAttributedTitle(
            underlineAttributedString,
            for: .normal
        )
        button.setTitleColor(
            UIColor.secondaryLabel,
            for: .normal
        )
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        button.addTarget(
            self,
            action: #selector(didTapAccountDeleteButton),
            for: .touchUpInside
        )

        return button
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupContentView()
        setupLayout()
    }

}

private extension AccountTableViewFooter {

    func setupContentView() {
        contentView.backgroundColor = .secondarySystemBackground
    }

    func setupLayout() {
        [accountDeleteButton].forEach {
            contentView.addSubview($0)
        }

        let inset: CGFloat = 16.0
        accountDeleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
        }
    }

    @objc
    func didTapAccountDeleteButton() {

    }

}

