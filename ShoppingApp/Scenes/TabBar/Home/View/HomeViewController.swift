//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    private lazy var presenter = HomePresenter(
        viewController: self
    )

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.delegate = self

        let cellRegister = RegisterProvider.homeCollectionView.cellRegister
        cellRegister.forEach {
            collectionView.register(
                $0.cellClass,
                forCellWithReuseIdentifier: $0.identifier
            )
        }

        let supplementaryRegister = RegisterProvider.homeCollectionView.supplementaryRegister
        supplementaryRegister.forEach {
            collectionView.register(
                $0.viewClass,
                forSupplementaryViewOfKind: $0.kind,
                withReuseIdentifier: $0.identifier
            )
        }

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter.viewWillDisappear()
    }

}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter.didSelectItem(at: indexPath)
    }

}

extension HomeViewController: HomeViewProtocol {

    func configureNavigationBar() {
        let appNameBarButtonItem = UIBarButtonItem(
            title: BarButtonItem.appName.title,
            style: .plain,
            target: self,
            action: #selector(didTapAppNameBarButtonItem)
        )

        let searchBarButtonItem = UIBarButtonItem(
            image: BarButtonItem.search.image,
            style: .plain,
            target: self,
            action: #selector(didTapSearchBarButtonItem)
        )

        navigationItem.leftBarButtonItem = appNameBarButtonItem
        navigationItem.rightBarButtonItem = searchBarButtonItem
    }

    func configureTabBar() {
        tabBarController?.tabBar.isHidden = false
    }

    func configureHierarchy() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func pushToSearchViewController() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(
            searchViewController,
            animated: true
        )
    }

    func pushToDetailViewController(with goods: Goods?) {
        guard let goods = goods else {return}

        let detailViewController = DetailViewController(clothes: goods)
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func reloadCollectionView(with rawValue: Int) {
        collectionView.reloadSections(
            IndexSet(integer: rawValue)
        )
    }

}

// collectionView layout
private extension HomeViewController {

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let sectionLayoutKind = self?.presenter.sectionLayoutKind(at: sectionIndex)

            switch sectionLayoutKind {
            case .메인배너:
                return self?.createBannerSection(
                    heightDimension: .fractionalHeight(0.6),
                    isHeader: false,
                    isFooter: false
                )
            case .카테고리:
                return self?.createFiveColumGridSection()
            case .오늘의랭킹:
                return self?.createRankSection()
            case .오늘구매해야할제품:
                return self?.createTwoColumGridSection()
            case .이주의브랜드이슈:
                return self?.createThreeRowSection()
            case .지금눈에띄는후드티:
                return self?.createTwoColumGridSection()
            case .서브배너:
                return self?.createBannerSection(
                    heightDimension: .fractionalHeight(0.2),
                    isHeader: true,
                    isFooter: true
                )
            case .일초만에사로잡는나의취향:
                return self?.createTwoColumGridSection()
            case .none:
                fatalError("unknown sectionLayoutKind")
            }
        }

        return layout
    }

    func createBannerSection(
        heightDimension: NSCollectionLayoutDimension,
        isHeader: Bool,
        isFooter: Bool
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: heightDimension
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        if isHeader && isFooter {
            let sectionHeader = createSectionClearHeader()
            let sectionFooter = createSectionClearFooter()

            section.boundarySupplementaryItems = [
                sectionHeader,
                sectionFooter
            ]
        }

        return section
    }

    func createFiveColumGridSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 16.0

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

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

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        section.interGroupSpacing = spacing

        let sectionFooter = createSectionClearFooter()
        section.boundarySupplementaryItems = [sectionFooter]

        return section
    }

    func createTwoColumGridSection() -> NSCollectionLayoutSection {
        let contentsInset: CGFloat = 16.0
        let spacing: CGFloat = 16.0

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
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

        let sectionHeader = createSectionSectionNameHeader()
        let sectionFooter = createSectionMoreFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

    func createThreeRowSection() -> NSCollectionLayoutSection {
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

        let sectionHeader = createSectionSectionNameHeader()
        let sectionFooter = createSectionMoreFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

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

        let sectionHeader = createSectionSectionNameHeader()
        let sectionFooter = createSectionClearFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

    func createSectionClearHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.05)
        )

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return sectionHeader
    }

    func createSectionSectionNameHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return sectionHeader
    }

    func createSectionClearFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.05)
        )

        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        return sectionFooter
    }

    func createSectionMoreFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )

        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        return sectionFooter
    }

}

// UI Components action
private extension HomeViewController {

    @objc
    func didTapAppNameBarButtonItem() {
        presenter.didTapAppNameBarButtonItem()
    }

    @objc
    func didTapSearchBarButtonItem() {
        presenter.didTapSearchBarButtonItem()
    }

}
