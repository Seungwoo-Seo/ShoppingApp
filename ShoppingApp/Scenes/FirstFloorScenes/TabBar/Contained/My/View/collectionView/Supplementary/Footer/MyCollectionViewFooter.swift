//
//  MyCollectionViewFooter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/02.
//

import SnapKit
import UIKit

final class MyCollectionViewFooter: UICollectionReusableView {
    static let identifier = "MyCollectionViewFooter"

    override func layoutSubviews() {
        super.layoutSubviews()

        configureCollectionReusableView()
    }

}

private extension MyCollectionViewFooter {

    func configureCollectionReusableView() {
        backgroundColor = .secondarySystemBackground
    }

}
