//
//  RecentlyViewedCollectionViewRegister.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/24.
//

import UIKit

enum RecentlyViewedCollectionViewRegister: Register {
    case `default`

    var cellRegister: [CellRegister] {
        return [
            (RecentlyViewedCollectionViewCell.self,
             RecentlyViewedCollectionViewCell.identifier)
        ]
    }

    var supplementaryRegister: [SupplementaryRegister] {
        return []
    }

}
