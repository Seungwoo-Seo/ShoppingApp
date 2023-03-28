//
//  LayoutProvider.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/26.
//

import UIKit

enum LayoutProvider {

    case homeCollectionView

    var collectionViewLayout: UICollectionViewLayout {
        switch self {
        case .homeCollectionView:
            let homeCollectionViewLayout = HomeCollectionViewLayout()
            return homeCollectionViewLayout.createLayout()
        }
    }
}
