//
//  LoginViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/05.
//

import SnapKit
import Toast_Swift
import UIKit

final class LoginViewController: UIViewController {
    private var presenter: LoginPresenter!

    // 인사 label
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30.0, weight: .bold)
        label.text = "안녕하세요\nShoppingApp입니다"
        label.numberOfLines = 2

        return label
    }()

    // 이메일 입력 textField
    private lazy var emailTextField: ShoppingAppTextField = {
        let textField = ShoppingAppTextField(
            style: .email
        )
        textField.delegate = self

        return textField
    }()

    // 비밀번호 입력 textField
    private lazy var passwordTextField: ShoppingAppTextField = {
        let textField = ShoppingAppTextField(
            style: .password
        )
        textField.delegate = self

        return textField
    }()

    // 이메일 로그인 버튼
    private lazy var emailLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .brown
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(
            ofSize: 19.0,
            weight: .semibold
        )
        button.addTarget(
            self,
            action: #selector(didTapEmailLoginButton),
            for: .touchUpInside
        )

        return button
    }()

    // 애플 이메일 버튼
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apple로 계속하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setImage(
            UIImage(
                named: "Logo - SIWA - Left-aligned - White - Medium"
            ),
            for: .normal
        )
        button.titleLabel?.font = .systemFont(
            ofSize: 19.0,
            weight: .semibold
        )
        button.addTarget(
            self,
            action: #selector(didTapAppleButton),
            for: .touchUpInside
        )

        return button
    }()

    // 구글 로그인 버튼
    private lazy var googleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Google로 계속하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.setImage(
            UIImage(
                named: "logo_google"
            ),
            for: .normal
        )
        button.titleLabel?.font = .systemFont(
            ofSize: 19.0,
            weight: .semibold
        )
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(
            self,
            action: #selector(didTapGoogleButton),
            for: .touchUpInside
        )

        return button
    }()

    // 신규가입 버튼
    private lazy var userCreateButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black

        let button = UIButton(configuration: config)
        let string = "👉 아직 가입하지 않았다면? 회원가입하기"
        let title = NSMutableAttributedString(
            string: string
        )
        title.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.thick.rawValue,
            range: (string as NSString).range(of: "회원가입하기")
        )
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapUserCreateButton),
            for: .touchUpInside
        )

        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = LoginPresenter(viewController: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesBegan(touches, with: event)

        presenter.touchesBegan()
    }

}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        return presenter.textFieldShouldReturn()
    }

    func textFieldDidEndEditing(
        _ textField: UITextField
    ) {
        let textField = textField as! ShoppingAppTextField
        presenter.textFieldDidEndEditing(
            identifier: textField.identifier,
            text: textField.text
        )
    }

}

extension LoginViewController: LoginViewProtocol {

    func configureView() {
        view.backgroundColor = .systemBackground
    }

    func configureNavigationBar() {
        let backBarButton = ShoppingAppBarButtonItem(
            barButtonItemStyle: .back,
            target: self,
            action: #selector(didTapBackBarButton)
        )

        navigationItem.rightBarButtonItem = backBarButton
        navigationItem.backButtonTitle = ""
    }

    func configureHierarchy() {
        [
            greetingLabel,
            emailTextField,
            passwordTextField,
            emailLoginButton,
            appleButton,
            googleButton,
            userCreateButton
        ].forEach { view.addSubview($0) }


        let inset: CGFloat = 16.0
        let height: CGFloat = 44.0
        let spacing: CGFloat = 16.0
        let textFieldHeight: CGFloat = 44.0

        greetingLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(inset)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(inset)
            make.height.equalTo(textFieldHeight)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(inset)
            make.bottom.equalTo(view.snp.centerY).offset(-spacing)
            make.height.equalTo(textFieldHeight)
        }

        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        appleButton.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        googleButton.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        userCreateButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(inset)
        }
    }

    func dismissLoginViewController(animated: Bool) {
        dismiss(animated: animated)
    }

    func viewEndEditing(_ isEndEditing: Bool) {
        view.endEditing(isEndEditing)
    }

    func pushToUserCreateTabmanViewController() {
        let userCreateTabmanViewController = UserCreateTabmanViewController()
        navigationController?.pushViewController(
            userCreateTabmanViewController,
            animated: true
        )
    }

    func emailTextFieldEndEditing() {
        emailTextField.endEditing(true)
    }

    func passwordTextFieldEndEditing() {
        passwordTextField.endEditing(true)
    }

    func presentErrorToast(message: String) {
        view.makeToast(
            message,
            position: .top
        )
    }

}

private extension LoginViewController {

    @objc
    func didTapBackBarButton(_ sender: UIBarButtonItem) {
        presenter.didTapBackBarButton()
    }

    @objc
    func didTapEmailLoginButton(_ sender: UIButton) {
        presenter.didTapEmailLoginButton()
    }

    @objc
    func didTapGoogleButton(_ sender: UIButton) {
        presenter.didTapGoogleButton()
    }

    @objc
    func didTapAppleButton(_ sender: UIButton) {
        presenter.didTapAppleButton()
    }

    @objc
    func didTapUserCreateButton(_ sender: UIButton) {
        presenter.didTapUserCreateButton()
    }

}
