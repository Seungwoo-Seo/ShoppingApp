//
//  CategoryPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import UIKit

enum Section: Int, CaseIterable {
    case 브랜드
    case 쇼핑몰
    case 럭셔리
    case 스포츠
    case 디지털
    case 라이프

    var description: String {
        switch self {
        case .브랜드: return "브랜드"
        case .쇼핑몰: return "쇼핑몰"
        case .럭셔리: return "럭셔리"
        case .스포츠: return "스포츠"
        case .디지털: return "디지털"
        case .라이프: return "라이프"
        }
    }

    var categorys: [ItemIdentifier] {
        switch self {
        case .브랜드:
            return [
                ItemIdentifier(category: "아우터"),
                ItemIdentifier(category: "상의"),
                ItemIdentifier(category: "셔츠"),
                ItemIdentifier(category: "바지"),
                ItemIdentifier(category: "신발"),
                ItemIdentifier(category: "시계"),
                ItemIdentifier(category: "모자"),
                ItemIdentifier(category: "아이웨어"),
                ItemIdentifier(category: "잡화"),
                ItemIdentifier(category: "가방"),
                ItemIdentifier(category: "언더웨어")
            ]
        case .쇼핑몰:
            return [
                ItemIdentifier(category: "아우터"),
                ItemIdentifier(category: "상의"),
                ItemIdentifier(category: "셔츠"),
                ItemIdentifier(category: "바지"),
                ItemIdentifier(category: "신발"),
                ItemIdentifier(category: "시계"),
                ItemIdentifier(category: "모자"),
                ItemIdentifier(category: "아이웨어"),
                ItemIdentifier(category: "잡화"),
                ItemIdentifier(category: "가방"),
                ItemIdentifier(category: "빅사이즈")
            ]
        case .럭셔리:
            return [
                ItemIdentifier(category: "상의"),
                ItemIdentifier(category: "니트"),
                ItemIdentifier(category: "아우터"),
                ItemIdentifier(category: "셔츠"),
                ItemIdentifier(category: "바지"),
                ItemIdentifier(category: "언더웨어"),
                ItemIdentifier(category: "신발"),
                ItemIdentifier(category: "가방"),
                ItemIdentifier(category: "잡화")
            ]
        case .스포츠:
            return [
                ItemIdentifier(category: "패션"),
                ItemIdentifier(category: "아웃도어"),
                ItemIdentifier(category: "헬스"),
                ItemIdentifier(category: "골프"),
                ItemIdentifier(category: "용품"),
                ItemIdentifier(category: "기타")
            ]
        case .디지털:
            return [
                ItemIdentifier(category: "컴퓨터/모바일"),
                ItemIdentifier(category: "사운드"),
                ItemIdentifier(category: "홈"),
                ItemIdentifier(category: "게임"),
                ItemIdentifier(category: "모빌리티"),
                ItemIdentifier(category: "포토"),
                ItemIdentifier(category: "악세서리"),
                ItemIdentifier(category: "기타")
            ]
        case .라이프:
            return [
                ItemIdentifier(category: "캠핑"),
                ItemIdentifier(category: "그루밍"),
                ItemIdentifier(category: "자동차"),
                ItemIdentifier(category: "생활용품"),
                ItemIdentifier(category: "홈데코"),
                ItemIdentifier(category: "기타")
            ]
        }
    }
}

struct ItemIdentifier: Hashable {
    let category: String
    private let id = UUID()
}

protocol CategoryViewProtocol: AnyObject {
    func configureHierarchy()
    func configureNavigationBar()
}

final class CategoryPresenter: NSObject {
    private weak var viewController: CategoryViewProtocol?
    private weak var collectionView: UICollectionView!

    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemIdentifier>!

    init(
        viewController: CategoryViewProtocol?,
        collectionView: UICollectionView?
    ) {
        self.viewController = viewController
        self.collectionView = collectionView
    }

    func viewDidLoad() {
        viewController?.configureNavigationBar()
        viewController?.configureHierarchy()
        configureDataSource()
    }

}

extension CategoryPresenter: CategoryCollectionViewHeaderDelegate {

    func didTapOutLineButton(_ sender: UIButton) {
        let section: Section! = dataSource.sectionIdentifier(for: sender.tag)
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ItemIdentifier>()

        if sender.isSelected {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ItemIdentifier>()
            snapshot.appendSections(Section.allCases)
            sectionSnapshot.deleteAll()
            dataSource.apply(
                sectionSnapshot,
                to: section,
                animatingDifferences: false
            )

        } else {
            NotificationCenter.default.post(
                name: Notification.Name.likeRadioButton,
                object: sender.tag,
                userInfo: nil
            )

            var snapshot = NSDiffableDataSourceSnapshot<Section, ItemIdentifier>()
            snapshot.appendSections(Section.allCases)
            dataSource.apply(
                snapshot,
                animatingDifferences: false
            )

            let items = section.categorys
            sectionSnapshot.append(items)
            dataSource.apply(
                sectionSnapshot,
                to: section,
                animatingDifferences: true
            )
        }

        sender.toggle()
    }

    func didValueChangeOutLineButton(
        _ notification: Notification,
        outLineButton: UIButton
    ) {
        let getValue = notification.object as! Int

        if getValue != outLineButton.tag && outLineButton.isSelected {
            outLineButton.toggle()
        }
    }

}

extension CategoryPresenter {

    func configureDataSource() {
        // 헤더 등록 및 구성
        let headerRegistration = UICollectionView.SupplementaryRegistration<CategoryCollectionViewHeader>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] supplementaryView, elementKind, indexPath in
            guard let section = Section(
                rawValue: indexPath.section
            ) else {return}

            let category = section.description

            supplementaryView.backgroundColor = .systemBackground
            supplementaryView.delegate = self
            supplementaryView.configure(with: category, tag: indexPath.section)
        }

        // 셀 등록 및 구성
        let cellRegistration = UICollectionView.CellRegistration<CategoryCollectionViewCell, ItemIdentifier> { cell, indexPath, itemIdentifier in
            guard let section = Section(
                rawValue: indexPath.section
            ) else {return}

            let item = section.categorys[indexPath.item]
            cell.configure(with: item.category)
        }

        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemIdentifier>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(
            snapshot,
            animatingDifferences: true
        )
    }

}
