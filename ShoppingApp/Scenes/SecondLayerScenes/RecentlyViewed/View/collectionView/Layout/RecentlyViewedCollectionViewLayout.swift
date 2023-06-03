//
//  RecentlyViewedCollectionViewLayout.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/24.
//

import UIKit

enum RecentlyViewedCollectionViewLayout {
    case `default`

    /// layout 생성
    var createLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = RecentlyViewedCollectionViewSectionKind(
                rawValue: sectionIndex
            ) else { return nil }

            switch sectionLayoutKind {
            case .최근_본_상품:
                return self.createRecentlyViewedSection()
            }
        }

        return layout
    }

}

// Section
private extension RecentlyViewedCollectionViewLayout {

    // 최근 본 상품
    func createRecentlyViewedSection() -> NSCollectionLayoutSection {
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
