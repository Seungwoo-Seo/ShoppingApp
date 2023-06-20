//
//  HomePresenterTests.swift
//  ShoppingAppTests
//
//  Created by 서승우 on 2023/05/21.
//

import XCTest
@testable import ShoppingApp

final class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!
    var viewController: MockHomeViewController!

    override func setUp() {
        super.setUp()

        viewController = MockHomeViewController()
        sut = HomePresenter(
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

        XCTAssertTrue(viewController.isCalledConfigureCollectionView)
        XCTAssertTrue(viewController.isCalledConfigureHierarchy)
    }

    func test_viewWillAppear가_호출될_때() {
        sut.viewWillAppear()

        XCTAssertTrue(viewController.isCalledAddNotification)
    }

    func test_viewWillDisappear가_호출될_때() {
        sut.viewWillDisappear()

        XCTAssertTrue(viewController.isCalledRemoveNotification)
    }

}

// UICollectionViewDataSource
// -> DataSource 자체를 presenter로 보내는걸 다시 생각해봐야할듯
// -> 테스트가 ㅈ같아지네
// -> 테스트의 우선도가 높다면
// -> collectionView.dataSource = presenter가 아닌
// -> collectionView.dataSource = self로 바꿔야 겠는데 흠..
// -> 이론상으론 두번째 방법이 정석이라고 판단되긴 하는데
// -> 인터넷 강의는 dataSource를 presenter로 보내서 고민되네
//extension HomePresenterTests {
//
//    func test_메인배너_섹션의_Cell이_만들어질_때() {
//        // 섹션 총 갯수
//        let sectionCount = HomeCollectionViewSectionKind.allCases.count
//        // 랜덤한 섹션
//        let section = Int.random(in: 0..<sectionCount)
//
//        let _ = sut.collectionView(
//            UICollectionView(),
//            cellForItemAt: IndexPath(
//                item: 1,
//                section: section
//            )
//        )
//
//        XCTAssertTrue(viewController.isCalledDisplay)
//    }
//}

// view의 UICollectionViewDelegate extension
extension HomePresenterTests {

    func test_didSelectItem이_호출될_때() {
        // Given
        // 섹션 총 갯수
        let sectionCount = HomeCollectionViewSectionKind.allCases.count
        // 랜덤한 섹션
        let section = Int.random(in: 0..<sectionCount)

        // when
        sut.didSelectItem(
            at: IndexPath(
                item: 0,
                section: section
            )
        )

        // then
        // 카테고리 섹션
        let category = HomeCollectionViewSectionKind.카테고리.rawValue

        // 섹션이 카테고리라면
        if section == category {
            XCTAssertTrue(viewController.isCalledPushToMoreViewController)
            XCTAssertFalse(viewController.isCalledPushToDetailViewController)
        }

        // 카테고리 이외의 섹션이라면
        else {
            XCTAssertTrue(viewController.isCalledPushToDetailViewController)
            XCTAssertFalse(viewController.isCalledPushToMoreViewController)
        }
    }

}

// view의 HomeCollectionViewMoreFooterDelegate extension
extension HomePresenterTests {

    func test_didTapMoreButton이_호출될_때() {
        // Given
        // 섹션 총 갯수
        let sectionCount = HomeCollectionViewSectionKind.allCases.count
        // 랜덤한 섹션
        let section = Int.random(in: 0..<sectionCount)

        // when
        sut.didTapMoreButton(tag: section)

        // then
        XCTAssertTrue(viewController.isCalledPushToMoreViewController)
    }

}

// view의 private extension
extension HomePresenterTests {

    func test_goodsOfHorseNotificationCame이_호출될_때() {
        // Given
        let notification = NSNotification(
            name: NSNotification.Name.goodsOfHorse,
            object: nil,
            userInfo: [
                "goods": Goods()
            ]
        )

        // when
        sut.goodsOfHorseNotificationCame(notification)

        // then
        XCTAssertTrue(viewController.isCalledPushToDetailViewController)
    }

    func test_didTapAppNameBarButtonItem이_호출될_때() {
        sut.didTapAppNameBarButtonItem()

        XCTAssertTrue(viewController.isCalledReloadCollectionView)
    }

    func test_didTapSearchBarButtonItem이_호출될_때() {
        sut.didTapSearchBarButtonItem()

        XCTAssertTrue(viewController.isCalledPushToSearchViewController)
    }

}

// presenter의 private extension
// 이 부분도 테스트를 할 지 말지 고민되네
// 테스트의 기댓값이 얼마나 큰지 와닿지가 않아서 고민된다..
