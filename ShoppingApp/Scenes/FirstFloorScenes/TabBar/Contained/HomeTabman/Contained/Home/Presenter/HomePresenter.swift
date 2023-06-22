//
//  HomePresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import Foundation
import UIKit

protocol HomeViewProtocol: AnyObject {
    func configureCollectionView()
    func configureHierarchy()
    func addNotification()
    func removeNotification()
    func pushToWebViewController(
        with goods: Goods
    )
    func pushToMoreViewController(
        with request: String
    )
    func reloadCollectionView()
    func reloadCollectionView(
        with rawValue: Int
    )
    func display(
        to view: UIView,
        goodsList: [Goods]
    )
    func presentErrorToast(message: String)
}

final class HomePresenter: NSObject {
    private weak var viewController: HomeViewProtocol!

    // apis
    private let goodsSearchManager: GoodsSearchManagerProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocl
    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol

    /// 요청할 데이터와 해당 데이터를 사용할 섹션
    private typealias RequestData = (
        request: String,
        section: HomeCollectionViewSectionKind
    )
    private let requestDataList: [RequestData] = [
        ("자켓", .메인배너),
        ("남성 청바지", .오늘의랭킹),
        ("가방", .오늘구매해야할제품),
        ("양말", .이주의브랜드이슈),
        ("후드티", .지금눈에띄는후드티),
        ("티셔츠", .일초만에사로잡는나의취향)
    ]

    /// 카테고리 섹션의 데이터를 제외한 모든 섹션에 대한 데이터
    private var goodsDic: [HomeCollectionViewSectionKind: [Goods]] = [:]

    /// 카테고리 섹션에 사용할 title과 이미지
    private typealias CategoryData = (
        title: String,
        imageName: String
    )
    private let categoryList: [CategoryData] = [
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

    private var likedGoodsList: Set<Goods> = Set<Goods>()

    init(
        viewController: HomeViewProtocol!,
        goodsSearchManager: GoodsSearchManagerProtocol = GoodsSearchManager(),
        userDefaultsManager: UserDefaultsManagerProtocl = UserDefaultsManager(),
        firebaseAuthManager: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared,
        firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol = FirebaseRealtimeDatabaseManager.shared
    ) {
        self.viewController = viewController
        self.goodsSearchManager = goodsSearchManager
        self.userDefaultsManager = userDefaultsManager
        self.firebaseAuthManager = firebaseAuthManager
        self.firebaseRealtimeDatabaseManager = firebaseRealtimeDatabaseManager
    }

    // view의 viewDidLoad에서 호출
    func viewDidLoad() {
        viewController?.configureCollectionView()
        viewController?.configureHierarchy()

        fetchData()
    }

    // view의 viewWillAppear에서 호출
    func viewWillAppear() {
        viewController.addNotification()
        firebaseAuthManager.addStateDidChangeListener { [weak self] (user) in
            if let user = user {
                // 유저가 있으면 찜을 확인해보자
                self?.firebaseRealtimeDatabaseManager.getLikeds(uid: user.uid) { goodsList in
                    if !goodsList.isEmpty {
                        self?.likedGoodsList = Set(goodsList)
                    } else {
                        self?.likedGoodsList = []
                    }

                    self?.viewController.reloadCollectionView()
                }
            } else {
                self?.likedGoodsList = []
                self?.viewController.reloadCollectionView()
            }
        }
    }

    // view의 viewWillDisappear에서 호출
    func viewWillDisappear() {
        viewController.removeNotification()

        firebaseAuthManager.removeStateDidChangeListener()
    }

}

// UICollectionViewDataSource
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
        case .서브배너: return 1
        default: return goodsDic[section]?.count ?? 0
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

            let goodsList = goodsDic[section] ?? []

            viewController.display(
                to: cell!,
                goodsList: goodsList
            )

            return cell ?? UICollectionViewCell()

        case .카테고리:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewCategoryCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewCategoryCell

            let category = categoryList[indexPath.item]
            let title = category.title
            let imageName = category.imageName
            cell?.configure(
                with: title,
                imageName: imageName
            )

            return cell ?? UICollectionViewCell()

        case .오늘의랭킹:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewRankCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewRankCell

            let goods = goodsDic[section]![indexPath.item]
            cell?.configure(
                with: goods,
                rank: indexPath.item + 1
            )

            return cell ?? UICollectionViewCell()

        case .오늘구매해야할제품:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewBuyTodayCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewBuyTodayCell

            let goods = goodsDic[section]![indexPath.item]

            cell?.configure(
                with: goods,
                likedButtonDelegate: viewController as! HomeViewController
            )

            return cell ?? UICollectionViewCell()

        case .이주의브랜드이슈:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewBrandOfTheWeekCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewBrandOfTheWeekCell

            let goods = goodsDic[section]![indexPath.item]
            cell?.configure(with: goods)

            return cell ?? UICollectionViewCell()

        case .지금눈에띄는후드티:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewNowLookingCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewNowLookingCell

            let goods = goodsDic[section]![indexPath.item]
            cell?.configure(
                with: goods,
                likedButtonDelegate: viewController as! HomeViewController
            )

