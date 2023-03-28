//
//  HomeCollectionViewHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/25.
//

import SnapKit
import UIKit

final class HomeCollectionViewHeader: UICollectionReusableView {
    static let identifier = "HomeCollectionViewHeader"

    private lazy var sectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .black)

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayout()
    }

    func setData(with sectionName: String) {
        sectionNameLabel.text = sectionName
    }

}

private extension HomeCollectionViewHeader {

    func setupLayout() {
        [sectionNameLabel].forEach { addSubview($0) }

        let contentsInset: CGFloat = 16.0
        sectionNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(contentsInset)
            make.trailing.equalToSuperview().inset(contentsInset)
            make.bottom.equalToSuperview()
        }
    }

}
