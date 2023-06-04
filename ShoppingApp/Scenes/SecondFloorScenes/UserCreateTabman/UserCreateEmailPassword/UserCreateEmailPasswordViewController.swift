//
//  UserCreateEmailPasswordViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/09.
//

import SnapKit
import UIKit

final class UserCreateEmailPasswordViewController: UIViewController {
    private var presenter: UserCreateEmailPasswordPresenter!

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일을 작성해주세요"
        label.font = .systemFont(ofSize: 28.0, weight: .bold)

        return label
    }()

    private lazy var emailTextField: ShoppingAppTextField = {
        let textField = ShoppingAppTextField(
            style: .email
        )
        textField.delegate = self
        textField.setContentHuggingPriority(
            .init(250),
            for: .horizontal
        )

        return textField
    }()

    private lazy var emailOverlapCheckButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "중복 확인"

        let button = UIButton(configuration: config)
        button.isEnabled = false
        button.configurationUpdateHandler = { button in
            if button.isEnabled {
                button.configuration?.baseForegroundColor = .white
                button.configuration?.background.backgroundColor = .black
            } else {
                button.configuration?.background.backgroundColor = .secondarySystemBackground
            }
        }
        button.setContentHuggingPriority(
            .init(251),
            for: .horizontal
        )
        button.addTarget(
            self,
            action: #selector(didTapEmailOverlapCheckButton),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var emailHorizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.emailTextField,
                self.emailOverlapCheckButton
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0

        return stackView
    }()

    private lazy var emailErrorLabel: ShoppingAppLabel = {
        let label = ShoppingAppLabel(
            style: .error
        )

        return label
    }()

    private lazy var emailVerticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.emailHorizontalStackView,
                self.emailErrorLabel
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4.0

        return stackView
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호를 작성해주세요"
        label.font = .systemFont(ofSize: 28.0, weight: .bold)

        return label
    }()

    private lazy var passwordTextField: ShoppingAppTextField = {
        let textField = ShoppingAppTextField(
            style: .password
        )
        textField.delegate = self

        return textField
    }()

    private lazy var passwordErrorLabel: ShoppingAppLabel = {
        let label = ShoppingAppLabel(
            style: .error
        )
        return label
    }()

    private lazy var passwordVerticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.passwordTextField,
                self.passwordErrorLabel
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4.0

        return stackView
    }()

    private lazy var nextButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "다음"

        let button = UIButton(configuration: config)
        button.isEnabled = false
        button.configurationUpdateHandler = { button in
            if button.isEnabled {
                button.configuration?.baseForegroundColor = .white
                button.configuration?.background.backgroundColor = .black
            } else {
                button.configuration?.background.backgroundColor = .secondarySystemBackground
            }
        }
        button.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )

        return button
    }()


    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = UserCreateEmailPasswordPresenter(viewController: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter.viewWillDisappear()
    }

    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesBegan(touches, with: event)

        presenter.touchesBegan()
    }

}

extension UserCreateEmailPasswordViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        let textField = textField as! ShoppingAppTextField

        presenter.textFieldDidEndEditing(
            identifier: textField.identifier,
            text: textField.text
        )
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let textField = textField as! ShoppingAppTextField

        return presenter.textField(
            identifier: textField.identifier,
            textFieldText: textField.text,
            shouldChangeCharactersIn: range,
            replacementString: string
        )
    }

}

extension UserCreateEmailPasswordViewController: UserCreateEmailPasswordViewProtocol {

    func configureHierarchy() {
        [
            emailLabel,
            emailVerticalStackView,
            passwordLabel,
            passwordVerticalStackView,
            nextButton
        ].forEach { view.addSubview($0) }

        let margin: CGFloat = 16.0
        let textFieldHeight: CGFloat = 44.0
        let spacing: CGFloat = 16.0
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(margin * 2)
            make.leading.trailing.equalToSuperview().inset(margin)
        }

        emailHorizontalStackView.snp.makeConstraints { make in
            make.height.equalTo(textFieldHeight)
        }

        emailVerticalStackView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(margin)
        }

        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailHorizontalStackView.snp.bottom).offset(textFieldHeight)
            make.leading.trailing.equalToSuperview().inset(margin)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(textFieldHeight)
        }

        passwordVerticalStackView.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(margin)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(margin)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(textFieldHeight)
        }
    }

    func addNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboradWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboradWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func removeNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    func viewEndEditing(_ isEndEditing: Bool) {
        view.endEditing(isEndEditing)
    }

    func moveUpNextButton(
        duration: TimeInterval,
        translationX: CGFloat,
        y: CGFloat
    ) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.nextButton.transform =
            CGAffineTransform(
                translationX: translationX,
                y: y
            )
        }
    }

    func moveDownNextButton(transform: CGAffineTransform) {
        nextButton.transform = transform
    }



    func emailTextFieldUpdate(isEvaluated: Bool) {
        if isEvaluated {
            emailTextField.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        } else {
            emailTextField.layer.borderColor = UIColor.red.cgColor
        }
    }

    func emailErrorLabelUpdate(
        with text: String?,
        isHidden: Bool
    ) {
        emailErrorLabel.text = text
        emailErrorLabel.isHidden = isHidden
    }

    func passwordTextFieldUpdate(isEvaluated: Bool) {
        if isEvaluated {
            passwordTextField.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        } else {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
        }
    }

    func passwordErrorLabelUpdate(
        with text: String?,
        isHidden: Bool
    ) {
        passwordErrorLabel.text = text
        passwordErrorLabel.isHidden = isHidden
    }

    func emailOverlapCheckButton(isEnabled: Bool) {
        emailOverlapCheckButton.isEnabled = isEnabled
    }

    func nextButton(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
    }

    func emailTextFieldEndEditing() {
        emailTextField.endEditing(true)
    }

    func passwordTextFieldEndEditing() {
        passwordTextField.endEditing(true)
    }

    func confirmAlertToPresent(
        title: String?,
        message: String?
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(
            title: "확인",
            style: .default
        )
        alert.addAction(confirm)
        present(alert, animated: true)
    }

}

private extension UserCreateEmailPasswordViewController {

    @objc
    func keyboradWillShow(_ notification: NSNotification) {
        presenter.keyboradWillShow(
            notification,
            safeAreaInsetsBottom: view.safeAreaInsets.bottom
        )
    }

    @objc
    func keyboradWillHide(_ notification: NSNotification) {
        presenter.keyboradWillHide()
    }

    @objc
    func didTapEmailOverlapCheckButton(_ sender: UIButton) {
        presenter.didTapEmailOverlapCheckButton()
    }

    @objc
    func didTapNextButton(_ sender: UIButton) {
        presenter.didTapNextButton()
    }

}
