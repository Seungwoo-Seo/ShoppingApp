//
//  MyCollectionViewRegister.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/23.
//

import UIKit

enum MyCollectionViewRegister: Register {
    case `default`

    var cellRegister: [CellRegister] {
        return [
            (
                MyCollectionViewPointCouponOrderDeliveryCell.self,
                MyCollectionViewPointCouponOrderDeliveryCell.identifier
            ),
            (
                MyCollectionViewBannerCell.self,
                MyCollectionViewBannerCell.identifier
            ),
            (
                MyCollectionViewMyShoppingCell.self,
                MyCollectionViewMyShoppingCell.identifier
            ),
            (
                MyCollectionViewRecentlyViewedCell.self,
                MyCollectionViewRecentlyViewedCell.identifier
            )
        ]
    }

    var supplementaryRegister: [SupplementaryRegister] {
        return [
            (
                MyCollectionViewMyShoppingHeader.self,
                UICollectionView.elementKindSectionHeader,
                MyCollectionViewMyShoppingHeader.identifier
            ),
            (
                MyCollectionViewRecentlyViewedHeader.self,
                UICollectionView.elementKindSectionHeader,
                MyCollectionViewRecentlyViewedHeader.identifier
            ),
            (
                MyCollectionViewFooter.self,
                UICollectionView.elementKindSectionFooter,
                MyCollectionViewFooter.identifier
            )
        ]
    }

}
