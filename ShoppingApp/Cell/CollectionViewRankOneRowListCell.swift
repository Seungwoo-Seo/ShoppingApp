//
//  CollectionViewRankOneRowListCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/24.
//

import SnapKit
import UIKit
import Kingfisher

final class CollectionViewRankOneRowListCell: UICollectionViewCell {
    static let identifier = "CollectionViewRankOneRowListCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40.0, weight: .bold)
        label.textColor = .white

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with clothes: Clothes, item: Int) {
        thumnailImageView.kf.setImage(
            with: clothes.imageURL,
            placeholder: UIImage(systemName: "placeholdertext.fill")
        )
        rankLabel.text = "\(item)"
    }

}

private extension CollectionViewRankOneRowListCell {

    func setupLayout() {
        [thumnailImageView, rankLabel].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        rankLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumnailImageView.snp.leading).inset(8.0)
            make.bottom.equalTo(thumnailImageView.snp.bottom).inset(4.0)
        }

    }

}
