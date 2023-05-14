//
//  CollectionViewFiveColumnGridCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/21.
//

import SnapKit
import UIKit

final class CollectionViewFiveColumnGridCell: UICollectionViewCell {
    static let identifier = "CollectionViewFiveColumnGridCell"

    private let thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "placeholdertext.fill")
        imageView.tintColor = .secondaryLabel

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textAlignment = .center

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with title: String) {
        titleLabel.text = title
    }

}

private extension CollectionViewFiveColumnGridCell {

    func setupLayout() {
        [
            thumnailImageView,
            titleLabel
        ].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumnailImageView.snp.bottom).offset(4.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}
