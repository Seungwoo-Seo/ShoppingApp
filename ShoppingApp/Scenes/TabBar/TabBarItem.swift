//
//  TabBarItem.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit

enum TabBarItem: CaseIterable {
    case home
    case liked
    case my


    var title: String {
        switch self {
        case .home: return "홈"
        case .liked: return "찜"
        case .my: return "MY"
        }
    }

    var icon: (image: UIImage?, selectedImage: UIImage?) {
        switch self {
        case .home: return (
            UIImage(systemName: "house"),
            UIImage(systemName: "house.fill")
        )
        case .liked: return (
            UIImage(systemName: "heart"),
            UIImage(systemName: "heart.fill")
        )
        case .my: return (
            UIImage(systemName: "person"),
            UIImage(systemName: "person.fill")
        )
        }
    }

    var viewController: UIViewController {
        switch self {
        case .home:
            return UINavigationController(
                rootViewController: HomeViewController()
            )
        case .liked:
            return UIViewController()
        case .my:
            return UINavigationController(   rootViewController: MyViewController()
            )
        }
    }

}