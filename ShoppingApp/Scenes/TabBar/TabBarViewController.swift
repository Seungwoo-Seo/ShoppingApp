//
//  TabBarViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit

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
