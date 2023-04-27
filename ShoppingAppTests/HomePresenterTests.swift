//
//  HomePresenterTests.swift
//  ShoppingAppTests
//
//  Created by 서승우 on 2023/04/15.
//

import XCTest
@testable import ShoppingApp

final class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!
    var viewController: MockHomeViewController!

    override func setUp() {
        super.setUp()

        viewController = MockHomeViewController()
        sut = HomePresenter(viewController: viewController)
    }

    override func tearDown() {
        sut = nil
        viewController = nil

        super.tearDown()
    }

    func test_viewDidLoad가_호출될_때() {
        sut.viewDidLoad()

        XCTAssertTrue(viewController.isCalledConfigureNavigationBar)
        XCTAssertTrue(viewController.isCalledConfigureHierarchy)
    }

    func test_viewWillAppear가_호출될_때() {
        sut.viewWillAppear()

        XCTAssertTrue(viewController.isCalledConfigureTabBar)
    }

    func test_didTapAppNameBarButtonItem가_호출될_때() {
        sut.didTapAppNameBarButtonItem()

        XCTAssertTrue(viewController.isCalledReloadCollectionView)
    }

    func test_didTapSearchBarButtonItem가_호출될_때() {
        sut.didTapSearchBarButtonItem()

        XCTAssertTrue(viewController.isCalledPushToSearchViewController)
    }

    func test_didSelectItem가_호출될_때() {
        sut.didSelectItem(at: IndexPath(item: 0, section: 0))

        XCTAssertTrue(viewController.isCalledPushToDetailViewController)
    }

}

final class MockHomeViewController: HomeViewProtocol {
    var isCalledConfigureNavigationBar = false
    var isCalledConfigureTabBar = false
    var isCalledConfigureHierarchy = false
    var isCalledPushToSearchViewController = false
    var isCalledPushToDetailViewController = false
    var isCalledReloadCollectionView = false
    var isCalledReloadCollectionViewWithRawValue = false

    func configureNavigationBar() {
        isCalledConfigureNavigationBar = true
    }

    func configureTabBar() {
        isCalledConfigureTabBar = true
    }

    func configureHierarchy() {
        isCalledConfigureHierarchy = true
    }

    func pushToSearchViewController() {
        isCalledPushToSearchViewController = true
    }

    func pushToDetailViewController(with clothes: ShoppingApp.Goods?) {
        isCalledPushToDetailViewController = true
    }

    func reloadCollectionView() {
        isCalledReloadCollectionView = true
    }

    func reloadCollectionView(with rawValue: Int) {
        isCalledReloadCollectionViewWithRawValue = true
    }

}
