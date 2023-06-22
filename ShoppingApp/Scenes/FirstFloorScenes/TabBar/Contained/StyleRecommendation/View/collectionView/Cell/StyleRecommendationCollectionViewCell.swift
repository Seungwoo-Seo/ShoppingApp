//
//  StyleRecommendationCollectionViewCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import Kingfisher
import SnapKit
import UIKit

final class StyleRecommendationCollectionViewCell: UICollectionViewCell {
    static let identifier = "StyleRecommendationCollectionViewCell"

    private lazy var thumnailImageViewShadowView: UIView = {
        let view = UIView()
        view.layer.configureShadow()
        view.setContentCompressionResistancePriority(
            .defaultLow,
            for: .vertical
        )

        return view
    }()

    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var likedButton: LikedButton = {
        let button = LikedButton(frame: .zero)

        return button
    }()

    private lazy var goodsInfoStackView: GoodsInfoStackView = {
        let stackView = GoodsInfoStackView(
            frame: .zero
        )

        return stackView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(
        with goods: Goods,
        likedButtonDelegate: LikedButtonDelegate
    ) {
        thumnailImageView.kf.setImage(
            with: goods.imageURL,
            placeholder: UIImage.placeholder
        )
        goodsInfoStackView.configure(with: goods)
        likedButton.goods = goods
        likedButton.delegate = likedButtonDelegate
    }

    func likedButton(isSelected: Bool) {
        likedButton.isSelected = isSelected
    }

}

private extension StyleRecommendationCollectionViewCell {

    func configureHierarchy() {
        [
            thumnailImageViewShadowView,
            likedButton,
            goodsInfoStackView
        ].forEach { contentView.addSubview($0) }

        thumnailImageViewShadowView.addSubview(thumnailImageView)

        thumnailImageViewShadowView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        likedButton.snp.makeConstraints { make in
            make.trailing.equalTo(thumnailImageView.snp.trailing)
            make.bottom.equalTo(thumnailImageView.snp.bottom)
        }

        goodsInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(thumnailImageViewShadowView.snp.bottom).offset(8.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}


//extension UIImageView {
//
//    // 1. 이미지를 네트워크에서 다운로드하기 전에 캐시된 이미지가 있는지 검색
//    // 2. 캐시된 이미지가 있다면 -> 캐시된 이미지를 가져와서 image에 적용
//    // 3. 캐시된 이미지가 없다면 -> 네트워크 통신을 하여 이미지를 다운로드
//    // 4. 새롭게 다운로드된 이미지 캐싱
//    func setImage(with urlString: String) {
//        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
//            switch result {
//            case .success(let value):
//                if let image = value.image {
//                    //캐시가 존재하는 경우
//                    self.image = image
//                } else {
//                    //캐시가 존재하지 않는 경우
//                    guard let url = URL(string: urlString) else { return }
//                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
//                    self.kf.setImage(with: resource)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//}