            return cell ?? UICollectionViewCell()

        case .서브배너:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewSubBannerCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewSubBannerCell

            return cell ?? UICollectionViewCell()

        case .일초만에사로잡는나의취향:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewOneSecondMyFavoriteCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewOneSecondMyFavoriteCell

            let goods = goodsDic[section]![indexPath.item]
            cell?.configure(
                with: goods,
                likedButtonDelegate: viewController as! HomeViewController
            )

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
                    delegate: viewController as! HomeViewController
                )

                return moreFooterView ?? UICollectionReusableView()
            }

        default:
            return UICollectionReusableView()
        }
    }

}

// view의 UICollectionViewDelegate extension
extension HomePresenter {

    /// collectionView(_:didSelectItemAt:)에서 호출
    func didSelectItem(at indexPath: IndexPath) {
        guard let section = HomeCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else {return}

        switch section {
        case .카테고리:
            let title = categoryList[indexPath.item].title
            viewController?.pushToMoreViewController(
                with: title
            )

        case .서브배너:
            return

        default:
            guard let goods = goodsDic[section]?[indexPath.item]
            else {return}
            userDefaultsManager.addGoods(goods)
            viewController?.pushToWebViewController(
                with: goods
            )
        }
    }

    func willDisplay(
        cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        // 셀에 들어갈 Goods 데이터가
        // liked 배열에 있는 데이터들 중 같은게 있다면
        // 해당 셀에 보여질 데이터는 liked!
        guard let section = HomeCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else {return}

        switch section {
        case .오늘구매해야할제품:
            let cell = cell as! HomeCollectionViewBuyTodayCell
            let goods = goodsDic[section]![indexPath.item]

            let isLiked = likedGoodsList.filter {
                $0.imageURL?.absoluteString == goods.imageURL?.absoluteString
            }

            if isLiked.isEmpty {
                cell.likedButton(isSelected: false)
            } else {
                cell.likedButton(isSelected: true)
            }

        case .지금눈에띄는후드티:
            let cell = cell as! HomeCollectionViewNowLookingCell
            let goods = goodsDic[section]![indexPath.item]

            let isLiked = likedGoodsList.filter {
                $0.imageURL?.absoluteString == goods.imageURL?.absoluteString
            }

            if isLiked.isEmpty {
                cell.likedButton(isSelected: false)
            } else {
                cell.likedButton(isSelected: true)
            }


        case .일초만에사로잡는나의취향:
            let cell = cell as! HomeCollectionViewOneSecondMyFavoriteCell
            let goods = goodsDic[section]![indexPath.item]

            let isLiked = likedGoodsList.filter {
                $0.imageURL?.absoluteString == goods.imageURL?.absoluteString
            }

            if isLiked.isEmpty {
                cell.likedButton(isSelected: false)
            } else {
                cell.likedButton(isSelected: true)
            }

        default: return
        }
    }

}

// view의 LikedButtonDelegate extension
extension HomePresenter {

    func didTapLikedButton(_ sender: LikedButton) {
        // 유저가 있다면
        if let user = firebaseAuthManager.user {
            if sender.isSelected {
                likedGoodsList.remove(sender.goods!)
                firebaseRealtimeDatabaseManager.removeLikeds(
                    uid: user.uid,
                    goods: sender.goods!
                )
            } else {
                likedGoodsList.insert(sender.goods!)
                firebaseRealtimeDatabaseManager.updateLikeds(
                    uid: user.uid,
                    goods: sender.goods!
                )
            }

            sender.toggle()
        }

        // 유저가 없다면
        else {
            viewController.presentErrorToast(
                message: "로그인 후 사용가능"
            )
        }
    }

}

// view의 HomeCollectionViewMoreFooterDelegate extension
extension HomePresenter {

    // moreButton을 눌렀을 때
    func didTapMoreButton(tag: Int) {
        // 어느 섹션의 moreButton인지 판별
        guard let section = HomeCollectionViewSectionKind(
            rawValue: tag
        )
        else {return}

        // 해당 섹션에 해당하는 requestData 찾기
        let requestData = requestDataList.first {
            $0.section == section
        }

        guard let request = requestData?.request
        else {return}

        // MoreViewController로 push
        viewController?.pushToMoreViewController(
            with: request
        )
    }

}

// view의 private extension
extension HomePresenter {

    /// goodsOfHorse Notification이 동작했을 때
    func goodsOfHorseNotificationCame(
        _ notification: NSNotification
    ) {
        guard let userInfo = notification.userInfo,
              let goods = userInfo["goods"] as? Goods
        else {return}

        viewController.pushToWebViewController(
            with: goods
        )
    }

}

// presenter의 private extension
private extension HomePresenter {

    /// 데이터 가져오기
    func fetchData() {
        requestDataList.forEach { requestData in
            goodsSearchManager.request(
                with: requestData.request
            ) { [weak self] (results) in
                self?.goodsDic[requestData.section] = results
                self?.viewController.reloadCollectionView(
                    with: requestData.section.rawValue
                )
            }
        }
    }

}
