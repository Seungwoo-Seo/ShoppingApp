//
//  UserCreateInfoViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/15.
//

import SnapKit
import UIKit

final class UserCreateInfoViewController: UIViewController {
    private var presenter: UserCreateInfoPresenter!

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름을 작성해주세요"
        label.font = .systemFont(
            ofSize: 28.0,
            weight: .bold
        )

        return label
    }()

    private lazy var nameTextField: ShoppingAppTextField = {
        let textField = ShoppingAppTextField(
            style: .name
        )
        textField.delegate = self

        return textField
    }()

    private lazy var nameErrorLabel: ShoppingAppLabel = {
        let label = ShoppingAppLabel(
            style: .error
        )

        return label
    }()

    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대폰 번호를 작성해주세요"
        label.font = .systemFont(
            ofSize: 28.0,
            weight: .bold
        )

        return label
    }()

    private lazy var phoneNumberTextField: ShoppingAppTextField = {
        let textField = ShoppingAppTextField(
            style: .phoneNumber
        )
        textField.delegate = self

        return textField
    }()

    private lazy var phoneNumberErrorLabel: ShoppingAppLabel = {
        let label = ShoppingAppLabel(
            style: .error
        )

        return label
    }()

    private lazy var userCreateEndButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "가입하기"

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
            action: #selector(didTapUserCreateEndButton),
            for: .touchUpInside
        )

        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = UserCreateInfoPresenter(viewController: self)
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

extension UserCreateInfoViewController: UITextFieldDelegate {

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

extension UserCreateInfoViewController: UserCreateInfoViewProtocol {

    func configureHierarchy() {
        let stackViewSpacing: CGFloat = 4.0
        let nameStackView = UIStackView(
            arrangedSubviews: [
                nameTextField,
                nameErrorLabel
            ]
        )
        nameStackView.axis = .vertical
        nameStackView.distribution = .fill
        nameStackView.alignment = .fill
        nameStackView.spacing = stackViewSpacing

        let phoneNumberStackView = UIStackView(
            arrangedSubviews: [
                phoneNumberTextField,
                phoneNumberErrorLabel
            ]
        )
        phoneNumberStackView.axis = .vertical
        phoneNumberStackView.distribution = .fill
        phoneNumberStackView.alignment = .fill
        phoneNumberStackView.spacing = stackViewSpacing

        [
            nameLabel,
            nameStackView,
            phoneNumberLabel,
            phoneNumberStackView,
            userCreateEndButton
        ].forEach { view.addSubview($0) }

        let margin: CGFloat = 16.0
        let textFieldHeight: CGFloat = 44.0
        let spacing: CGFloat = 16.0
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(margin * 2)
            make.leading.trailing.equalToSuperview().inset(margin)
        }

        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(textFieldHeight)
        }

        nameStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(margin)
        }

        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(textFieldHeight)
            make.leading.trailing.equalToSuperview().inset(margin)
        }

        phoneNumberTextField.snp.makeConstraints { make in
            make.height.equalTo(textFieldHeight)
        }

        phoneNumberStackView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(spacing)
            make.leading.trailing.equalToSuperview().inset(margin)
        }

        userCreateEndButton.snp.makeConstraints { make in
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

    func moveUpUserCreateEndButton(
        duration: TimeInterval,
        translationX: CGFloat,
        y: CGFloat
    ) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.userCreateEndButton.transform =
            CGAffineTransform(
                translationX: translationX,
                y: y
            )
        }
    }

    func moveDownUserCreateEndButton(
        transform: CGAffineTransform
    ) {
        userCreateEndButton.transform = transform
    }


    func nameTextFieldUpdate(isEvaluated: Bool) {
        if isEvaluated {
            nameTextField.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        } else {
            nameTextField.layer.borderColor = UIColor.red.cgColor
        }
    }

    func nameErrorLabelUpdate(
        with text: String?,
        isHidden: Bool
    ) {
        nameErrorLabel.text = text
        nameErrorLabel.isHidden = isHidden
    }

    func phoneNumberTextFieldUpdate(isEvaluated: Bool) {
        if isEvaluated {
            phoneNumberTextField.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        } else {
            phoneNumberTextField.layer.borderColor = UIColor.red.cgColor
        }
    }

    func phoneNumberErrorLabelUpdate(
        with text: String?,
        isHidden: Bool
    ) {
        phoneNumberErrorLabel.text = text
        phoneNumberErrorLabel.isHidden = isHidden
    }


    func userCreateEndButton(isEnabled: Bool) {
        userCreateEndButton.isEnabled = isEnabled
    }

    func nameTextFieldEndEditing() {
        nameTextField.endEditing(true)
    }

    func phoneNumberTextFieldEndEditing() {
        phoneNumberTextField.endEditing(true)
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

private extension UserCreateInfoViewController {

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
    func didTapUserCreateEndButton(_ sender: UIButton) {
        presenter.didTapUserCreateEndButton()
    }

}
