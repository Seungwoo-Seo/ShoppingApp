//
//  MockHomeViewController.swift
//  ShoppingAppTests
//
//  Created by 서승우 on 2023/05/21.
//

@testable import ShoppingApp
import UIKit

final class MockHomeViewController: HomeViewProtocol {
    var isCalledConfigureCollectionView = false
    var isCalledConfigureHierarchy = false
    var isCalledAddNotification = false
    var isCalledRemoveNotification = false
    var isCalledPushToSearchViewController = false
    var isCalledPushToDetailViewController = false
    var isCalledPushToMoreViewController = false
    var isCalledReloadCollectionView = false
    var isCalledReloadCollectionViewWithRawValue = false
    var isCalledDisplay = false



    func configureCollectionView() {
        isCalledConfigureCollectionView = true
    }

    func configureHierarchy() {
        isCalledConfigureHierarchy = true
    }

    func addNotification() {
        isCalledAddNotification = true
    }

    func removeNotification() {
        isCalledRemoveNotification = true
    }

    func pushToSearchViewController() {
        isCalledPushToSearchViewController = true
    }

    func pushToDetailViewController(
        with goods: ShoppingApp.Goods?
    ) {
        isCalledPushToDetailViewController = true
    }

    func pushToMoreViewController(
        with query: String?
    ) {
        isCalledPushToMoreViewController = true
    }

    func reloadCollectionView() {
        isCalledReloadCollectionView = true
    }

    func reloadCollectionView(
        with rawValue: Int
    ) {
        isCalledReloadCollectionViewWithRawValue = true
    }

    func display(
        to view: UIView,
        goodsList: [ShoppingApp.Goods]
    ) {
        isCalledDisplay = true
    }


}
