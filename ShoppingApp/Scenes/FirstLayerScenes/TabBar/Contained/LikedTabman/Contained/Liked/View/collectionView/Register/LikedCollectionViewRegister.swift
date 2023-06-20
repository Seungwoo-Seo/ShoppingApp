//
//  LikedCollectionViewRegister.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/06/01.
//

import UIKit

enum LikedCollectionViewRegister: Register {
    case `default`

    var cellRegister: [CellRegister] {
        return [
            (LikedCollectionViewCell.self,
             LikedCollectionViewCell.identifier)
        ]
    }

    var supplementaryRegister: [SupplementaryRegister] {
        return []
    }

}

