//
//  UserCreateTabmanViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/10.
//

import Pageboy
import SnapKit
import Tabman
import UIKit

final class UserCreateTabmanViewController: TabmanViewController {
    private var presenter: UserCreateTabmanPresenter!

    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = UserCreateTabmanPresenter(viewController: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter.viewWillDisappear()
    }

}

extension UserCreateTabmanViewController: UserCreateTabmanViewProtocol {

    func configureView() {
        view.backgroundColor = .systemBackground
    }

    func configureNavigationBar() {
        let backBarButton = ShoppingAppBarButtonItem(
            barButtonItemStyle: .back,
            target: self,
            action: #selector(didTapBackBarButton)
        )

        navigationItem.title = "회원가입"
        navigationItem.rightBarButtonItem = backBarButton
        navigationController?.navigationBar.isHidden = false
    }

    func configurePageboyView() {
        dataSource = presenter
        isScrollEnabled = false
    }

    func configureLineBar() {
        let lineBar = TMBar.LineBar()
        lineBar.indicator.weight = .light
        lineBar.backgroundView.style = .flat(
            color: .secondarySystemBackground
        )
        lineBar.indicator.tintColor = .black

        // Add to view
        addBar(lineBar, dataSource: presenter, at: .top)
    }

    func addNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(emailPasswordSucces),
            name: NSNotification.Name.emailPasswordSucces,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(namePhoneNumberSucces),
            name: NSNotification.Name.namePhoneNumberSucces,
            object: nil
        )
    }

    func removeNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.emailPasswordSucces,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.namePhoneNumberSucces,
            object: nil
        )
    }

    func scrollToPage() {
        scrollToPage(.next, animated: true)
    }

    func popViewController() {
        navigationController?.popViewController(
            animated: true
        )
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

private extension UserCreateTabmanViewController {

    @objc
    func didTapBackBarButton(_ sender: UIBarButtonItem) {

    }

    @objc
    func emailPasswordSucces(_ notification: NSNotification) {
        presenter.emailPasswordSucces(notification)
    }

    @objc
    func namePhoneNumberSucces(_ notification: NSNotification) {
        presenter.namePhoneNumberSucces(notification)
    }

}
