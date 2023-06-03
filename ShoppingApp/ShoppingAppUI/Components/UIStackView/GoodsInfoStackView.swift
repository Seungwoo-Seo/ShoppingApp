//
//  GoodsInfoStackView.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/18.
//

import UIKit

final class GoodsInfoStackView: UIStackView {

    private lazy var mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0, weight: .medium
        )

        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16.0, weight: .regular
        )

        return label
    }()

    private lazy var lpriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 18.0, weight: .bold
        )

        return label
    }()

    private lazy var hpriceLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .secondaryLabel
        label.font = .systemFont(
            ofSize: 14.0, weight: .regular
        )

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with goods: Goods) {
        mallNameLabel.text = goods.mallName
        titleLabel.text = String(
            htmlEncodedString: goods.title
        )

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        if let lprice = Int(goods.lprice),
           let text = numberFormatter.string(
            for: lprice
           ) {
            lpriceLabel.text = "\(text)원"
        }

        if let hprice = Int(goods.hprice),
           let text = numberFormatter.string(
            for: hprice
           ) {
            hpriceLabel.text = "\(text)원"
        }
    }

}

private extension GoodsInfoStackView {

    func configureHierarchy() {
        let priceStackView = UIStackView(
            arrangedSubviews: [lpriceLabel, hpriceLabel]
        )
        priceStackView.axis = .horizontal
        priceStackView.spacing = 4.0
        priceStackView.alignment = .fill
        priceStackView.distribution = .fillProportionally

        [
            mallNameLabel,
            titleLabel,
            priceStackView
        ].forEach { addArrangedSubview($0) }

        axis = .vertical
        spacing = 4.0
        alignment = .fill
        distribution = .fillProportionally
    }

}
