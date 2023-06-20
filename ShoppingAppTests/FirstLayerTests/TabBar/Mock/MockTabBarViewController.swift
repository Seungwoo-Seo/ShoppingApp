//
//  MockTabBarViewController.swift
//  ShoppingAppTests
//
//  Created by 서승우 on 2023/05/19.
//

@testable import ShoppingApp

final class MockTabBarViewController: TabBarViewProtocol {
    var isCalledConfigureTabBarViewController = false
    var isCalledPresentToLoginViewController = false

    func configureTabBarViewController() {
        isCalledConfigureTabBarViewController = true
    }

    func presentToLoginViewController() {
        isCalledPresentToLoginViewController = true
    }

}
