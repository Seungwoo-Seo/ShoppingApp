//
//  MorePresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/28.
//

import Foundation
import Kingfisher
import UIKit

protocol MoreViewProtocol: AnyObject {
    func configureNavigationBar(with title: String)
    func configureCollectionView()
    func configureHierarchy()
    func reloadCollectionView()
    func endRefreshing()
    func pushToWebViewController(with goods: Goods)
    func pushToSearchViewController()
    func presentPreparingToast(message: String)
    func presentErrorToast(message: String)
}

final class MorePresenter: NSObject {
    private weak var viewController: MoreViewProtocol!

    // apis
    private let goodsSearchManager: GoodsSearchManagerProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocl
    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol

    // 요청할 데이터
    private var request: String
    // 응답 받은 데이터 리스트
    private var goodsList: [Goods] = []

    // 지금까지 request 된, 가지고 있는 보여주고 있는 page가 어디인지
    private var currentPage = 0
    // 한 페이지에 최대 몇 개까지 보여줄건지
    private let display = 20

    private var likedGoodsList: Set<Goods> = []

    init(
        viewController: MoreViewProtocol!,
        request: String,
        goodsSearchManager: GoodsSearchManagerProtocol = GoodsSearchManager(),
        userDefaultsManager: UserDefaultsManagerProtocl = UserDefaultsManager(),
        firebaseAuthManager: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared,
        firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol = FirebaseRealtimeDatabaseManager.shared
    ) {
        self.viewController = viewController
        self.request = request
        self.goodsSearchManager = goodsSearchManager
        self.userDefaultsManager = userDefaultsManager
        self.firebaseAuthManager = firebaseAuthManager
        self.firebaseRealtimeDatabaseManager = firebaseRealtimeDatabaseManager
    }

    func viewDidLoad() {
        viewController.configureNavigationBar(
            with: request
        )
        viewController.configureCollectionView()
        viewController.configureHierarchy()

        requestGoodsList(
            isNeededToReset: false,
            request: request
        )
    }

    func viewWillAppear() {
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

extension MorePresenter: UICollectionViewDataSource {

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return MoreCollectionViewSectionKind.allCases.count
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
            withReuseIdentifier: MoreCollectionViewCell.identifier,
            for: indexPath
        ) as! MoreCollectionViewCell

        let goods = goodsList[indexPath.item]
        cell.configure(
            with: goods,
            likedButtonDelegate: viewController as! MoreViewController
        )

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MoreCollectionViewHeader.identifier,
                for: indexPath
            ) as? MoreCollectionViewHeader

            header?.delegate = viewController as! MoreViewController

            return header ?? UICollectionReusableView()
        }

        else {
            return UICollectionReusableView()
        }
    }

}

extension MorePresenter: UICollectionViewDataSourcePrefetching {

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
extension MorePresenter {

    func willDisplay(
        cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let section = MoreCollectionViewSectionKind(
            rawValue: indexPath.section
        ) else {return}

        switch section {
        case .더보기:
            let cell = cell as! MoreCollectionViewCell
            let goods = goodsList[indexPath.item]

            let isLiked = likedGoodsList.filter {
                $0.imageURL?.absoluteString == goods.imageURL?.absoluteString
            }

            if isLiked.isEmpty {
                cell.likedButton(isSelected: false)
            } else {
                cell.likedButton(isSelected: true)
            }
        }

        let currentRow = indexPath.row

        guard (currentRow % display) == display - 1 && (currentRow / display) == (currentPage - 1) else {return}

        requestGoodsList(
            isNeededToReset: false,
            request: request
        )
    }

    func didSelectItem(at indexPath: IndexPath) {
        let goods = goodsList[indexPath.item]
        userDefaultsManager.addGoods(goods)
        viewController.pushToWebViewController(
            with: goods
        )
    }

}

// view의 LikedButtonDelegate extension
extension MorePresenter {

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
        } else {
            viewController.presentErrorToast(
                message: "로그인 후 사용가능"
            )
        }
    }

}

extension MorePresenter {

    func didTapOrderOfPopularityButton() {
        viewController.presentPreparingToast(message: "준비중~")
    }

    func didTapFilterButton() {
        viewController.presentPreparingToast(message: "준비중~")
    }

}

// view의 private extension
extension MorePresenter {

    func didTapCartBarButtonItem() {
        viewController.presentPreparingToast(message: "준비중~")
    }

    func didTapSearchBarButtonItem() {
        viewController.pushToSearchViewController()
    }

    func didValueChangedRefreshControl() {
        requestGoodsList(
            isNeededToReset: true,
            request: request
        )
    }

}

// presenter의 private
private extension MorePresenter {

    func requestGoodsList(
        isNeededToReset: Bool,
        request: String
    ) {
        if isNeededToReset {
            currentPage = 0
        }

        goodsSearchManager.request(
            with: request,
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
