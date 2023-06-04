//
//  MoreCollectionViewHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/24.
//

import SnapKit
import UIKit

protocol MoreCollectionViewHeaderDelegate: AnyObject {
    func didTapOrderOfPopularityButton()
    func didTapFilterButton()
}

final class MoreCollectionViewHeader: UICollectionReusableView {
    static let identifier = "MoreCollectionViewHeader"

    private lazy var orderOfPopularityButton: OrderOfPopularityButton = {
        let button = OrderOfPopularityButton(
            frame: .zero
        )
        button.addTarget(
            self,
            action: #selector(didTapOrderOfPopularityButton),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var filterButton: FilterButton = {
        let button = FilterButton(frame: .zero)
        button.addTarget(
            self,
            action: #selector(didTapFilterButton),
            for: .touchUpInside
        )

        return button
    }()

    weak var delegate: MoreCollectionViewHeaderDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

}

private extension MoreCollectionViewHeader {

    func configureHierarchy() {
        let buttonStackView = UIStackView(
            arrangedSubviews: [
                orderOfPopularityButton,
                filterButton
            ]
        )
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 8.0

        addSubview(buttonStackView)

        buttonStackView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
        }
    }

    @objc
    func didTapOrderOfPopularityButton() {
        delegate?.didTapOrderOfPopularityButton()
    }

    @objc
    func didTapFilterButton() {
        delegate?.didTapFilterButton()
    }

}
