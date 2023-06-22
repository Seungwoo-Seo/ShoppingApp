//
//  CategoryPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import UIKit

protocol CategoryViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureCollectionView()
    func configureHierarchy()
    func pushToMoreViewController(
        with request: String
    )
    func pushToSearchViewController()
    func presentPreparingToast(message: String)
    func tapBarIsHidden(_ isHidden: Bool)
}

final class CategoryPresenter: NSObject {
    private weak var viewController: CategoryViewProtocol!

    private var dataSource: UICollectionViewDiffableDataSource<
        CategoryCollectionViewSectionKind,
        CategoryItem
    >!

    init(
        viewController: CategoryViewProtocol!
    ) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController.configureNavigationBar()
        viewController.configureCollectionView()
        viewController.configureHierarchy()

        configureDataSource()
    }

    func viewWillAppear() {
        viewController.tapBarIsHidden(false)
    }

}

extension CategoryPresenter: CategoryCollectionViewHeaderDelegate {

    func didTapOutLineButton(_ sender: UIButton) {
        guard let section = dataSource.sectionIdentifier(
            for: sender.tag
        ) else {return}

        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<
            CategoryItem
        >()

        if sender.isSelected {
            var snapshot = NSDiffableDataSourceSnapshot<
                CategoryCollectionViewSectionKind,
                CategoryItem
            >()
            snapshot.appendSections(CategoryCollectionViewSectionKind.allCases)
            sectionSnapshot.deleteAll()
            dataSource.apply(
                sectionSnapshot,
                to: section,
                animatingDifferences: false
            )
        }

        else {
            NotificationCenter.default.post(
                name: Notification.Name.likeRadioButton,
                object: sender.tag,
                userInfo: nil
            )

            var snapshot = NSDiffableDataSourceSnapshot<
                CategoryCollectionViewSectionKind,
                CategoryItem
            >()
            snapshot.appendSections(CategoryCollectionViewSectionKind.allCases)
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

// view의 UICollectionViewDelegate extension
extension CategoryPresenter {

    func didSelectItem(
        at indexPath: IndexPath
    ) {
        let section = CategoryCollectionViewSectionKind(
            rawValue: indexPath.section
        )

        let category = section?.categorys[indexPath.item].category

        viewController.pushToMoreViewController(
            with: category!
        )
    }

}

// view의 private extension
extension CategoryPresenter {

    func didTapCartBarButtonItem() {
        viewController.presentPreparingToast(
            message: "준비중~"
        )
    }

    func didTapSearchBarButtonItem() {
        viewController.pushToSearchViewController()
    }

}

private extension CategoryPresenter {

    func configureDataSource() {
        // 헤더 등록 및 구성
        let headerRegistration = UICollectionView.SupplementaryRegistration<
            CategoryCollectionViewHeader
        >(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { (supplementaryView, elementKind, indexPath) in

            let section = CategoryCollectionViewSectionKind(
                rawValue: indexPath.section
            )

            switch section {
            case .none:
                fatalError("만들어 질 수 없는 섹션 헤더")
            default:
                let title = section?.title ?? ""
                let tag = indexPath.section

                supplementaryView.delegate = self
                supplementaryView.configure(
                    with: title,
                    tag: tag
                )
            }
        }

        // 셀 등록 및 구성
        let cellRegistration = UICollectionView.CellRegistration<
            CategoryCollectionViewCell,
            CategoryItem
        > { (cell, indexPath, itemIdentifier) in
            let category = itemIdentifier.category
            cell.configure(with: category)
        }

        guard let collectionView = (viewController as! CategoryViewController).collectionView
        else {return}

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

        applySnapshot()
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<
            CategoryCollectionViewSectionKind,
            CategoryItem
        >()
        snapshot.appendSections(CategoryCollectionViewSectionKind.allCases)
        dataSource.apply(
            snapshot,
            animatingDifferences: true
        )
    }

}
