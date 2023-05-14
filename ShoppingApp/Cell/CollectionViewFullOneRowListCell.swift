//
//  CollectionViewOneRowListCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/22.
//

import SnapKit
import UIKit
import Kingfisher

/// CollectionViewFullOneRowListCell은 collectionView에만 등록할 수 있고
/// 하나의 imageView로 가득찬 하나의 행을 가진 리스트의 Cell이다.
/// 광고 같은 섹션에 적합하며 높이만 동적으로 설정하는걸 추천한다.
final class CollectionViewFullOneRowListCell: UICollectionViewCell {
    static let identifier = "CollectionViewOneRowListCell"

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with clothes: Clothes) {
        thumnailImageView.kf.setImage(
            with: clothes.imageURL,
            placeholder: UIImage(systemName: "placeholdertext.fill")
        )
    }

}

private extension CollectionViewFullOneRowListCell {

    func setupLayout() {
        [thumnailImageView].forEach { contentView.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
