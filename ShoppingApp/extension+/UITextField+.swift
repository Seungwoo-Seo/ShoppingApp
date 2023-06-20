//
//  UITextField+.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/11.
//

import UIKit

extension UITextField {

    /// UITextField의 왼쪽 패딩 설정하기
    func addLeftPadding(_ width: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: frame.height
            )
        )
        leftView = paddingView
        leftViewMode = .always
    }

}
