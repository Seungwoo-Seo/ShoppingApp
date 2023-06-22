//
//  HomeCollectionViewSectionNameHeader.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/25.
//

import SnapKit
import UIKit

final class HomeCollectionViewSectionNameHeader: UICollectionReusableView {
    static let identifier = "HomeCollectionViewSectionNameHeader"

    private lazy var sectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 24.0,
            weight: .bold
        )

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureHierarchy()
    }

    func configure(with sectionName: String?) {
        guard let sectionName = sectionName else {return}
        sectionNameLabel.text = sectionName
    }

}

private extension HomeCollectionViewSectionNameHeader {

    func configureHierarchy() {
        addSubview(sectionNameLabel)

        let contentsInset: CGFloat = 16.0
        sectionNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(contentsInset)
            make.trailing.equalToSuperview().inset(contentsInset)
            make.bottom.equalToSuperview()
        }
    }

}
