//
//  LikedTabmanViewControllerKind.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/06/01.
//

import UIKit

/// LikedTabmanViewControllerKind에 포함된 ViewController의 종류
enum LikedTabmanViewControllerKind: String, CaseIterable {
    case 상품
    case 스토어
    case 코디

    var title: String {
        return rawValue
    }

    var viewController: UIViewController {
        switch self {
        case .상품:
            return LikedViewController()
        default:
            return UIViewController()
        }
    }
}
