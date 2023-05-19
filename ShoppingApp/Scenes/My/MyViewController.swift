//
//  MyViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/29.
//

import SnapKit
import UIKit

final class MyViewController: UIViewController {
    private lazy var presenter = MyPresenter(viewController: self)

    private lazy var accountBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(didTapAccountBarButtonItem)
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

        collectionView.register(
            MyCollectionViewPointCouponOrderDeliveryCell.self,
            forCellWithReuseIdentifier: MyCollectionViewPointCouponOrderDeliveryCell.identifier
        )
        collectionView.register(
            MyCollectionViewBannerCell.self,
            forCellWithReuseIdentifier: MyCollectionViewBannerCell.identifier
        )
        collectionView.register(
            MyCollectionViewMyShoppingCell.self,
            forCellWithReuseIdentifier: MyCollectionViewMyShoppingCell.identifier
        )
        collectionView.register(
            MyCollectionViewRecentlyViewedCell.self,
            forCellWithReuseIdentifier: MyCollectionViewRecentlyViewedCell.identifier
        )

        collectionView.register(
            MyCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MyCollectionViewHeader.identifier
        )
        collectionView.register(
            MyCollectionViewDetailHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MyCollectionViewDetailHeader.identifier
        )

        collectionView.register(
            MyCollectionViewFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MyCollectionViewFooter.identifier
        )

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillApper()
    }


    let sectionSpacing: CGFloat = 8.0
}

extension MyViewController: MyViewProtocol {

    func setupNavigationBar() {
        navigationItem.title = "seo9806"
        navigationItem.rightBarButtonItem = accountBarButtonItem
        navigationItem.backButtonTitle = ""
    }

    func setupLayout() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func pushToAccountViewController() {
        let accountViewController = AccountViewController()
        navigationController?.pushViewController(
            accountViewController,
            animated: true
        )
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func pushToRecentlyViewedViewController() {
        let recentlyViewedViewController = RecentlyViewedViewController()
        navigationController?.pushViewController(
            recentlyViewedViewController,
            animated: true
        )
    }

    enum SectionLayoutKind: Int {
        case 포인트_쿠폰_주문배송조회
        case 광고
        case MY쇼핑
        case 최근본상품
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }

            switch sectionLayoutKind {
            case .포인트_쿠폰_주문배송조회:
                return self?.createThreeColumnSection()
            case .광고:
                return self?.createBannerSection(
                    heightDimension: .fractionalHeight(0.1)
                )
            case .MY쇼핑:
                return self?.createTwoColumSection()
            case .최근본상품:
                return self?.createOneRowListSection()
            }
        }

        layout.register(
            MyDecorationView.self,
            forDecorationViewOfKind: MyDecorationView.identifier
        )


        return layout
    }

    // 포인트 + 쿠폰 + 주문/배송조회
    func createThreeColumnSection() -> NSCollectionLayoutSection {
        let itemWidth: CGFloat = 1.0 / 3.0

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemWidth),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        item.contentInsets = .init(
            top: 1.0,
            leading: 1.0,
            bottom: 0,
            trailing: 1.0
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.1)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let section = NSCollectionLayoutSection(
            group: group
        )

        let decoration = NSCollectionLayoutDecorationItem.background(
            elementKind: MyDecorationView.identifier
        )
        section.decorationItems = [decoration]

        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems = [sectionFooter]

        return section
    }

    func createBannerSection(
        heightDimension: NSCollectionLayoutDimension
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

        let decoration = NSCollectionLayoutDecorationItem.background(elementKind: MyDecorationView.identifier)

        section.decorationItems = [decoration]

        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems = [
            sectionFooter
        ]

        return section
    }

    func createTwoColumSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.07)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(1.0)

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.interGroupSpacing = 1.0
        section.contentInsets = .init(
            top: 1.0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )

        let decoration = NSCollectionLayoutDecorationItem.background(elementKind: MyDecorationView.identifier)

        section.decorationItems = [decoration]

        let sectionHeader = createSectionHeader()
        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

    func createOneRowListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalWidth(0.3)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = .init(
            top: 0, leading: 8.0, bottom: 0, trailing: 8.0
        )

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.orthogonalScrollingBehavior = .continuous

        let sectionHeader = createSectionHeader()
        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems = [
            sectionHeader,
            sectionFooter
        ]

        return section
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        // section header 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )

        // section header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return sectionHeader
    }

    func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(8.0)
        )

        // section footer layout
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionFooterSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        return sectionFooter
    }

}

private extension MyViewController {

    @objc
    func didTapAccountBarButtonItem() {
        presenter.didTapAccountBarButtonItem()
    }

}
