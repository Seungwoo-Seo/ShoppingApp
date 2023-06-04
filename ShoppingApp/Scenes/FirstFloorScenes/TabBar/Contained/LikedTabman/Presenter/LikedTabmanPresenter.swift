//
//  LikedTabmanPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/06/01.
//

import Foundation
import Pageboy
import Tabman
import UIKit

protocol LikedTabmanViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureButtonBar()
    func tabBarIsHidden(_ isHidden: Bool)
    func pushToSearchViewController()
    func presentPreparingToast(message: String)
}

final class LikedTabmanPresenter {
    private weak var viewController: LikedTabmanViewProtocol!

    init(
        viewController: LikedTabmanViewProtocol!
    ) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController.configureNavigationBar()
        viewController.configureButtonBar()
    }

    func viewWillAppear() {
        viewController.tabBarIsHidden(false)
    }

}

extension LikedTabmanPresenter: PageboyViewControllerDataSource {

    // viewController 개수 설정
    func numberOfViewControllers(
        in pageboyViewController: PageboyViewController
    ) -> Int {
        return LikedTabmanViewControllerKind.allCases.count
    }

    // 해당 인덱스에 사용할 viewController 설정
    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        let viewController = LikedTabmanViewControllerKind.allCases[index]
        return viewController.viewController
    }

    // 시작 viewController 설정
    func defaultPage(
        for pageboyViewController: PageboyViewController
    ) -> PageboyViewController.Page? {
        return nil
    }

}

extension LikedTabmanPresenter: TMBarDataSource {

    // Tabman의 barItem title 설정
    func barItem(
        for bar: TMBar,
        at index: Int
    ) -> TMBarItemable {
        let title = LikedTabmanViewControllerKind.allCases[index].title
        return TMBarItem(title: title)
    }

}


// view의 private extension
extension LikedTabmanPresenter {

    func didTapCartBarButtonItem() {
        viewController.presentPreparingToast(
            message: "준비중~"
        )
    }

    func didTapSearchBarButtonItem() {
        viewController.pushToSearchViewController()
    }

}
