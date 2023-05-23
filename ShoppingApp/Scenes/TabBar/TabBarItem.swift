//
//  TabBarItem.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit

enum TabBarItem: String, CaseIterable {
    case 홈
    case 스타일추천
    case 찜
    case MY


    var title: String {
        switch self {
        default: return rawValue
        }
    }

    var icon: (image: UIImage?, selectedImage: UIImage?) {
        switch self {
        case .홈: return (
            UIImage(systemName: "house"),
            UIImage(systemName: "house.fill")
        )
        case .스타일추천: return (
            UIImage(systemName: "books.vertical"),
            UIImage(systemName: "books.vertical.fill")
        )
        case .찜: return (
            UIImage(systemName: "heart"),
            UIImage(systemName: "heart.fill")
        )
        case .MY: return (
            UIImage(systemName: "person"),
            UIImage(systemName: "person.fill")
        )
        }
    }

    var viewController: UIViewController {
        switch self {
        case .홈:
            return UINavigationController(
                rootViewController: HomeViewController()
            )
        case .스타일추천:
            return UINavigationController(
                rootViewController: StyleRecommendationViewController()
            )
        case .찜:
            return UIViewController()
        case .MY:
            return UINavigationController(   rootViewController: MyViewController()
            )
        }
    }

}
