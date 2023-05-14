//
//  HomeCollectionViewLayout.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/26.
//

import UIKit

final class HomeCollectionViewLayout: CollectionViewLayout {

    enum SectionLayoutKind: Int {
        case 광고
        case 카테고리
        case 오늘의랭킹
        case 오늘구매해야할아우터
        case 이주의브랜드이슈
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }

            switch sectionLayoutKind {
            case .광고:
                return self?.createRankSection()
//                return self?.createOneRowListSection(
//                    isHeader: true,
//                    heightDimension: .fractionalHeight(0.6)
//                )
            case .카테고리:
                return self?.createRankSection()
//                return self?.createFiveColumnGridSection(
//                    isHeader: false
//                )
            case .오늘의랭킹:
                return self?.createRankSection()

            case .오늘구매해야할아우터:
                return self?.createRankSection()
//                return self?.createTwoColumnGridSection(
//                    isHeader: true
//                )
            case .이주의브랜드이슈:
                return self?.createRankSection()
//                return self?.createTwoColumnGridSection(
//                    isHeader: true
//                )
            }
        }

        return layout
    }

    override func createOneRowListSection(isHeader: Bool, heightDimension: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
        super.createOneRowListSection(isHeader: isHeader, heightDimension: heightDimension)
    }

    override func createFiveColumnGridSection(isHeader: Bool) -> NSCollectionLayoutSection {
        super.createFiveColumnGridSection(isHeader: isHeader)
    }

    override func createTwoColumnGridSection(isHeader: Bool) -> NSCollectionLayoutSection {
        super.createTwoColumnGridSection(isHeader: isHeader)
    }

    override func createThreeRowListSection(isHeader: Bool) -> NSCollectionLayoutSection {
        super.createThreeRowListSection(isHeader: isHeader)
    }

    func createRankSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(0.9)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(
            top: 10,
            leading: 5,
            bottom: 0,
            trailing: 5
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .estimated(200)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(
            top: 0,
            leading: 5,
            bottom: 16.0,
            trailing: 5
        )

//        let sectionHeader = createSectionHeader()
//        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

}
