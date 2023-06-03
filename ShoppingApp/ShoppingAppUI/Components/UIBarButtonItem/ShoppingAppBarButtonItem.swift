//
//  ShoppingAppBarButtonItem.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/14.
//

import UIKit

/// ShoppingApp의 네비게이션 BarButtonItem 종류
enum ShoppingAppBarButtonItemStyle {
    case appName
    case search
    case cart
    case back
    case setting
    case cancel

    var title: String? {
        switch self {
        case .appName: return "ShoppingApp"
        case .cancel: return "취소"
        default: return nil
        }
    }

    var image: UIImage? {
        switch self {
        case .search: return UIImage(
            systemName: "magnifyingglass"
        )
        case .cart: return UIImage(
            systemName: "cart"
        )
        case .back: return UIImage(
            systemName: "xmark"
        )
        case .setting: return UIImage(
            systemName: "gearshape"
        )
        default: return nil
        }
    }

    var attributes: [NSAttributedString.Key: Any]? {
        switch self {
        case .appName:
            return [
                .font: UIFont.boldSystemFont(ofSize: 24)
            ]
        default: return nil
        }
    }
}

final class ShoppingAppBarButtonItem: UIBarButtonItem {
    private let barButtonItemStyle: ShoppingAppBarButtonItemStyle

    init(
        barButtonItemStyle: ShoppingAppBarButtonItemStyle,
        target: AnyObject?,
        action: Selector?
    ) {
        self.barButtonItemStyle = barButtonItemStyle
        super.init()

        configure(target, action: action)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(
        _ target: AnyObject?,
        action: Selector?
    ) {
        switch barButtonItemStyle {
        case .appName:
            title = barButtonItemStyle.title
            setTitleTextAttributes(
                barButtonItemStyle.attributes,
                for: .normal
            )

        case .cancel:
            title = barButtonItemStyle.title
            tintColor = .lightGray

        default:
            image = barButtonItemStyle.image
        }

        // 공통 설정
        self.target = target
        self.action = action
        style = .plain
    }

}
