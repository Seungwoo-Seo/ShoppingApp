//
//  CollectionViewLayout.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/26.
//

import UIKit

class CollectionViewLayout {

    func createOneRowListSection(
        isHeader: Bool,
        heightDimension: NSCollectionLayoutDimension
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: heightDimension
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        if isHeader {
            let sectionHeader = createSectionHeader()
            section.boundarySupplementaryItems = [sectionHeader]
        }

        return section
    }

    func createTwoColumnGridSection(
        isHeader: Bool
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.4)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )

        let spacing: CGFloat = 16.0
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing

        let contentsInset: CGFloat = 16.0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: contentsInset,
            bottom: contentsInset,
            trailing: contentsInset
        )

        if isHeader {
            let sectionHeader = createSectionHeader()
            section.boundarySupplementaryItems = [sectionHeader]
        }

        return section
    }

    func createFiveColumnGridSection(
        isHeader: Bool
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        let contentsInset: CGFloat = 16.0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: contentsInset,
            leading: contentsInset,
            bottom: contentsInset,
            trailing: contentsInset
        )

        if isHeader {
            let sectionHeader = createSectionHeader()
            section.boundarySupplementaryItems = [sectionHeader]
        }

        return section
    }

    func createThreeRowListSection(
        isHeader: Bool
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let contentsInset: CGFloat = 16.0
        item.contentInsets = .init(
            top: 0,
            leading: contentsInset,
            bottom: 0,
            trailing: contentsInset
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.6)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let spacing: CGFloat = 16.0
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: contentsInset,
            trailing: 0
        )
        section.orthogonalScrollingBehavior = .groupPaging

        if isHeader {
            let sectionHeader = createSectionHeader()
            section.boundarySupplementaryItems = [sectionHeader]
        }

        return section
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        // section header 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )

        // sectio header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return sectionHeader
    }


}
