//
//  UserCreatePresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/09.
//

import Foundation

protocol UserCreateEmailPasswordViewProtocol: AnyObject {
    func configureHierarchy()
    func addNotification()
    func removeNotification()
    func moveUpNextButton(
        duration: TimeInterval,
        translationX: CGFloat,
        y: CGFloat
    )
    func moveDownNextButton(transform: CGAffineTransform)
    func viewEndEditing(_ isEndEditing: Bool)



    func emailTextFieldUpdate(isEvaluated: Bool)
    func emailErrorLabelUpdate(
        with text: String?,
        isHidden: Bool
    )
    func passwordTextFieldUpdate(isEvaluated: Bool)
    func passwordErrorLabelUpdate(
        with text: String?,
        isHidden: Bool
    )

    func emailOverlapCheckButton(isEnabled: Bool)
    func nextButton(isEnabled: Bool)

    func emailTextFieldEndEditing()
    func passwordTextFieldEndEditing()

    func confirmAlertToPresent(
        title: String?,
        message: String?
    )
}

final class UserCreateEmailPasswordPresenter {
    // view
    private weak var viewController: UserCreateEmailPasswordViewProtocol!

    // apis
    private let firebaseFireStoreManager: FirebaseFireStoreManagerProtocol
    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let regexEvaluateManager: RegexEvaluateManagerProtocol

    //datas
    /// 이메일
    private var email: String?
    /// 비밀번호
    private var password: String?
    /// 이메일 사용가능 여부
    private var emailCheck: Bool = false
    /// 비밀번호 사용가능 여부
    private var passwordCheck: Bool = false

    // 생성자
    init(
        viewController: UserCreateEmailPasswordViewProtocol,
        firebaseFireStoreManager: FirebaseFireStoreManagerProtocol = FirebaseFireStoreManager.shared,
        firebaseAuthMananger: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared,
        regexEvaluateManager: RegexEvaluateManagerProtocol = RegexEvaluateManager()
    ) {
        self.viewController = viewController
        self.firebaseFireStoreManager = firebaseFireStoreManager
        self.firebaseAuthManager = firebaseAuthMananger
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

// UItextFieldDelegate
extension UserCreateEmailPasswordPresenter {

    // 텍스트 필드 작성이 끝나면 호출
    func textFieldDidEndEditing(
        identifier: ShoppingAppTextFieldStyle,
        text: String?
    ) {
        switch identifier {
            // emailTextField
        case .email:
            // UserCreateTabmanPresenter로 보낼 이메일
            email = text

            // passwordTextField
        case .password:
            // UserCreateTabmanPresenter로 보낼 비밀번호
            password = text

        default:
            fatalError(
                "이메일, 비밀번호 style이 아닌 textField가 동작했음"
            )
        }
    }

    // 텍스트 필드 입력이 있을 때마다 호출
    func textField(
        identifier: ShoppingAppTextFieldStyle,
        textFieldText: String?,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        // NSRange
        // location: 배열에서 현재 원소의 index 위치
        // length: 이전 배열과 비교했을 때 현재 배열에서 변경된 원소의 개수 (추가될때 값은 0, 하나가 삭제되면 값은 1)

        // Range(range, in: text): 갱신된 range값과 기존 string을 가지고 객체 변환: NSRange > Range
        guard let oldString = textFieldText,
              let newRange = Range(range, in: oldString)
        else { return true }

        // range값과 inputString을 가지고 replacingCharacters(in:with:)을 이용하여 string 업데이트
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
            // emailTextField
        case .email:
            // 이메일이 비었을 때
            // 1. emailTextField의 layer 업데이트
            // 2. emailErrorLabel 업데이트
            // 3. emailOverlapCheckButton 비활성화
            if newString.isEmpty {
                viewController.emailTextFieldUpdate(
                    isEvaluated: false
                )
                viewController.emailErrorLabelUpdate(
                    with: "이메일을 입력하세요!",
                    isHidden: false
                )
                viewController.emailOverlapCheckButton(isEnabled: false)
            }

            // 이메일이 정규식을 통과했을 때
            // 1. emailTextField의 layer 업데이트
            // 2. emailErrorLabel 업데이트
            // 3. emailOverlapCheckButton 활성화
            else if regexEvaluateManager.email(newString) {
                viewController.emailTextFieldUpdate(
                    isEvaluated: true
                )
                viewController.emailErrorLabelUpdate(
                    with: nil,
                    isHidden: true
                )
                viewController.emailOverlapCheckButton(isEnabled: true)
            }

            // 이메일이 정규식을 통과하지 못했을 때
            // 1. emailTextField의 layer 업데이트
            // 2. emailErrorLabel 업데이트
            // 3. emailOverlapCheckButton 비활성화
            else {
                viewController.emailTextFieldUpdate(
                    isEvaluated: false
                )
                viewController.emailErrorLabelUpdate(
                    with: "이메일 형식에 맞지 않습니다",
                    isHidden: false
                )
                viewController.emailOverlapCheckButton(isEnabled: false)
            }

            // 이메일은 무조건 중복 확인을 통해서만 체크하기 위해서!
            emailCheck = false

            // passwordTextField
        case .password:
            // 비밀번호가 비었을 때
            // 1. passwordTextField의 layer 업데이트
            // 2. passwordErrorLabel 업데이트
            // 3. passwordCheck = false
            if newString.isEmpty {
                viewController.passwordTextFieldUpdate(
                    isEvaluated: false
                )
                viewController.passwordErrorLabelUpdate(
                    with: "비밀번호를 입력하세요!",
                    isHidden: false
                )
                passwordCheck = false
            }

            // 비밀번호가 정규식을 통과했을 때
            // 1. passwordTextField의 layer 업데이트
            // 2. passwordErrorLabel 업데이트
            // 3. passwordCheck = true
            else if regexEvaluateManager.password(newString) {
                viewController.passwordTextFieldUpdate(
                    isEvaluated: true
                )
                viewController.passwordErrorLabelUpdate(
                    with: nil,
                    isHidden: true
                )
                passwordCheck = true
            }

            // 비밀번호가 정규식을 통과하지 못했을 때
            // 1. passwordTextField의 layer 업데이트
            // 2. passwordErrorLabel 업데이트
            // 3. passwordCheck = false
            else {
                viewController.passwordTextFieldUpdate(
                    isEvaluated: false
                )
                viewController.passwordErrorLabelUpdate(
                    with: "비밀번호는 반드시 영문자, 숫자, 특수문자를 하나 이상 포함하고 8글자 이상입니다.",
                    isHidden: false
                )
                passwordCheck = false
            }

        default:
            fatalError(
                "이메일, 비밀번호 style이 아닌 textField가 동작했음"
            )
        }

        // nextButton을 활성화 할 건지 체크
        nextButtonIsEnabledCheck()

        return true
    }

}

// private
extension UserCreateEmailPasswordPresenter {

