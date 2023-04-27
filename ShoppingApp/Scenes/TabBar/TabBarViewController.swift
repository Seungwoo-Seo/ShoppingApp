//
//  TabBarViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit
import Tabman
import Pageboy

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewControllers = TabBarItem.allCases
            .map { tabCase in
                let viewController = tabCase.viewController
                viewController.tabBarItem = UITabBarItem(
                    title: tabCase.title,
                    image: tabCase.icon.image,
                    selectedImage: tabCase.icon.selectedImage
                )

                return viewController
            }

        self.viewControllers = viewControllers
    }

}

final class TabViewController: TabmanViewController {

    private var viewControllers = [UIViewController(), UIViewController()]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize


        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }

}

extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(
        in pageboyViewController: PageboyViewController
    ) -> Int {
        return viewControllers.count
    }

    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(
        for pageboyViewController: PageboyViewController
    ) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }

}
