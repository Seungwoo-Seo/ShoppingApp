//
//  TabBarViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit

final class TabBarViewController: UITabBarController {
    private lazy var presenter = TabBarPresenter(
        viewController: self
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter.viewDidAppear()
    }

}

extension TabBarViewController: UITabBarControllerDelegate {

    // tabBarItem을 선택 했을 때 호출
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        let title = viewController.tabBarItem.title

        return presenter.shouldSelect(title: title)
    }

}

extension TabBarViewController: TabBarViewProtocol {

    // TabBarViewController를 구성하는 메소드
    func configureTabBarViewController() {
        delegate = self

        let viewControllers = TabBarItemKind.allCases
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

    // LoginViewController를 present 하는 메소드
    func presentToLoginViewController() {
        let loginViewController = UINavigationController(
            rootViewController: LoginViewController()
        )
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true)
    }

}
