//
//  MoreCollectionViewLayout.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/24.
//

import UIKit

enum MoreCollectionViewLayout {
    case `default`

    /// layout 생성
    var createLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let section = MoreCollectionViewSectionKind(
                rawValue: sectionIndex
            ) else {return nil}

            switch section {
            case .더보기:
                return self.createMoreSection()
            }
        }

        return layout
    }

}

// Section
private extension MoreCollectionViewLayout {

    /// 더보기 섹션
    func createMoreSection() -> NSCollectionLayoutSection {
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

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

}

// Supplementary
private extension MoreCollectionViewLayout {

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
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
