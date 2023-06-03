//
//  HomePresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureTabBar()
    func configureHierarchy()
    func pushToSearchViewController()
    func pushToDetailViewController(with goods: Goods?)
    func reloadCollectionView()
    func reloadCollectionView(with rawValue: Int)
}

final class HomePresenter: NSObject {
    private let goodsSearchManager: ClothesSearchManagerProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtocl?

    private weak var viewController: HomeViewProtocol?

    private var goodsList: [HomeCollectionViewSectionKind: [Goods]] = [:]

    typealias RequestData = (request: String, section: HomeCollectionViewSectionKind)
    let requestDataList: [RequestData] = [
        ("자켓", .메인배너),
        ("남성 청바지", .오늘의랭킹),
        ("가방", .오늘구매해야할제품),
        ("양말", .이주의브랜드이슈),
        ("후드티", .지금눈에띄는후드티),
        ("장갑", .서브배너),
        ("가방", .일초만에사로잡는나의취향)
    ]

    typealias Category = (titleName: String, imageName: String)
    let categoryList: [Category] = [
        ("남성패션", "male"),
        ("여성패션", "female"),
        ("가디건", "cardigan"),
        ("셔츠", "shirt"),
        ("바지", "jeans"),
        ("스니커즈", "sneakers"),
        ("화장품", "cosmetics"),
        ("컴퓨터", "computer"),
        ("가구", "furniture"),
        ("스포츠", "sports")
    ]

    init(
        viewController: HomeViewProtocol?,
        goodsSearchManager: ClothesSearchManagerProtocol? = ClothesSearchManager(),
        userDefaultsManager: UserDefaultsManagerProtocl? = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.goodsSearchManager = goodsSearchManager
        self.userDefaultsManager = userDefaultsManager
    }

    func viewDidLoad() {
        viewController?.configureNavigationBar()
        viewController?.configureHierarchy()

        fetchData()
    }

    func viewWillAppear() {
        viewController?.configureTabBar()

        // Timer를 시작한다
        NotificationCenter.default.post(
            name: NSNotification.Name.startBannerTimer,
            object: nil
        )
    }

    func viewWillDisappear() {
        // Timer를 멈춘다
        NotificationCenter.default.post(
            name: NSNotification.Name.stopBannerTimer,
            object: nil
        )
    }

    func didTapAppNameBarButtonItem() {
        viewController?.reloadCollectionView()
    }

    func didTapSearchBarButtonItem() {
        viewController?.pushToSearchViewController()
    }

    func didSelectItem(at indexPath: IndexPath) {
        guard let section = HomeCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else {return}

        if section == .카테고리 {
            return
        }

        let goods = goodsList[section]?[indexPath.item]
        viewController?.pushToDetailViewController(with: goods)
    }

    func sectionLayoutKind(
        at sectionIndex: Int
    ) -> HomeCollectionViewSectionKind? {
        return HomeCollectionViewSectionKind(
            rawValue: sectionIndex
        )
    }

}

extension HomePresenter: UICollectionViewDataSource {

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return HomeCollectionViewSectionKind.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let section = HomeCollectionViewSectionKind(
            rawValue: section
        ) else { return 0 }

        switch section {
        case .메인배너: return 1
        case .카테고리: return categoryList.count
        default: return goodsList[section]?.count ?? 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = HomeCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else { return UICollectionViewCell() }

        switch section {
        case .메인배너:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewMainBannerCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewMainBannerCell

            let goods = goodsList[section] ?? []
            cell?.configure(with: goods, delegate: self)

            return cell ?? UICollectionViewCell()

        case .카테고리:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewCategoryCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewCategoryCell

            let category = categoryList[indexPath.item]
            cell?.configure(with: category)

            return cell ?? UICollectionViewCell()

        case .오늘의랭킹:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewRankCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewRankCell

            let clothes = goodsList[section]?[indexPath.item]
            cell?.configure(
                with: clothes,
                item: indexPath.item + 1
            )

            return cell ?? UICollectionViewCell()

        case .오늘구매해야할제품:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewBuyTodayCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewBuyTodayCell

            let clothes = goodsList[section]?[indexPath.item]
            cell?.configure(with: clothes)

            return cell ?? UICollectionViewCell()

        case .이주의브랜드이슈:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewBrandOfTheWeekCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewBrandOfTheWeekCell

            let clothes = goodsList[section]?[indexPath.item]
            cell?.configure(with: clothes)

            return cell ?? UICollectionViewCell()

        case .지금눈에띄는후드티:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewNowLookingCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewNowLookingCell

            let clothes = goodsList[section]?[indexPath.item]
            cell?.configure(with: clothes)

            return cell ?? UICollectionViewCell()

        case .서브배너:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewSubBannerCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewSubBannerCell

            let clothes = goodsList[section]?[indexPath.item]
            cell?.configure(with: clothes)

            return cell ?? UICollectionViewCell()

        case .일초만에사로잡는나의취향:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewOneSecondMyFavoriteCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewOneSecondMyFavoriteCell

            let clothes = goodsList[section]?[indexPath.item]
            cell?.configure(with: clothes)

            return cell ?? UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let section = HomeCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else { return UICollectionReusableView() }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch section {
            case .메인배너, .카테고리:
                return UICollectionReusableView()

            case .서브배너:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HomeCollectionViewClearHeader.identifier,
                    for: indexPath
                ) as? HomeCollectionViewClearHeader

                return headerView ?? UICollectionReusableView()

            default:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HomeCollectionViewSectionNameHeader.identifier,
                    for: indexPath
                ) as? HomeCollectionViewSectionNameHeader

                headerView?.configure(with: section.title)

                return headerView ?? UICollectionReusableView()
            }

        case UICollectionView.elementKindSectionFooter:
            switch section {
            case .메인배너:
                return UICollectionReusableView()

            case .카테고리, .오늘의랭킹, .서브배너:
                let clearFooterView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: HomeCollectionViewClearFooter.identifier,
                    for: indexPath
                ) as? HomeCollectionViewClearFooter

                return clearFooterView ?? UICollectionReusableView()

            default:
                let moreFooterView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: HomeCollectionViewMoreFooter.identifier,
                    for: indexPath
                ) as? HomeCollectionViewMoreFooter

                moreFooterView?.configure(
                    tag: section.rawValue,
                    delegate: self
                )

                return moreFooterView ?? UICollectionReusableView()
            }

        default:
            return UICollectionReusableView()
        }
    }

}

extension HomePresenter: HomeViewDelgate {

    func didTapMoreButton(_ sender: UIButton) {
        print("더보기~ \(sender.tag)")
    }

}

extension HomePresenter: HomeCollectionViewMainBannerCellDelegate {

    func mainBannerCellCollectionView(didSelectItemAt indexPath: IndexPath) {
        let goods = goodsList[.메인배너]?[indexPath.item]
        viewController?.pushToDetailViewController(with: goods)
    }

}

private extension HomePresenter {

    private func fetchData() {
        requestDataList.forEach { requestData in
            goodsSearchManager?.request(with: requestData.request) { [weak self] (results) in

                switch requestData.section {
                case .메인배너:
                    var newResults = results
                    newResults.insert(
                        newResults[newResults.count - 1],
                        at: 0
                    )
                    newResults.append(newResults[1])
                    self?.goodsList[requestData.section] = newResults

                default:
                    self?.goodsList[requestData.section] = results
                }

                self?.viewController?.reloadCollectionView(
                    with: requestData.section.rawValue
                )
            }
        }
    }

}
