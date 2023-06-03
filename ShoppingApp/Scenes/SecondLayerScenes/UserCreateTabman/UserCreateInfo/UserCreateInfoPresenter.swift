//
//  UserCreateInfoPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/15.
//

import Foundation

protocol UserCreateInfoViewProtocol: AnyObject {
    func configureHierarchy()
    func addNotification()
    func removeNotification()
    func viewEndEditing(_ isEndEditing: Bool)
    func moveUpUserCreateEndButton(
        duration: TimeInterval,
        translationX: CGFloat,
        y: CGFloat
    )
    func moveDownUserCreateEndButton(
        transform: CGAffineTransform
    )

    func nameTextFieldUpdate(isEvaluated: Bool)
    func nameErrorLabelUpdate(
        with text: String?,
        isHidden: Bool
    )
    func phoneNumberTextFieldUpdate(isEvaluated: Bool)
    func phoneNumberErrorLabelUpdate(
        with text: String?,
        isHidden: Bool
    )
    func userCreateEndButton(isEnabled: Bool)
    func nameTextFieldEndEditing()
    func phoneNumberTextFieldEndEditing()
    func confirmAlertToPresent(
        title: String?,
        message: String?
    )
}

final class UserCreateInfoPresenter: NSObject {
    // view
    private weak var viewController: UserCreateInfoViewProtocol!

    // apis
    private let regexEvaluateManager: RegexEvaluateManagerProtocol

    // 이름
    private var name: String?
    // 휴대폰 번호
    private var phoneNumber: String?
    // 이름 사용가능 여부
    private var nameCheck: Bool = false
    // 휴대폰 사용가능 여부
    private var phoneNumberCheck: Bool = false

    // 생성자
    init(
        viewController: UserCreateInfoViewProtocol!,
        regexEvaluateManager: RegexEvaluateManagerProtocol = RegexEvaluateManager()
    ) {
        self.viewController = viewController
        self.regexEvaluateManager = regexEvaluateManager
    }

    // Life Cycles
    func viewDidLoad() {
        viewController.configureHierarchy()
    }

    func viewWillAppear() {
        viewController.addNotification()
    }

    func viewWillDisappear() {
        viewController.removeNotification()
    }

    // overrides
    func touchesBegan() {
        viewController.viewEndEditing(true)
    }

}

// UITextFieldDelegate
extension UserCreateInfoPresenter {

    // 텍스트 필드 작성이 끝나면 호출
    func textFieldDidEndEditing(
        identifier: ShoppingAppTextFieldStyle,
        text: String?
    ) {
        switch identifier {
        // nameTextField
        case .name:
            // UserCreateTabmanPresenter로 보낼 이름
            name = text

        // phoneNumberTextField
        case .phoneNumber:
            // UserCreateTabmanPresenter로 보낼 휴대폰 번호
            phoneNumber = text

        default:
            fatalError(
                "이름, 휴대폰 번호 style이 아닌 textField가 동작했음"
            )
        }
    }

