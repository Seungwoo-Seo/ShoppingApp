//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    private lazy var presenter = HomePresenter(viewController: self)

    private lazy var appNameBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "쇼핑~",
            style: .plain,
            target: self,
            action: #selector(didTapAppNameBarButtonItem)
        )

        return barButtonItem
    }()

    private lazy var searchBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didTapSearchBarButtonItem)
        )

        return barButtonItem
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.delegate = presenter
        collectionView.dataSource = presenter
        collectionView.backgroundColor = .white

        let registers = CellProvider.homeCollectionView.registers
        registers.forEach {
            collectionView.register(
                $0.cellClass,
                forCellWithReuseIdentifier: $0.identifier
            )
        }

        collectionView.register(
            HomeCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeCollectionViewHeader.identifier
        )

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

extension HomeViewController: HomeViewProtocol {

    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = appNameBarButtonItem
        navigationItem.rightBarButtonItem = searchBarButtonItem
    }

    func setupTabBar() {
        tabBarController?.tabBar.isHidden = false
    }

    func setupLayout() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func presentToSearchViewController() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(
            searchViewController,
            animated: true
        )
    }

    func presentToDetailViewController(with clothes: Clothes) {
        let detailViewController = DetailViewController(clothes: clothes)
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    enum SectionLayoutKind: Int {
        case 메인배너
        case 카테고리
        case 오늘의랭킹
        case 오늘구매해야할제품
        case 이주의브랜드이슈
        case 지금눈에띄는후드티
        case 서브배너
        case 일초만에사로잡는나의취향

    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }

            switch sectionLayoutKind {
            case .메인배너:
                return self?.createMainSection(heightDimension: .fractionalHeight(0.6))
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
                return self?.createMainSection(heightDimension: .fractionalHeight(0.2))
            case .일초만에사로잡는나의취향:
                return self?.createTwoColumGridSection()
            }
        }

        return layout
    }

    func createMainSection(heightDimension: NSCollectionLayoutDimension) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

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

        return section
    }

    // Grid 형태
    func createFiveColumGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        let contentsInset: CGFloat = 16.0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: contentsInset,
            leading: contentsInset,
            bottom: contentsInset,
            trailing: contentsInset
        )

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

        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

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

        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

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

        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        // section header 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )

        // sectio header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return sectionHeader
    }

}

private extension HomeViewController {

    @objc func didTapAppNameBarButtonItem() {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }

    @objc func didTapSearchBarButtonItem() {
        presenter.didTapSearchBarButtonItem()
    }

}
