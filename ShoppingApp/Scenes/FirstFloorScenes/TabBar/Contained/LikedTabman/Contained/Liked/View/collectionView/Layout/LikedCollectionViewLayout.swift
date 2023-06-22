//
//  LikedCollectionViewLayout.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/23.
//

import UIKit

enum LikedCollectionViewLayout {
    case `default`

    /// layout 생성
    var createLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            guard let sectionLayoutKind = LikedCollectionViewSectionKind(
                rawValue: sectionIndex
            ) else {return nil}

            switch sectionLayoutKind {
            case .찜:
                return self.createLikedSection()
            }
        }

        return layout
    }
}

// Section
private extension LikedCollectionViewLayout {

    func createLikedSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 16.0

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.334),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.27)
        )

        let group: NSCollectionLayoutGroup
        if #available(iOS 16.0, *) {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 3
            )
        } else {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 3
            )
        }
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.interGroupSpacing = spacing
        section.contentInsets = .init(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )

        return section
    }

}
