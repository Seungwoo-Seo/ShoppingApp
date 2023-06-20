//
//  TabBarPresenterTests.swift
//  ShoppingAppTests
//
//  Created by 서승우 on 2023/05/19.
//

import XCTest
@testable import ShoppingApp

final class TabBarPresenterTests: XCTestCase {
    var sut: TabBarPresenter!
    var viewController: MockTabBarViewController!

    override func setUp() {
        super.setUp()

        viewController = MockTabBarViewController()
        sut = TabBarPresenter(
            viewController: viewController
        )
    }

    override func tearDown() {
        sut = nil
        viewController = nil

        super.tearDown()
    }

    func test_viewDidLoad가_호출될_때() {
        sut.viewDidLoad()

        XCTAssertTrue(viewController.isCalledConfigureTabBarViewController)
    }

    func test_shouldSelect가_호출될_때_title이_MY일_때() {
        let _ = sut.shouldSelect(
            title: TabBarItemKind.MY.title
        )

        XCTAssertTrue(viewController.isCalledPresentToLoginViewController)
    }

    func test_shouldSelect가_호출될_때_title이_MY가_아닐_때() {
        let _ = sut.shouldSelect(
            title: TabBarItemKind.홈.title
        )

        XCTAssertFalse(viewController.isCalledPresentToLoginViewController)
    }

    func test_shouldSelect가_호출될_때_title이_공백일_때() {
        let _ = sut.shouldSelect(
            title: ""
        )

        XCTAssertFalse(viewController.isCalledPresentToLoginViewController)
    }


    func test_shouldSelect가_호출될_때_title이_nil일_때() {
        let _ = sut.shouldSelect(
            title: nil
        )

        XCTAssertFalse(viewController.isCalledPresentToLoginViewController)
    }

}