    // 키보드가 보여지려 할 때
    func keyboradWillShow(
        _ notification: NSNotification,
        safeAreaInsetsBottom: CGFloat
    ) {
        if let keyboardSize = (notification.userInfo?[NSNotification.Name.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            // 다음 버튼을 키보드 위로 이동
            viewController.moveUpNextButton(
                duration: 0.3,
                translationX: 0,
                y: -(keyboardSize.height - safeAreaInsetsBottom)
            )
        }
    }

    // 키보드가 숨겨지려 할때
    func keyboradWillHide() {
        // 다음 버튼 원래 위치로
        viewController.moveDownNextButton(
            transform: .identity
        )
    }

    // emailOverlapCheckButton Tap하면 호출
    func didTapEmailOverlapCheckButton() {
        // 1. emailTextField 입력 종료
        viewController.emailTextFieldEndEditing()

        // 2. 이메일 중복 체크
        // - checkButton을 tap하려면 이미 정규식을 통과해야하기 때문에
        // - !를 사용
        firebaseFireStoreManager.emailCheck(email!) { [weak self] in
            // 사용 가능할 때
            // alert Present
            // emailCheck -> true
            if $0 {
                self?.viewController.confirmAlertToPresent(
                    title: "사용 가능한 이메일입니다.",
                    message: nil
                )
                self?.emailCheck = true
            }

            // 중복되었을 때
            // alert Present
            // emailCheck -> false
            else {
                self?.viewController.confirmAlertToPresent(
                    title: "중복된 이메일입니다.",
                    message: nil
                )
                self?.emailCheck = false
            }

            // 다음 버튼을 활성화 할 건지 체크
            self?.nextButtonIsEnabledCheck()
        }
    }

    // nextButton Tap하면 호출
    func didTapNextButton() {
        // 1. emailTextField, passwordTextField 입력 종료
        viewController.emailTextFieldEndEditing()
        viewController.passwordTextFieldEndEditing()

        // 2. emailCheck, passwordCheck true인지 확인
        guard emailCheck
        else {
            viewController.confirmAlertToPresent(
                title: "이메일 중복 확인을 해주세요!",
                message: nil
            )
            return
        }
        guard passwordCheck
        else {
            viewController.confirmAlertToPresent(
                title: "비밀번호를 확인을 해주세요!",
                message: nil
            )
            return
        }

        // 3. password isEmpty인지 확인
        // - password는 다시 선택 시 내용이 다 날라기 때문
        guard password?.isEmpty == false
        else {
            viewController.confirmAlertToPresent(
                title: "비밀번호를 입력하세요!",
                message: nil
            )
            return
        }

        // 4. Notification에 email과 password 전송
        notificationPost(
            email: email!,
            password: password!
        )
    }
    
}

private extension UserCreateEmailPasswordPresenter {

    // nextButton을 활성화 할 건지 체크하는 메소드
    func nextButtonIsEnabledCheck() {
        if emailCheck && passwordCheck {
            viewController.nextButton(
                isEnabled: true
            )
        } else {
            viewController.nextButton(
                isEnabled: false
            )
        }
    }

    // Notification에 email과 password 전송하는 메소드
    func notificationPost(
        email: String,
        password: String
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name.emailPasswordSucces,
            object: nil,
            userInfo: [
                "email": email,
                "password": password
            ]
        )
    }

}
