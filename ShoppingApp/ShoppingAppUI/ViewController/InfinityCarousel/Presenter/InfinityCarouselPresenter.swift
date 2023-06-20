//
//  InfinityCarouselPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/18.
//

import Foundation
import UIKit
import Pageboy

protocol InfinityCarouselViewProtocol: AnyObject {
    func configurePageboyViewController()
    func configureAutoScroller()
    func configureHierarchy()
    func reloadPageboyViewControllerDataSource()
    func updateBannerIndexLabel(by text: String?)
    func autoScroll(_ duration: TimeInterval)
}

final class InfinityCarouselPresenter: NSObject {
    private weak var viewController: InfinityCarouselViewProtocol!

    private var goodsList: [Goods]?
    private var horseViewControllers: [UIViewController] = []

    init(
        viewController: InfinityCarouselViewProtocol!,
        goodsList: [Goods]?
    ) {
        self.viewController = viewController
        self.goodsList = goodsList
        super.init()

        self.startMakeHorseViewControllersFlow()
    }

    func viewDidLoad() {
        viewController.configurePageboyViewController()
        viewController.configureAutoScroller()
        viewController.configureHierarchy()
    }
}

extension InfinityCarouselPresenter: PageboyViewControllerDataSource {

    func numberOfViewControllers(
        in pageboyViewController: Pageboy.PageboyViewController
    ) -> Int {
        return horseViewControllers.count
    }

    func viewController(
        for pageboyViewController: Pageboy.PageboyViewController,
        at index: Pageboy.PageboyViewController.PageIndex
    ) -> UIViewController? {
        let viewController = horseViewControllers[index]
        return viewController
    }

    func defaultPage(
        for pageboyViewController: Pageboy.PageboyViewController
    ) -> Pageboy.PageboyViewController.Page? {
        return nil
    }

}

// PageboyViewControllerDelegate
extension InfinityCarouselPresenter {

    func didScrollToPage(at index: Int) {
        viewController.updateBannerIndexLabel(
            by: "\(index + 1) / \(horseViewControllers.count)"
        )
    }

}

private extension InfinityCarouselPresenter {

    func startMakeHorseViewControllersFlow() {
        guard let goodsList = goodsList,
              !goodsList.isEmpty
        else {return}

        let horses = goodsList.map {
            let horse = InfinityCarouselHorseViewController(
                goods: $0
            )
            return horse
        }

        // horeViewControllers 데이터 할당
        horseViewControllers = horses
        // reload
        viewController.reloadPageboyViewControllerDataSource()
        // 현재 인덱스 표시
        viewController.updateBannerIndexLabel(
            by: "1 / \(horseViewControllers.count)"
        )
        // autoScroll 시작
        viewController.autoScroll(3)
    }

}
