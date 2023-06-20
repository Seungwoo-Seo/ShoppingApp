//
//  HomeTabmanViewControllerKind.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/19.
//

import UIKit

/// HomeTabmanViewController에 포함된 ViewController의 종류
enum HomeTabmanViewControllerKind: String, CaseIterable {
    case 홈
    case 랭킹
    case 단독
    case 코디
    case 매거진
    case 브랜드
    case 쇼핑몰
    case 디지털
    case 라이프

    var title: String {
        return rawValue
    }

    var viewController: UIViewController {
        switch self {
        case .홈:
            return HomeViewController()
        default:
            return UIViewController()
        }
    }
}
