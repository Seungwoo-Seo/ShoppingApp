//
//  HomeTabmanPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/04.
//

import Foundation
import Pageboy
import Tabman
import UIKit

protocol HomeTabmanViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureButtonBar()
    func tabBarUpdate(isHidden: Bool)
    func pushToSearchViewController()
}

final class HomeTabmanPresenter {
    private weak var viewController: HomeTabmanViewProtocol!

    init(
        viewController: HomeTabmanViewProtocol!
    ) {
        self.viewController = viewController
    }

    // view의 viewDidLoad에서 호출
    func viewDidLoad() {
        viewController.configureNavigationBar()
        viewController.configureButtonBar()
    }

    // view의 viewWillAppear에서 호출
    func viewWillAppear() {
        viewController.tabBarUpdate(isHidden: false)
    }

}

extension HomeTabmanPresenter: PageboyViewControllerDataSource {

    // viewController 개수 설정
    func numberOfViewControllers(
        in pageboyViewController: PageboyViewController
    ) -> Int {
        return HomeTabmanViewControllerKind.allCases.count
    }

    // 해당 인덱스에 사용할 viewController 설정
    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        let viewController = HomeTabmanViewControllerKind.allCases[index]
        return viewController.viewController
    }

    // 시작 viewController 설정
    func defaultPage(
        for pageboyViewController: PageboyViewController
    ) -> PageboyViewController.Page? {
        return nil
    }

}

extension HomeTabmanPresenter: TMBarDataSource {

    // Tabman의 barItem title 설정
    func barItem(
        for bar: TMBar,
        at index: Int
    ) -> TMBarItemable {
        let title = HomeTabmanViewControllerKind.allCases[index].title
        return TMBarItem(title: title)
    }

}

// view의 private extension
extension HomeTabmanPresenter {

    /// appNameBarButtonItem tap 했을 때 호출
    func didTapAppNameBarButtonItem() {
//        viewController.reloadCollectionView()
    }

    /// searchBarButtonItem tap 했을 때 호출
    func didTapSearchBarButtonItem() {
        viewController.pushToSearchViewController()
    }

}
