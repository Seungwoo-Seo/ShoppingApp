//
//  HomeTabmanPresenterTests.swift
//  ShoppingAppTests
//
//  Created by 서승우 on 2023/05/19.
//

import XCTest
@testable import ShoppingApp

final class HomeTabmanPresenterTests: XCTestCase {
    var sut: HomeTabmanPresenter!
    var viewController: MockHomeTabmanViewController!

    override func setUp() {
        super.setUp()

        viewController = MockHomeTabmanViewController()
        sut = HomeTabmanPresenter(
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

        XCTAssertTrue(viewController.isCalledConfigureNavigationBar)
        XCTAssertTrue(viewController.isCalledConfigureButtonBar)
    }

}
