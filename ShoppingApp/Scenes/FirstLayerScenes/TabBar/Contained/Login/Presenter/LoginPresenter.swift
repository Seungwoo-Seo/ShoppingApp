//
//  LoginPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/05.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import AuthenticationServices

protocol LoginViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureView()
    /// 서브 뷰 추가 및 레아이웃 설정
    func configureHierarchy()
    /// loginViewController Scene 닫기
    func dismissLoginViewController(animated: Bool)
    /// view의 first Responder 해제하기
    func viewEndEditing(_ isEndEditing: Bool)
    /// userCreateTabmanViewController로 push
    func pushToUserCreateTabmanViewController()

    func emailTextFieldEndEditing()
    func passwordTextFieldEndEditing()
    func presentErrorToast(message: String)
}

final class LoginPresenter: NSObject {
    private weak var viewController: LoginViewProtocol!
    private let firebaseAuthManager: FirebaseAuthManagerProtocol

    // 이메일
    private var email: String?
    // 비밀번호
    private var password: String?
    // 애플 로그인 nonce
    private var currentNonce: String?

    init(
        viewController: LoginViewProtocol,
        firebaseAuthManager: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared
    ) {
        self.viewController = viewController
        self.firebaseAuthManager = firebaseAuthManager
    }

    // LoginViewController가 viewDidLoad될 때 호출
    func viewDidLoad() {
        viewController.configureNavigationBar()
        viewController.configureView()
        viewController.configureHierarchy()
    }

    // view를 터치하면 호출
    func touchesBegan() {
        viewController.viewEndEditing(true)
    }

}

// view의 UITextFieldDelegate extension
extension LoginPresenter {

    // 키보드 리턴 누르면 호출
    func textFieldShouldReturn() -> Bool {
        viewController.viewEndEditing(true)
        return false
    }

    func textFieldDidEndEditing(
        identifier: ShoppingAppTextFieldStyle,
        text: String?
    ) {
        switch identifier {
        case .email:
            email = text

        case .password:
            password = text

        default:
            fatalError("있을 수 없는 텍스트필드")
        }
    }

}

// nonce 생성 및 apple로 로그인 로직
extension LoginPresenter: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce
            else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            guard let appleIDToken = appleIDCredential.identityToken
            else {
                print("Unable to fetch identity token")
                return
            }

            guard let idTokenString = String(
                data: appleIDToken,
                encoding: .utf8
            )
            else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )

            firebaseAuthManager.signIn(
                with: credential
            ) { [weak self] in
                self?.viewController.dismissLoginViewController(animated: true)
            }
        }
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }

}

extension LoginPresenter: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        let loginViewController = viewController as! LoginViewController
        return loginViewController.view.window!
    }

}

// view의 private extension
extension LoginPresenter {

    // backBarButton touchUpInside할 때 호출
    func didTapBackBarButton() {
        viewController.dismissLoginViewController(
            animated: true
        )
    }

    // emailButton touchUpInside할 때 호출
    func didTapEmailLoginButton() {
        startSignInWithEmailFlow()
    }

    // googleButton touchUpInside할 때 호출
    func didTapGoogleButton() {
        startSignInWithGoogleFlow()
    }

    // appleButton touchUpInside할 때 호출
    func didTapAppleButton() {
        startSignInWithAppleFlow()
    }

    // userCreateButton touchUpInside할 때 호출
    func didTapUserCreateButton() {
        viewController.pushToUserCreateTabmanViewController()
    }

}

private extension LoginPresenter {

    // email로 로그인 시작
    func startSignInWithEmailFlow() {
        viewController.emailTextFieldEndEditing()
        viewController.passwordTextFieldEndEditing()

        guard let email = email,
              let password = password,
              !email.isEmpty,
              !password.isEmpty
        else {
            viewController.presentErrorToast(
                message: "아이디, 비밀번호를 확인하세요."
            )
            return
        }

        firebaseAuthManager.signIn(
            email: email,
            password: password
        ) { [weak self] in
            if $0 {
                self?.viewController.dismissLoginViewController(
                    animated: true
                )
            } else {
                self?.viewController.presentErrorToast(
                    message: "현재 로그인 할 수 없습니다."
                )
            }
        }
    }

    // google로 로그인 시작
    func startSignInWithGoogleFlow() {
        guard let clientID = FirebaseApp.app()?.options.clientID
        else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(
            withPresenting: viewController as! UIViewController
        ) { [unowned self] (result, error) in
            guard error == nil else {return}

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {return}

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            self.firebaseAuthManager.signIn(
                with: credential
            ) {

                self.viewController.dismissLoginViewController(
                    animated: true
                )
            }
        }
    }

    // apple로 로그인 시작
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

}
