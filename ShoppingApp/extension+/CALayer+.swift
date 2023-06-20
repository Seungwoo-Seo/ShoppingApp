//
//  CALayer+.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/18.
//

import UIKit

extension CALayer {
    
    // 그림자 구성
    func configureShadow() {
        shadowOffset = CGSize(width: 1, height: 1)
        shadowOpacity = 0.5
        shadowColor = UIColor.gray.cgColor
    }
    
}
