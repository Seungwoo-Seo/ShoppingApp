//
//  MyDecorationView.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/31.
//

import UIKit

class MyDecorationView: UICollectionReusableView {
    static let identifier = "MyDecorationView"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .secondarySystemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

}
