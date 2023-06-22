//
//  RecentlyViewedPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import Foundation
import UIKit

protocol RecentlyViewedViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureCollectionView()
    func configureHierarchy()
    func tabBarIsHidden(_ isHidden: Bool)
    func reloadCollectionView()
    func pushToWebViewController(with goods: Goods)
}

final class RecentlyViewedPresenter: NSObject {
    private weak var viewController: RecentlyViewedViewProtocol!

    // apis
    private let userDefaultsManager: UserDefaultsManagerProtocl
    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol

    // 최근 본 상품 리스트
    private var recentlyViewedGoodsList: [Goods] = []
    private var likedGoodsList: Set<Goods> = []

    init(
        viewController: RecentlyViewedViewProtocol!,
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
        viewController.tabBarIsHidden(true)
    }

    func viewWillAppear() {
        recentlyViewedGoodsList =  userDefaultsManager.getGoods()
        if !recentlyViewedGoodsList.isEmpty {
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
    }

}

extension RecentlyViewedPresenter: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return recentlyViewedGoodsList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecentlyViewedCollectionViewCell.identifier,
            for: indexPath
        ) as! RecentlyViewedCollectionViewCell

        let goods = recentlyViewedGoodsList[indexPath.item]
        cell.configure(
            with: goods,
            tag: indexPath.item,
            likedButtonDelegate: viewController as! RecentlyViewedViewController
        )
        cell.delegate = viewController as! RecentlyViewedViewController

        return cell
    }

}

// view의 UICollectionViewDelegate extension
extension RecentlyViewedPresenter {

    func didSelectItem(at indexPath: IndexPath) {
        let goods = recentlyViewedGoodsList[indexPath.item]
        userDefaultsManager.addGoods(goods)
        viewController.pushToWebViewController(
            with: goods
        )
    }

    func willDisplay(
        cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let section = RecentlyViewedCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else {return}

        switch section {
        case .최근_본_상품:
            let cell = cell as! RecentlyViewedCollectionViewCell
            let goods = recentlyViewedGoodsList[indexPath.item]

            let isLiked = likedGoodsList.filter {
                $0.imageURL?.absoluteString == goods.imageURL?.absoluteString
            }

            if isLiked.isEmpty {
                cell.likedButton(isSelected: false)
            } else {
                cell.likedButton(isSelected: true)
            }
        }
    }

}

// view의 RecentlyViewedCollectionViewCellDelegate extension
extension RecentlyViewedPresenter {

    func didTapDeleteButton(tag index: Int) {
        let goods = recentlyViewedGoodsList[index]
        // userDefaults에서 삭제
        userDefaultsManager.removeGoods(goods)
        // presenter의 리스트에서 삭제
        recentlyViewedGoodsList.remove(at: index)
        // view 새로고침
        viewController.reloadCollectionView()
    }

}

extension RecentlyViewedPresenter {

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
