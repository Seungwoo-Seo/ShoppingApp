//
//  MockHomeTabmanViewController.swift
//  ShoppingAppTests
//
//  Created by 서승우 on 2023/05/19.
//

@testable import ShoppingApp

final class MockHomeTabmanViewController: HomeTabmanViewProtocol {
    var isCalledConfigureNavigationBar = false
    var isCalledConfigureButtonBar = false
    var isCalledTabBarUpdate = false

    func configureNavigationBar() {
        isCalledConfigureNavigationBar = true
    }

    func configureButtonBar() {
        isCalledConfigureButtonBar = true
    }

    func tabBarUpdate(isHidden: Bool) {
        isCalledTabBarUpdate = true
    }

}
