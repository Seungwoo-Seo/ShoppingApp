//
//  AccountTableViewCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/29.
//

import SnapKit
import UIKit

final class AccountTableViewCell: UITableViewCell {
    static let identifier = "AccountTableViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 14.0,
            weight: .regular
        )

        return label
    }()

    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isHidden = true
        switchControl.addTarget(
            self,
            action: #selector(didValueChangedSwitchControl),
            for: .valueChanged
        )

        return switchControl
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(
        with title: String?,
        isSwitchHidden: Bool = true,
        setOn: Bool = false
    ) {
        titleLabel.text = title
        switchControl.isHidden = isSwitchHidden
        switchControl.setOn(setOn, animated: true)
    }

}

private extension AccountTableViewCell {

    func configureHierarchy() {
        [
            titleLabel,
            switchControl
        ].forEach { contentView.addSubview($0) }

        let inset: CGFloat = 16.0
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview()
        }

        switchControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(inset)
        }
    }

    @objc
    func didValueChangedSwitchControl(_ sender: UISwitch) {

    }

}
