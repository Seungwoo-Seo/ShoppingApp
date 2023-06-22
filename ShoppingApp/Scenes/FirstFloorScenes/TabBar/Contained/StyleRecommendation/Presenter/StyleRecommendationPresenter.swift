//
//  StyleRecommendationPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import Foundation
import Kingfisher
import UIKit

protocol StyleRecommendationViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureCollectionView()
    func configureHierarchy()
    func tapBarIsHidden(_ isHidden: Bool)
    func pushToWebViewController(with goods: Goods)
    func pushToSearchViewController()
    func presentPreparingToast(message: String)
    func presentErrorToast(message: String)
    func reloadCollectionView()
    func endRefreshing()
}

final class StyleRecommendationPresenter: NSObject {
    private weak var viewController: StyleRecommendationViewProtocol!

    // apis
    private let goodsSearchManager: GoodsSearchManagerProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocl
    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol

    private var goodsList: [Goods] = []
    // 현재 페이지
    private var currentPage = 0
    // 한 페이지에 최대 몇 개까지 보여줄건지
    private let display = 20

    private var likedGoodsList: Set<Goods> = Set<Goods>()

    init(
        viewController: StyleRecommendationViewProtocol!,
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

    func viewDidLoad() {
        viewController.configureNavigationBar()
        viewController.configureCollectionView()
        viewController.configureHierarchy()

        requestGoodsList(isNeededToReset: false)
    }

    func viewWillAppear() {
        viewController.tapBarIsHidden(false)
        firebaseAuthManager.addStateDidChangeListener { [weak self] (user) in
            if let user = user {
                // 유저가 있으면 찜을 확인해보자
                self?.firebaseRealtimeDatabaseManager.getLikeds(uid: user.uid) { goodsList in
                    if !goodsList.isEmpty {
                        self?.likedGoodsList = Set(goodsList)
                        self?.viewController.reloadCollectionView()
                    }
                }
            } else {
                self?.likedGoodsList = []
                self?.viewController.reloadCollectionView()
            }
        }
    }

    func viewWillDisappear() {
        firebaseAuthManager.removeStateDidChangeListener()
    }

}

extension StyleRecommendationPresenter: UICollectionViewDataSource {

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return StyleRecommendationCollectionViewSectionKind.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return goodsList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StyleRecommendationCollectionViewCell.identifier,
            for: indexPath
        ) as? StyleRecommendationCollectionViewCell

        let goods = goodsList[indexPath.item]
        cell?.configure(
            with: goods,
            likedButtonDelegate: viewController as! StyleRecommendationViewController
        )

        return cell ?? UICollectionViewCell()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: StyleRecommendationCollectionViewHeader.identifier,
                for: indexPath
            ) as? StyleRecommendationCollectionViewHeader

            header?.configure(with: "당신을 위한 추천")

            return header ?? UICollectionReusableView()
        }

        else {
            return UICollectionReusableView()
        }
    }
    
}

extension StyleRecommendationPresenter: UICollectionViewDataSourcePrefetching {

    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        let urls = indexPaths.compactMap { goodsList[$0.item].imageURL
        }
        // 미리 이미지를 가져오겠지?
        ImagePrefetcher(urls: urls).start()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
    ) {
        let urls = indexPaths.compactMap {
            goodsList[$0.item].imageURL
        }
        ImagePrefetcher(urls: urls).stop()
    }

}

// view의 UICollectionViewDelegate extension
extension StyleRecommendationPresenter {

    func didSelectItem(at indexPath: IndexPath) {
        let goods = goodsList[indexPath.item]
        userDefaultsManager.addGoods(goods)
        viewController.pushToWebViewController(with: goods)
    }

    func willDisplay(
        cell: UICollectionViewCell,
        indexPath: IndexPath
    ) {
        let cell = cell as! StyleRecommendationCollectionViewCell
        let goods = goodsList[indexPath.item]

        let isLiked = likedGoodsList.filter {
            $0.imageURL?.absoluteString == goods.imageURL?.absoluteString
        }

        if isLiked.isEmpty {
            cell.likedButton(isSelected: false)
        } else {
            cell.likedButton(isSelected: true)
        }

        let currentRow = indexPath.row

        guard (currentRow % display) == display - 1 && (currentRow / display) == (currentPage - 1) else {return}

        requestGoodsList(isNeededToReset: false)
    }

}

// view의 LikedButtonDelegate extension
extension StyleRecommendationPresenter {

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

// view의 private extension
extension StyleRecommendationPresenter {

    func didTapCartBarButtonItem() {
        viewController.presentPreparingToast(
            message: "준비중~"
        )
    }

    func didTapSearchBarButtonItem() {
        viewController.pushToSearchViewController()
    }

    func didValueChangedRefreshControl() {
        requestGoodsList(isNeededToReset: true)
    }

}

// presenter의 private
private extension StyleRecommendationPresenter {

    func requestGoodsList(isNeededToReset: Bool) {
        if isNeededToReset {
            currentPage = 0
        }

        goodsSearchManager.request(
            with: "가디건",
            display: display,
            start: (currentPage * display) + 1
        ) { [weak self] (results) in
            if isNeededToReset {
                self?.goodsList = results
            } else {
                self?.goodsList += results
            }

            self?.currentPage += 1
            self?.viewController.reloadCollectionView()
            self?.viewController.endRefreshing()
        }
    }

}
