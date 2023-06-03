//
//  CategoryCollectioinViewLayout.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/22.
//

import UIKit

/// CategoryViewController에 collectionView의  layout
enum CategoryCollectioinViewLayout {
    case `default`

    /// layout 생성
    var createLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            let section = CategoryCollectionViewSectionKind(
                rawValue: sectionIndex
            )

            switch section {
            default: return self.createListSection()
            }
        }

        layout.register(
            CategoryCollectionViewDecorationView.self,
            forDecorationViewOfKind: CategoryCollectionViewDecorationView.identifier
        )

        return layout
    }
}

// Section
private extension CategoryCollectioinViewLayout {

    func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44.0)
        )

        let group: NSCollectionLayoutGroup
        if #available(iOS 16.0, *) {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 2
            )
        } else {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 2
            )
        }
        group.interItemSpacing = .fixed(4.0)
        group.contentInsets = .init(
            top: 0,
            leading: 32.0,
            bottom: 0,
            trailing: 32.0
        )

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.contentInsets = .init(
            top: 0.0,
            leading: 0,
            bottom: 1.0,
            trailing: 0
        )

        let decoration = NSCollectionLayoutDecorationItem.background(
            elementKind: CategoryCollectionViewDecorationView.identifier
        )
        section.decorationItems = [decoration]

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

}

// Supplementary
private extension CategoryCollectioinViewLayout {

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.1)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return header
    }

}


