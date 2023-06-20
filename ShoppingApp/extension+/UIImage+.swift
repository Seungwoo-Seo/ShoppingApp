//
//  UIImage+.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/14.
//

import UIKit

extension UIImage {

    // placeholder 설정
    static let placeholder = UIImage(
        systemName: "placeholdertext.fill"
    )?.withTintColor(.secondarySystemBackground)

    // 색상적용
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            self.size, false, self.scale
        )
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

}
