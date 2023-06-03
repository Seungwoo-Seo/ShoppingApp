//
//  Button.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/18.
//

import UIKit

enum Button {
    case liked

    var icon: (image: UIImage?, selectedImage: UIImage?) {
        switch self {
        case .liked:
            let pointSize: CGFloat = 20.0
            let symbolConfig = UIImage.SymbolConfiguration(
                pointSize: pointSize
            )

            return (
                UIImage(
                    systemName: "heart",
                    withConfiguration: symbolConfig
                ),
                UIImage(
                    systemName: "heart.fill",
                    withConfiguration: symbolConfig
                )
            )
        }
    }

}
