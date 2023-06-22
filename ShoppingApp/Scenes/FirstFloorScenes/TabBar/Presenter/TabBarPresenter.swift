//
//  TabBarPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/19.
//

import Foundation

protocol TabBarViewProtocol: AnyObject {
    /// TabBarViewController를 구성하는 메소드
    func configureTabBarViewController()
    /// LoginViewController를 present 하는 메소드
    func presentToLoginViewController()
}

final class TabBarPresenter {
    private weak var viewController: TabBarViewProtocol!

    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let firebaseRealtimeDatabase: FirebaseRealtimeDatabaseManagerProtocol

    private var isLogin: Bool = false

    init(
        viewController: TabBarViewProtocol!,
        firebaseAuthManager: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared,
        firebaseRealtimeDatabase: FirebaseRealtimeDatabaseManagerProtocol = FirebaseRealtimeDatabaseManager.shared
    ) {
        self.viewController = viewController
        self.firebaseAuthManager = firebaseAuthManager
        self.firebaseRealtimeDatabase = firebaseRealtimeDatabase
    }

    /// view의 viewDidLoad에서 호출
    func viewDidLoad() {
        viewController.configureTabBarViewController()
    }

    func viewWillAppear() {
        firebaseAuthManager.addStateDidChangeListener { [weak self] (user) in
            if let _ = user {
                self?.isLogin = true
            } else {
                self?.isLogin = false
            }
        }
    }

    func viewDidAppear() {
        firebaseAuthManager.removeStateDidChangeListener()
    }

}

// view의 UITabBarControllerDelegate extension
extension TabBarPresenter {

    /// tabBarController(_:shouldSelect:) 에서 호출
    /// - Parameters
    ///   - title: viewController.tabBarItem의 title
    /// - Returns: true이면 탭 바 이동o, false이면 탭 바 이동x
    func shouldSelect(title: String?) -> Bool {
        if title == TabBarItemKind.MY.title {
            // 로그인
            if isLogin {
                return true
            }

            // 로그인 하지 않음
            else {
                viewController.presentToLoginViewController()
                return false
            }
        }

        return true
    }

}

