//
//  RegisterProvider.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/24.
//

import UIKit

enum RegisterProvider {

    typealias CellRegister = (
        cellClass: AnyClass?,
        identifier: String
    )

    typealias SupplementaryRegister = (
        viewClass: AnyClass?,
        kind: String,
        identifier: String
    )

    /// HomeViewController의 CollectionView Cell
    case homeCollectionView
    /// AccountViewController의 TableView Cell
    case accountTableView
    /// AccountViewController의 TableView Header, Footer
    case accountTableViewHeaderFooter

    var cellRegister: [CellRegister] {
        switch self {
        case .homeCollectionView:
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

        case .accountTableView:
            return [
                (AccountTableViewCell.self,
                 AccountTableViewCell.identifier)
            ]

        case .accountTableViewHeaderFooter:
            return [
                (AccountTableViewHeader.self,
                 AccountTableViewHeader.identifier),
                (AccountTableViewFooter.self,
                 AccountTableViewFooter.identifier)
            ]
        }
    }

    var supplementaryRegister: [SupplementaryRegister] {
        switch self {
        case .homeCollectionView:
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
        case .accountTableView:
            return []
        case .accountTableViewHeaderFooter:
            return []
        }
    }

}
