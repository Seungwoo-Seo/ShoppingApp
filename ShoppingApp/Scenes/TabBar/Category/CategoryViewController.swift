//
//  CategoryViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import UIKit

final class CategoryViewController: UIViewController {
    private lazy var presenter = CategoryPresenter(
        viewController: self,
        collectionView: collectionView
    )

    private lazy var cartBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: BarButtonItem.cart.image,
            style: .plain,
            target: self,
            action: #selector(didTapCartBarButtonItem)
        )

        return barButtonItem
    }()

    private lazy var searchBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: BarButtonItem.search.image,
            style: .plain,
            target: self,
            action: #selector(didTapSearchBarButtonItem)
        )

        return barButtonItem
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

extension CategoryViewController {

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionLayout, layoutEnvironment in
            return self.createListSection()
        }

        layout.register(
            CategoryCollectionViewDecorationView.self,
            forDecorationViewOfKind: CategoryCollectionViewDecorationView.identifier
        )

        return layout
    }

    private func createListSection() -> NSCollectionLayoutSection {
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
            top: 0.0, leading: 0, bottom: 1.0, trailing: 0)

        let decoration = NSCollectionLayoutDecorationItem.background(
            elementKind: CategoryCollectionViewDecorationView.identifier
        )
        section.decorationItems = [decoration]

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
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

extension CategoryViewController: CategoryViewProtocol {

    func configureNavigationBar() {
        navigationItem.title = "카테고리"
        navigationItem.rightBarButtonItems = [
            cartBarButtonItem,
            searchBarButtonItem
        ]
    }

    func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8.0)
            make.leading.equalToSuperview().inset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
    }

}

private extension CategoryViewController {

    @objc
    func didTapCartBarButtonItem() {

    }

    @objc
    func didTapSearchBarButtonItem() {

    }

}
