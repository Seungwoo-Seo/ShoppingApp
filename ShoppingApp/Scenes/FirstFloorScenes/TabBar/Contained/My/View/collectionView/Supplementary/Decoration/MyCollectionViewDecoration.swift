//
//  MyCollectionViewDecoration.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/31.
//

import UIKit

class MyCollectionViewDecoration: UICollectionReusableView {
    static let identifier = "MyCollectionViewDecoration"

    override func layoutSubviews() {
        super.layoutSubviews()

        configureCollectionReusableView()
    }

}

private extension MyCollectionViewDecoration {

    func configureCollectionReusableView() {
        backgroundColor = .secondarySystemBackground
    }

}
