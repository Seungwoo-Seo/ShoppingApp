//
//  StyleRecommendationCollectionViewRegister.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/21.
//

import UIKit

protocol Register {
    typealias CellRegister = (
        cellClass: AnyClass?,
        identifier: String
    )

    typealias SupplementaryRegister = (
        viewClass: AnyClass?,
        kind: String,
        identifier: String
    )

    var cellRegister: [CellRegister] {get}
    var supplementaryRegister: [SupplementaryRegister] {get}
}

enum StyleRecommendationCollectionViewRegister: Register {
    case `default`

    var cellRegister: [CellRegister] {
        return [
            (StyleRecommendationCollectionViewCell.self,
             StyleRecommendationCollectionViewCell.identifier)
        ]
    }

    var supplementaryRegister: [SupplementaryRegister] {
        return [
            (StyleRecommendationCollectionViewHeader.self,
             UICollectionView.elementKindSectionHeader,
             StyleRecommendationCollectionViewHeader.identifier)
        ]
    }

}
