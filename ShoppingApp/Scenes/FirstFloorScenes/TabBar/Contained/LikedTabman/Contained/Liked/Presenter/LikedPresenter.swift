//
//  LikedPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/13.
//

import Foundation
import UIKit

protocol LikedViewProtocol: AnyObject {
    func configureCollectionView()
    func configureHiddenLabel()
    func configureHiddenButton()
    func configureHierarchy()
    func reloadCollectionView()
    func isHidden(
        collectionView: Bool,
        hiddenLabel: Bool,
        hiddenButton: Bool
    )
    func pushToWebViewController(with goods: Goods)
    func pushToMoreViewController(with request: String)
    func collectionViewDeleteItems(
        at indexPaths: [IndexPath]
    )
}

final class LikedPresenter: NSObject {
    private weak var viewController: LikedViewProtocol!

    // apis
    private let userDefaultsManager: UserDefaultsManagerProtocl
    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol

    private var likedGoodsList: [Goods] = []

    init(
        viewController: LikedViewProtocol!,
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
        viewController.configureCollectionView()
        viewController.configureHiddenLabel()
        viewController.configureHiddenButton()
        viewController.configureHierarchy()
    }

    func viewWillAppear() {
        firebaseAuthManager.addStateDidChangeListener { [weak self] (user) in
            if let user = user {
                // 유저가 있으면 찜을 확인해보자
                self?.firebaseRealtimeDatabaseManager.getLikeds(uid: user.uid) { goodsList in
                    if !goodsList.isEmpty {
                        self?.likedGoodsList = goodsList
                        self?.viewController.isHidden(
                            collectionView: false,
                            hiddenLabel: true,
                            hiddenButton: true)
                    } else {
                        self?.likedGoodsList = []
                        self?.viewController.isHidden(
                            collectionView: true,
                            hiddenLabel: false,
                            hiddenButton: false
                        )
                    }

                    self?.viewController.reloadCollectionView()
                }
            } else {
                self?.likedGoodsList = []
                self?.viewController.reloadCollectionView()
                self?.viewController.isHidden(
                    collectionView: true,
                    hiddenLabel: false,
                    hiddenButton: false
                )
            }
        }
    }

}

extension LikedPresenter: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return likedGoodsList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LikedCollectionViewCell.identifier,
            for: indexPath
        ) as! LikedCollectionViewCell

        let goods = likedGoodsList[indexPath.item]
        cell.configure(
            with: goods,
            likedButtonDelegate: viewController as! LikedViewController
        )
        cell.likedButton(isSelected: true)

        return cell
    }

}

// view의 UICollectionViewDelegate extension
extension LikedPresenter {

    func didSelectItem(at indexPath: IndexPath) {
        let goods = likedGoodsList[indexPath.item]
        userDefaultsManager.addGoods(goods)
        viewController.pushToWebViewController(with: goods)
    }

}

// view의 LikedButtonDelegate extension
extension LikedPresenter {

    func didTapLikedButton(_ sender: LikedButton) {
        // 유저가 있어야 애초에 tap 가능
        // 걍 날려버리는ㄱ 저ㅣ
        if let user = firebaseAuthManager.user,
           let index = likedGoodsList.firstIndex(
            of: sender.goods!
        ) {
            firebaseRealtimeDatabaseManager.removeLikeds(
                uid: user.uid,
                goods: sender.goods!
            )
            viewController.collectionViewDeleteItems(
                at: [IndexPath(item: index, section: 0)]
            )
            likedGoodsList.remove(at: index)

            if likedGoodsList.isEmpty {
                viewController.isHidden(
                    collectionView: true,
                    hiddenLabel: false,
                    hiddenButton: false
                )
            }
        }
    }

}

// view의 private extension
extension LikedPresenter {

    func didTapHiddenButton() {
        viewController.pushToMoreViewController(
            with: "신발"
        )
    }

}
