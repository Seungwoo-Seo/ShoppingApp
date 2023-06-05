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

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

extension StyleRecommendationViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

    }

}

extension StyleRecommendationViewController: StyleRecommendationViewProtocol {

    func configureNavigationBar() {
        let cartBarButtonItem = UIBarButtonItem(
            image: BarButtonItem.cart.image,
            style: .plain,
            target: self,
            action: #selector(didTapCartBarButtonItem)
        )

        let searchBarButtonItem = UIBarButtonItem(
            image: BarButtonItem.search.image,
            style: .plain,
            target: self,
            action: #selector(didTapSearchBarButtonItem)
        )

        navigationItem.title = "스타일 추천"
        navigationItem.rightBarButtonItems = [
            cartBarButtonItem,
            searchBarButtonItem
        ]
    }

    func configureCollectionView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(didValueChangedRefreshControl),
            for: .valueChanged
        )

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.dataSource = presenter
        collectionView.prefetchDataSource = presenter
        collectionView.delegate = self
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
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in

            return self?.presenter.createLayout(
                sectionIndex: sectionIndex,
                layoutEnvironment: layoutEnvironment
            )
        }

        return layout
    }

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

    func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }

}

private extension StyleRecommendationViewController {

    @objc
    func didTapCartBarButtonItem() {

    }

    @objc
    func didTapSearchBarButtonItem() {

    }

    @objc
    func didValueChangedRefreshControl() {
        presenter.didValueChangedRefreshControl()
    }

}
