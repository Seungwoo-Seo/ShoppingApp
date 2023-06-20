//
//  TabBarItemKind.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit

/// TabBarViewController의 TabBarItem 종류
enum TabBarItemKind: String, CaseIterable {
    case 홈
    case 스타일추천
    case 카테고리
    case 찜
    case MY


    var title: String {
        return rawValue
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
        case .카테고리: return (
            UIImage(systemName: "text.justify"),
            UIImage(systemName: "text.justify")
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
                rootViewController: HomeTabmanViewController()
            )
        case .스타일추천:
            return UINavigationController(
                rootViewController: StyleRecommendationViewController()
            )
        case .카테고리:
            return UINavigationController(
                rootViewController: CategoryViewController()
            )
        case .찜:
            return UINavigationController(
                rootViewController: LikedTabmanViewController()
            )
        case .MY:
            return UINavigationController(
                rootViewController: MyViewController()
            )
        }
    }

}
