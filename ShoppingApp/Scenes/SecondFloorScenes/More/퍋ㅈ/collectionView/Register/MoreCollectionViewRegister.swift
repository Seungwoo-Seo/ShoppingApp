//
//  MoreCollectionViewRegister.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/24.
//

import Foundation
import UIKit

enum MoreCollectionViewRegister: Register {
    case `default`

    var cellRegister: [CellRegister] {
        return [
            (
                MoreCollectionViewCell.self,
                MoreCollectionViewCell.identifier
            )
        ]
    }

    var supplementaryRegister: [SupplementaryRegister] {
        return [
            (
                MoreCollectionViewHeader.self,
                UICollectionView.elementKindSectionHeader,
                MoreCollectionViewHeader.identifier
            )
        ]
    }

}
