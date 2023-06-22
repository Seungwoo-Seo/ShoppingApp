//
//  HomeCollectionViewRegister.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/22.
//

import UIKit

enum HomeCollectionViewRegister: Register {
    case `default`

    var cellRegister: [CellRegister] {
        return [
            (HomeCollectionViewMainBannerCell.self,
             HomeCollectionViewMainBannerCell.identifier),
            (HomeCollectionViewCategoryCell.self,
             HomeCollectionViewCategoryCell.identifier),
            (HomeCollectionViewBuyTodayCell.self,
             HomeCollectionViewBuyTodayCell.identifier),
            (HomeCollectionViewBrandOfTheWeekCell.self,
             HomeCollectionViewBrandOfTheWeekCell.identifier),
            (HomeCollectionViewRankCell.self,
             HomeCollectionViewRankCell.identifier),
            (HomeCollectionViewNowLookingCell.self,
             HomeCollectionViewNowLookingCell.identifier),
            (HomeCollectionViewSubBannerCell.self,
             HomeCollectionViewSubBannerCell.identifier),
            (HomeCollectionViewOneSecondMyFavoriteCell.self,
             HomeCollectionViewOneSecondMyFavoriteCell.identifier)
        ]
    }

    var supplementaryRegister: [SupplementaryRegister] {
        return [
            // header
            (HomeCollectionViewClearHeader.self,
             UICollectionView.elementKindSectionHeader,
             HomeCollectionViewClearHeader.identifier),
            (HomeCollectionViewSectionNameHeader.self,
             UICollectionView.elementKindSectionHeader,
             HomeCollectionViewSectionNameHeader.identifier),

            // footer
            (HomeCollectionViewClearFooter.self,
             UICollectionView.elementKindSectionFooter,
             HomeCollectionViewClearFooter.identifier),
            (HomeCollectionViewMoreFooter.self,
             UICollectionView.elementKindSectionFooter,
             HomeCollectionViewMoreFooter.identifier)
        ]
    }

}
