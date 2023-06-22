//
//  CategoryCollectionViewDecorationView.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/13.
//

import UIKit

final class CategoryCollectionViewDecorationView: UICollectionReusableView {
    static let identifier = "CategoryCollectionViewDecorationView"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .secondarySystemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
