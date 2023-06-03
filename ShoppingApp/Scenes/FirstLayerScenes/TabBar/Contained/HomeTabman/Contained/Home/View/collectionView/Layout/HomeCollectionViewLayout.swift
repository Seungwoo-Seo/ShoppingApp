//
//  HomeCollectionViewLayout.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/19.
//

import UIKit

/// HomeViewController에 collectionView의  layout
enum HomeCollectionViewLayout {
    case `default`

    /// layout 생성
    var createLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in

            let section = HomeCollectionViewSectionKind(
                rawValue: sectionIndex
            )

            switch section {
            case .메인배너:
                return self.createMainBannerSection()
            case .카테고리:
                return self.createCategorySection()
            case .오늘의랭킹:
                return self.createRankSection()
            case .오늘구매해야할제품:
                return self.createTwoColumGridSection()
            case .이주의브랜드이슈:
                return self.createBrandOfTheWeekSection()
            case .지금눈에띄는후드티:
                return self.createTwoColumGridSection()
            case .서브배너:
                return self.createSubBannerSection()
            case .일초만에사로잡는나의취향:
                return self.createTwoColumGridSection()
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
private extension HomeCollectionViewLayout {

    /// 메인배너 섹션 layout.
    /// 하나의 열에 여러 컬럼을 가진 형태
    func createMainBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.65)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

    /// 카테고리 섹션 layout.
    /// 다섯개의 컬럼을 가진 그리드 형태
    func createCategorySection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 16.0

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2)
        )

        let group: NSCollectionLayoutGroup
        if #available(iOS 16.0, *) {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 5
            )
        } else {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 5
            )
        }
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        section.interGroupSpacing = spacing

        let sectionFooter = createClearFooter()
        section.boundarySupplementaryItems = [sectionFooter]

        return section
    }

    /// 오늘의랭킹 섹션 layout
    /// 하나의 열에 여러 컬럼을 가진 형태
    func createRankSection() -> NSCollectionLayoutSection {
        let contentsInset: CGFloat = 8.0

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(0.4)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = .init(
            top: 0,
            leading: contentsInset,
            bottom: 0,
            trailing: contentsInset
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        let sectionHeader = createSectionNameHeader()
        let sectionFooter = createClearFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

    /// 서브배너 섹션 layout.
    /// 하나의 열에 여러 컬럼을 가진 형태
    func createSubBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.2)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        let sectionHeader = createClearHeader()
        let sectionFooter = createClearFooter()

        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

    /// 오늘구매해야할제품, 지금눈에띄는후드티, 일초만에사로잡는나의취향
    /// 섹션 layout
    /// 두개의 컬럼을 가진 그리드 형태
    func createTwoColumGridSection() -> NSCollectionLayoutSection {
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
            heightDimension: .fractionalHeight(0.4)
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

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: contentsInset,
            trailing: 0
        )

        let sectionHeader = createSectionNameHeader()
        let sectionFooter = createMoreFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

    /// 이주의브랜드이슈 섹션 layout
    /// 하나의 컬럼에 3개의 열이 있는 형태
    func createBrandOfTheWeekSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let contentsInset: CGFloat = 16.0
        item.contentInsets = .init(
            top: 0,
            leading: contentsInset,
            bottom: contentsInset,
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

        let sectionHeader = createSectionNameHeader()
        let sectionFooter = createMoreFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

}

// Supplementary
private extension HomeCollectionViewLayout {

    /// 여백용 header
    func createClearHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.05)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return header
    }

    /// sectionName용 header
    func createSectionNameHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return header
    }

    /// 여백용 footer
    func createClearFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.05)
        )

        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        return footer
    }

    /// more용 footer
    func createMoreFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )

        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        return footer
    }

}
