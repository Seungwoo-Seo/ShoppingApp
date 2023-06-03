//
//  MyCollectionViewLayout.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/23.
//

import UIKit

enum MyCollectionViewLayout {
    case `default`

    /// layout 생성
    var createLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = MyCollectionViewSectionKind(
                rawValue: sectionIndex
            ) else { return nil }

            switch sectionLayoutKind {
            case .포인트_쿠폰_주문배송조회:
                return self.createPointCouponOrderDeliverySection()
            case .광고:
                return self.createBannerSection()
            case .MY쇼핑:
                return self.createMyShoppingSection()
            case .최근본상품:
                return self.createRecentlyViewedSection()
            }
        }

        layout.register(
            MyCollectionViewDecoration.self,
            forDecorationViewOfKind: MyCollectionViewDecoration.identifier
        )


        return layout
    }
}

// Section
private extension MyCollectionViewLayout {

    // 포인트 + 쿠폰 + 주문/배송조회
    func createPointCouponOrderDeliverySection() -> NSCollectionLayoutSection {
        let itemWidth: CGFloat = 1.0 / 3.0

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemWidth),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        item.contentInsets = .init(
            top: 1.0,
            leading: 1.0,
            bottom: 0,
            trailing: 1.0
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.1)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let section = NSCollectionLayoutSection(
            group: group
        )

        let decoration = NSCollectionLayoutDecorationItem.background(
            elementKind: MyCollectionViewDecoration.identifier
        )
        section.decorationItems = [decoration]

        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems = [sectionFooter]

        return section
    }

    func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.1)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        let decoration = NSCollectionLayoutDecorationItem.background(elementKind: MyCollectionViewDecoration.identifier)

        section.decorationItems = [decoration]

        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems = [
            sectionFooter
        ]

        return section
    }

    func createMyShoppingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.1)
        )

        let group: NSCollectionLayoutGroup
        if #available(iOS 16.0, *) {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 4
            )
        } else {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 4
            )
        }
        group.interItemSpacing = .fixed(1.0)

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 1.0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        section.interGroupSpacing = 1.0

        let decoration = NSCollectionLayoutDecorationItem.background(elementKind: MyCollectionViewDecoration.identifier)

        section.decorationItems = [decoration]

        let sectionHeader = createSectionHeader()
        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

    func createRecentlyViewedSection() -> NSCollectionLayoutSection {
        let groupInset: CGFloat = 8.0

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalWidth(0.3)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = .init(
            top: groupInset/2,
            leading: groupInset,
            bottom: groupInset,
            trailing: groupInset/2
        )

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.orthogonalScrollingBehavior = .continuous

        let sectionHeader = createSectionHeader()
        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

}

// Supplementary
private extension MyCollectionViewLayout {

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        // section header 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )

        // section header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return sectionHeader
    }

    func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(8.0)
        )

        // section footer layout
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionFooterSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        return sectionFooter
    }
}
