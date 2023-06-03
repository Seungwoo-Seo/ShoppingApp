//
//  ShoppingAppTextField.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/16.
//

import UIKit

enum ShoppingAppTextFieldStyle {
    case email
    case password
    case name
    case phoneNumber
}

final class ShoppingAppTextField: UITextField {
    private let style: ShoppingAppTextFieldStyle

    var identifier: ShoppingAppTextFieldStyle {
        return style
    }

    init(style: ShoppingAppTextFieldStyle) {
        self.style = style
        super.init(frame: .zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        switch style {
        case .email:
            placeholder = "이메일 입력"
            textContentType = .emailAddress
            keyboardType = .emailAddress

        case .password:
            placeholder = "비밀번호 입력"
            // 저장된 비밀번호를 가져오는 것이 아니라
            // 사용자가 직접 입력하기 위해 .password를 사용
            textContentType = .password
            isSecureTextEntry = true

        case .name:
            placeholder = "이름 입력"
            textContentType = .name

        case .phoneNumber:
            placeholder = "- 없이 입력"
            textContentType = .telephoneNumber
            keyboardType = .numberPad
        }

        // 공통 설정
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        smartDashesType = .no
        smartInsertDeleteType = .no
        smartQuotesType = .no

        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        clipsToBounds = true
        addLeftPadding(8.0)
    }

}
