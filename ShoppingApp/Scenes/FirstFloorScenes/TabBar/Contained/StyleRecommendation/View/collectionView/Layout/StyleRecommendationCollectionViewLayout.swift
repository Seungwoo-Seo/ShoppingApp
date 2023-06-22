//
//  StyleRecommendationCollectionViewLayout.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/21.
//

import UIKit

/// StyleRecommendationViewController의 collectionView의  layout
enum StyleRecommendationCollectionViewLayout {
    case `default`

    /// layout 생성
    var createLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in

            let section = StyleRecommendationCollectionViewSectionKind(
                rawValue: sectionIndex
            )

            switch section {
            case .당신을위한추천:
                return self.createTwoColumnSection()
            case .none:
                fatalError(
                    "레이아웃을 설정할 수 없는 섹션입니다."
                )
            }
        }

        return layout
    }

}

// Section
private extension StyleRecommendationCollectionViewLayout {

    /// 당신을위한추천 섹션 layout
    /// 두 개의 컬럼을 가진 그리드 형태
    func createTwoColumnSection() -> NSCollectionLayoutSection {
        let contentsInset: CGFloat = 16.0
        let spacing: CGFloat = 16.0

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.35)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(spacing)
        group.contentInsets = .init(
            top: 0,
            leading: contentsInset,
            bottom: 0,
            trailing: contentsInset
        )

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.interGroupSpacing = 16.0

        let sectionHeader = createSectionNameHeader()
        section.boundarySupplementaryItems = [
            sectionHeader
        ]

        return section
    }

}

// Supplementary
private extension StyleRecommendationCollectionViewLayout {

    /// sectionName용 header
    func createSectionNameHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return header
    }

}
