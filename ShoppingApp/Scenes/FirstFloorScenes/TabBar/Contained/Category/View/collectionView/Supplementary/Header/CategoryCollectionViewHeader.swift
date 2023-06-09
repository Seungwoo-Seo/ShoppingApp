//
//  CategoryCollectionViewHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import UIKit

protocol CategoryCollectionViewHeaderDelegate: AnyObject {
    func didTapOutLineButton(_ sender: UIButton)
    func didValueChangeOutLineButton(
        _ notification: Notification,
        outLineButton: UIButton
    )
}

final class CategoryCollectionViewHeader: UICollectionReusableView {

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 20.0,
            weight: .bold
        )
        label.setContentHuggingPriority(
            .init(251),
            for: .horizontal
        )

        return label
    }()

    private lazy var outLineButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .label

        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .trailing
        button.configurationUpdateHandler = { button in
            if button.isSelected {
                button.configuration?.image = UIImage(
                    systemName: "chevron.up"
                )
            } else {
                button.configuration?.image = UIImage(
                    systemName: "chevron.down"
                )
                button.configuration?.baseBackgroundColor = .white
            }
        }
        button.setContentHuggingPriority(
            .init(250),
            for: .horizontal
        )
        button.addTarget(
            self,
            action: #selector(didTapOutLineButton),
            for: .touchUpInside
        )

        return button
    }()

    weak var delegate: CategoryCollectionViewHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
        configureHierarachy()
        addNotification()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeNotification()
    }

    func configure(with title: String, tag: Int) {
        categoryLabel.text = title
        outLineButton.tag = tag
    }

}

private extension CategoryCollectionViewHeader {

    func configureView() {
        backgroundColor = .systemBackground
    }

    func configureHierarachy() {
        [
            categoryLabel,
            outLineButton
        ].forEach { addSubview($0) }

        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview()
        }

        outLineButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(categoryLabel.snp.trailing)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    func addNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didValueChangedOutLineButton),
            name: NSNotification.Name.likeRadioButton,
            object: nil
        )
    }

    func removeNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.likeRadioButton,
            object: nil
        )
    }

    @objc
    func didTapOutLineButton(_ sender: UIButton) {
        delegate?.didTapOutLineButton(sender)
    }

    @objc
    func didValueChangedOutLineButton(
        _ notification: Notification
    ) {
        delegate?.didValueChangeOutLineButton(
            notification,
            outLineButton: outLineButton
        )
    }

}
