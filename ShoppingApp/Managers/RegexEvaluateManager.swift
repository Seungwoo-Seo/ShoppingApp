//
//  RegexEvaluateManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/13.
//

import Foundation

protocol RegexEvaluateManagerProtocol {
    func email(_ string: String) -> Bool
    func password(_ string: String) -> Bool
    func name(_ string: String) -> Bool
    func phoneNumber(_ string: String) -> Bool
}

struct RegexEvaluateManager: RegexEvaluateManagerProtocol {

    func email(_ string: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        return evaluate(
            regex: emailRegex,
            string: string
        )
    }

    func password(_ string: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"

        return evaluate(
            regex: passwordRegex,
            string: string
        )
    }

    func name(_ string: String) -> Bool {
        let nameRegex = "[가-힣ㄱ-ㅎㅏ-ㅣ]{2,}"

        return evaluate(
            regex: nameRegex,
            string: string
        )
    }

    func phoneNumber(_ string: String) -> Bool {
        let phoneNumberRegex = "^01[0-1, 7][0-9]{7,8}$"

        return evaluate(
            regex: phoneNumberRegex,
            string: string
        )
    }

}

private extension RegexEvaluateManager {

    func evaluate(
        regex: String,
        string: String
    ) -> Bool {
        let predicate = NSPredicate(
            format: "SELF MATCHES %@",
            regex
        )

        return predicate.evaluate(with: string)
    }

}
