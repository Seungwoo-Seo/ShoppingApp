//
//  String+.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/19.
//

import Foundation

extension String {

    /// html String을 디코딩 해주는 생성자
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(
            using: .utf8
        ) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else {
            return nil
        }

        self.init(attributedString.string)
    }

}