    func textField(
        identifier: ShoppingAppTextFieldStyle,
        textFieldText: String?,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let oldString = textFieldText,
              let newRange = Range(range, in: oldString)
        else { return true }

        let inputString = string.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let newString = oldString
            .replacingCharacters(
                in: newRange,
                with: inputString
            )
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        switch identifier {
        // nameTextField
        case .name:
            // 이름이 비었을 때
            // 1. nameTextField의 layer 업데이트
            // 2. nameErrorLabel 업데이트
            // 3. nameCheck = false
            if newString.isEmpty {
                viewController.nameTextFieldUpdate(
                    isEvaluated: false
                )
                viewController.nameErrorLabelUpdate(
                    with: "이름을 입력하세요!",
                    isHidden: false
                )
                nameCheck = false
            }

            // 이름이 정규식을 통과했을 때
            // 1. nameTextField의 layer 업데이트
            // 2. nameErrorLabel 업데이트
            // 3. nameCheck = true
            else if regexEvaluateManager.name(newString) {
                viewController.nameTextFieldUpdate(
                    isEvaluated: true
                )
                viewController.nameErrorLabelUpdate(
                    with: nil,
                    isHidden: true
                )
                nameCheck = true
            }

            // 이름이 정규식을 통과하지 못했을 때
            // 1. nameTextField의 layer 업데이트
            // 2. nameErrorLabel 업데이트
            // 3. nameCheck = false
            else {
                viewController.nameTextFieldUpdate(
                    isEvaluated: false
                )
                viewController.nameErrorLabelUpdate(
                    with: "한글만 사용가능하고 2글자 이상입니다.",
                    isHidden: false
                )
                nameCheck = false
            }

        // phoneNumberTextField
        case .phoneNumber:
            // 휴대폰 번호가 비었을 때
            // 1. phoneNumberTextField의 layer 업데이트
            // 2. phoneNumberErrorLabel 업데이트
            // 3. phoneNumberCheck = false
            if newString.isEmpty {
                viewController.phoneNumberTextFieldUpdate(
                    isEvaluated: false
                )
                viewController.phoneNumberErrorLabelUpdate(
                    with: "휴대폰 번호를 입력하세요!",
                    isHidden: false
                )
                phoneNumberCheck = false
            }

            // 휴대폰 번호가 정규식을 통과했을 때
            // 1. phoneNumberTextField의 layer 업데이트
            // 2. phoneNumberErrorLabel 업데이트
            // 3. phoneNumberCheck = true
            else if regexEvaluateManager.phoneNumber(newString) {
                viewController.phoneNumberTextFieldUpdate(
                    isEvaluated: true
                )
                viewController.phoneNumberErrorLabelUpdate(
                    with: nil,
                    isHidden: true
                )
                phoneNumberCheck = true
            }

            // 휴대폰 번호가 정규식을 통과하지 못했을 때
            // 1. phoneNumberTextField의 layer 업데이트
            // 2. phoneNumberErrorLabel 업데이트
            // 3. phoneNumberCheck = false
            else {
                viewController.phoneNumberTextFieldUpdate(
                    isEvaluated: false
                )
                viewController.phoneNumberErrorLabelUpdate(
                    with: "숫자만 사용가능하고 10글자 이상 11글자 이하입니다.",
                    isHidden: false
                )
                phoneNumberCheck = false
            }

        default:
            fatalError(
                "이름, 휴대폰 번호 style이 아닌 textField가 동작했음"
            )
        }

        // userCreateEndButton을 활성화 할 건지 체크
        userCreateEndButtonIsEnabledCheck()

        return true
    }

}

// private
extension UserCreateInfoPresenter {

    // 키보드가 보여지려 할 때
    func keyboradWillShow(
        _ notification: NSNotification,
        safeAreaInsetsBottom: CGFloat
    ) {
        if let keyboardSize = (notification.userInfo?[NSNotification.Name.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            // 다음 버튼을 키보드 위로 이동
            viewController.moveUpUserCreateEndButton(
                duration: 0.3,
                translationX: 0,
                y: -(keyboardSize.height - safeAreaInsetsBottom)
            )
        }
    }

    // 키보드가 숨겨지려 할때
    func keyboradWillHide() {
        // 다음 버튼 원래 위치로
        viewController.moveDownUserCreateEndButton(
            transform: .identity
        )
    }

    // userCreateEndButton을 tap 했을 때
    func didTapUserCreateEndButton() {
        // 1. nameTextField, phoneNumberTextField 입력 종료
        viewController.nameTextFieldEndEditing()
        viewController.phoneNumberTextFieldEndEditing()

        // 2. nameCheck, phoneNumberCheck true인지 확인
        guard nameCheck
        else {
            viewController.confirmAlertToPresent(
                title: "이름을 확인해주세요!",
                message: nil
            )
            return
        }
        guard phoneNumberCheck
        else {
            viewController.confirmAlertToPresent(
                title: "휴대폰 번호를 확인해주세요!",
                message: nil
            )
            return
        }

        // 4. Notification에 name과 phoneNumber 전송
        notificationPost(
            name: name!,
            phoneNumber: phoneNumber!
        )
    }

}

private extension UserCreateInfoPresenter {

    // userCreateEndButton을 활성화 할 건지 체크하는 메소드
    func userCreateEndButtonIsEnabledCheck() {
        if nameCheck && phoneNumberCheck {
            viewController.userCreateEndButton(
                isEnabled: true
            )
        } else {
            viewController.userCreateEndButton(
                isEnabled: false
            )
        }
    }

    // Notification에 name과 phoneNumber 전송하는 메소드
    func notificationPost(
        name: String,
        phoneNumber: String
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name.namePhoneNumberSucces,
            object: nil,
            userInfo: [
                "name": name,
                "phoneNumber": phoneNumber
            ]
        )
    }

}
