//
//  StyleRecommendationViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import UIKit

final class StyleRecommendationViewController: UIViewController {
    private lazy var presenter = StyleRecommendationPresenter(viewController: self)

    private lazy var cartBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: BarButtonItem.cart.image,
            style: .plain,
            target: self,
            action: nil
        )

        return barButtonItem
    }()

    private lazy var searchBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: BarButtonItem.search.image,
            style: .plain,
            target: self,
            action: nil
        )

        return barButtonItem
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(
            self,
            action: #selector(didValueChangedRefreshControl),
            for: .valueChanged
        )

        return control
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.dataSource = presenter
        collectionView.delegate = presenter
        collectionView.refreshControl = refreshControl

        collectionView.register(
            StyleRecommendationCollectionViewCell.self,
            forCellWithReuseIdentifier: StyleRecommendationCollectionViewCell.identifier
        )

        collectionView.register(
            StyleRecommendationCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StyleRecommendationCollectionViewHeader.identifier
        )

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    enum SectionLayoutKind: Int {
        case 당신을위한추천
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }

            switch sectionLayoutKind {
            case .당신을위한추천:
                return self?.createTwoColumnSection()
            }
        }

        return layout
    }

    func createTwoColumnSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(8.0)
        group.contentInsets = .init(
            top: 0, leading: 8.0, bottom: 0, trailing: 8.0
        )

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.interGroupSpacing = 16.0

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

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

extension StyleRecommendationViewController: StyleRecommendationViewProtocol {

    func setupNavigationBar() {
        navigationItem.title = "스타일 추천"
        navigationItem.rightBarButtonItems = [
            cartBarButtonItem,
            searchBarButtonItem
        ]
    }

    func setupLayout() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

}

private extension StyleRecommendationViewController {

    @objc
    func didValueChangedRefreshControl() {
        presenter.didValueChangedRefreshControl()
    }

}
