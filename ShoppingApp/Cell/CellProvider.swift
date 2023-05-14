//
//  CellProvider.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/24.
//

import Foundation

// 등록할 셀을 공급해주면 view에서 등록만 하면 되잖아
enum CellProvider {
    typealias Register = (cellClass: AnyClass?, identifier: String)

    case homeCollectionView   // Home Scene에 collectionView

    var registers: [Register] {
        switch self {
        case .homeCollectionView:
            return [
                (CollectionViewFullOneRowListCell.self, CollectionViewFullOneRowListCell.identifier),
                (CollectionViewFiveColumnGridCell.self, CollectionViewFiveColumnGridCell.identifier),
                (CollectionViewTwoColumnGridCell.self, CollectionViewTwoColumnGridCell.identifier),
                (CollectionViewThreeRowListCell.self, CollectionViewThreeRowListCell.identifier),
                (CollectionViewRankOneRowListCell.self, CollectionViewRankOneRowListCell.identifier),

                (HomeCollectionViewNowLookingCell.self,
                 HomeCollectionViewNowLookingCell.identifier),
                (HomeCollectionViewSubBannerCell.self,
                 HomeCollectionViewSubBannerCell.identifier),
                (HomeCollectionViewOneSecondMyFavoriteCell.self,
                 HomeCollectionViewOneSecondMyFavoriteCell.identifier)
            ]
        }
    }

}
