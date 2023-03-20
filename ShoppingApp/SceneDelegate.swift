//
//  SceneDelegate.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = TabBarViewController()
        self.window?.tintColor = .label
        self.window?.backgroundColor = .systemBackground
        self.window?.makeKeyAndVisible()
    }

}

