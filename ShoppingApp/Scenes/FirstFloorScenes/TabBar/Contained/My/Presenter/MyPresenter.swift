//
//  MyPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/29.
//

import UIKit

protocol MyViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureCollectionView()
    func configureHierarchy()
    func tabBarIsHidden(_ isHidden: Bool)
    func navigationBarTitleUpdate(_ title: String)
    func pushToAccountViewController()
    func pushToRecentlyViewedViewController()
    func pushToWebViewController(with goods: Goods)
    func reloadCollectionView()
    func presentPreparingToast(message: String)
    func addNotification()
    func removeNotification()
    func tabBarControllerSelectedIndex(_ index: Int)
}

final class MyPresenter: NSObject {
    private weak var viewController: MyViewProtocol!

    // apis
    private let userDefaultsManager: UserDefaultsManagerProtocl
    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol

    private var recentlyViewedGoodsList: [Goods] = []
    private var likedGoodsList: Set<Goods> = []


    init(
        viewController: MyViewProtocol!,
        userDefaultsManager: UserDefaultsManagerProtocl = UserDefaultsManager(),
        firebaseAuthManager: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared,
        firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol = FirebaseRealtimeDatabaseManager.shared
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
        self.firebaseAuthManager = firebaseAuthManager
        self.firebaseRealtimeDatabaseManager = firebaseRealtimeDatabaseManager
    }

    func viewDidLoad() {
        viewController.configureNavigationBar()
        viewController.configureCollectionView()
        viewController.configureHierarchy()
    }

    func viewWillApper() {
        viewController.addNotification()
        viewController.tabBarIsHidden(false)
        recentlyViewedGoodsList = userDefaultsManager.getGoods()


        firebaseAuthManager.addStateDidChangeListener { [weak self] (user) in
            if let user = user {
                self?.viewController.navigationBarTitleUpdate(user.email!)

                if self?.recentlyViewedGoodsList.isEmpty == false {
                    // 최근 본 상품이 있으면
                    self?.firebaseRealtimeDatabaseManager.getLikeds(uid: user.uid) { goodsList in
                        if !goodsList.isEmpty {
                            self?.likedGoodsList = Set(goodsList)
                        } else {
                            self?.likedGoodsList = []
                        }

                        self?.viewController.reloadCollectionView()
                    }
                } else {
                    self?.viewController.reloadCollectionView()
                }
            }
        }
    }

    func viewWillDisApper() {
        viewController.removeNotification()
    }

}

extension MyPresenter: UICollectionViewDataSource {

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        if recentlyViewedGoodsList.isEmpty {
            return MyCollectionViewSectionKind.allCases.count - 1
        } else {
            return MyCollectionViewSectionKind.allCases.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let section = MyCollectionViewSectionKind(
            rawValue: section
        )

        switch section {
        case .포인트_쿠폰_주문배송조회:
            return MyCollectionViewPointCouponOrderDeliveryItemKind.allCases.count

        case .광고:
            return 1

        case .MY쇼핑:
            return MyCollectionViewMyShoppingItemKind.allCases.count

        case .최근본상품:
            return recentlyViewedGoodsList.count

        case .none:
            fatalError("존재하지 않는 섹션의 item 갯수를 설정했음")
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = MyCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else {return UICollectionViewCell()}

        switch section {
        case .포인트_쿠폰_주문배송조회:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCollectionViewPointCouponOrderDeliveryCell.identifier,
                for: indexPath
            ) as? MyCollectionViewPointCouponOrderDeliveryCell

            let item = MyCollectionViewPointCouponOrderDeliveryItemKind(
                rawValue: indexPath.item
            )

            cell?.configure(
                with: item?.title,
                image: item?.image
            )

            return cell ?? UICollectionViewCell()

        case .광고:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCollectionViewBannerCell.identifier,
                for: indexPath
            ) as? MyCollectionViewBannerCell

            return cell ?? UICollectionViewCell()

        case .MY쇼핑:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCollectionViewMyShoppingCell.identifier,
                for: indexPath
            ) as? MyCollectionViewMyShoppingCell

            let item = MyCollectionViewMyShoppingItemKind(
                rawValue: indexPath.item
            )

            cell?.configure(
                with: item?.title,
                image: item?.image
            )

            return cell ?? UICollectionViewCell()

        case .최근본상품:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCollectionViewRecentlyViewedCell.identifier,
                for: indexPath
            ) as? MyCollectionViewRecentlyViewedCell

            let goods = recentlyViewedGoodsList[indexPath.item]
            cell?.configure(
                with: goods,
                likedButtonDelegate: viewController as! MyViewController
            )

            return cell ?? UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let section = MyCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else {return UICollectionReusableView()}

        // header
        if kind == UICollectionView.elementKindSectionHeader {
            switch section {
            case .MY쇼핑:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyCollectionViewMyShoppingHeader.identifier,
                    for: indexPath
                ) as? MyCollectionViewMyShoppingHeader

                let title = section.title
                headerView?.configure(
                    with: title
                )

                return headerView ?? UICollectionReusableView()

            case .최근본상품:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyCollectionViewRecentlyViewedHeader.identifier,
                    for: indexPath
                ) as? MyCollectionViewRecentlyViewedHeader

                let title = section.title
                headerView?.configure(
                    with: title
                )
                headerView?.delegate = viewController as! MyViewController

                return headerView ?? UICollectionReusableView()

            default:
                return UICollectionReusableView()
            }
        }

        // footer
        else {
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyCollectionViewFooter.identifier,
                for: indexPath
            ) as? MyCollectionViewFooter

            return footerView ?? UICollectionReusableView()
        }
    }

}

// view의 UICollectionViewDelegate extension
extension MyPresenter {

    func didSelectItem(at indexPath: IndexPath) {
        guard let section = MyCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else {return}

        switch section {
        case .최근본상품:
            let goods = recentlyViewedGoodsList[indexPath.item]
            userDefaultsManager.addGoods(goods)
            viewController.pushToWebViewController(
                with: goods
            )

        default:
            viewController.presentPreparingToast(
                message: "준비중~"
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
        guard let section = MyCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else {return}

        switch section {
        case .최근본상품:
            let cell = cell as! MyCollectionViewRecentlyViewedCell
            let goods = recentlyViewedGoodsList[indexPath.item]

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

extension MyPresenter {

    func didTapLikedButton(_ sender: LikedButton) {
        // 유저가 있다면
        if let user = firebaseAuthManager.user {
            if sender.isSelected {
                firebaseRealtimeDatabaseManager.removeLikeds(
                    uid: user.uid,
                    goods: sender.goods!
                )
                likedGoodsList.remove(sender.goods!)
            } else {
                firebaseRealtimeDatabaseManager.updateLikeds(
                    uid: user.uid,
                    goods: sender.goods!
                )
                likedGoodsList.insert(sender.goods!)
            }

            sender.toggle()
        }
    }

}

// view의 MyCollectionViewRecentlyViewedHeaderDelegate extension
extension MyPresenter {

    func didTapDetailButton() {
        viewController?.pushToRecentlyViewedViewController()
    }

}

// view의 private extension
extension MyPresenter {

    func moveHomeTabmanViewController() {
        viewController.tabBarControllerSelectedIndex(0)
    }

    func didTapSettingBarButtonItem() {
        viewController.pushToAccountViewController()
    }

}
