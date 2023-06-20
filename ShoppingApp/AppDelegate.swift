//
//  AppDelegate.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import FirebaseCore
import GoogleSignIn
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
//        if #available(iOS 15.0, *) {
//            UITableView.appearance().sectionHeaderTopPadding = .zero
//        }

        FirebaseApp.configure()
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

}
