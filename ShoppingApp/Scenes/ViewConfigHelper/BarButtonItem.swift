//
//  BarButtonItem.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/14.
//

import UIKit

/// 앱의 네비게이션 바 버튼 아이템들의 종류와 title, image
enum BarButtonItem {
    case appName
    case search
    case cart
    case setting

    var title: String? {
        switch self {
        case .appName: return "NaverShopping"
        default: return nil
        }
    }

    var image: UIImage? {
        switch self {
        case .search: return UIImage(systemName: "magnifyingglass")
        case .cart: return UIImage(systemName: "cart")
        case .setting: return UIImage(systemName: "gearshape")
        default: return nil
        }
    }
}
