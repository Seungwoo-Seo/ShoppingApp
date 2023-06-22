//
//  AccountViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/28.
//

import SnapKit
import Toast_Swift
import UIKit

final class AccountViewController: UIViewController {
    private lazy var presenter = AccountPresenter(
        viewController: self
    )

    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

extension AccountViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter.didSelectRow(at: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return presenter.viewForHeaderInSection(
            tableView,
            section: section
        )
    }

    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        return presenter.viewForFooterInSection(
            tableView,
            section: section
        )
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return presenter.heightForRowAt(indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return presenter.heightForHeaderInSection(section)
    }

    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        return presenter.heightForFooterInSection(section)
    }

}

extension AccountViewController: AccountViewProtocol {

    func configureNavigationBar() {
        navigationItem.title = "설정"
    }

    func configureTableView() {
        tableView = UITableView(
            frame: .zero,
            style: .grouped
        )
        tableView.sectionHeaderTopPadding = 8.0
        tableView.dataSource = presenter
        tableView.delegate = self


        // cell 등록
        let cells = AccountTableViewRegister.default.cellRegister
        cells.forEach {
            tableView.register(
                $0.cellClass,
                forCellReuseIdentifier: $0.identifier
            )
        }

        // supplementary 등록
        let supplementaryRegister = AccountTableViewRegister.default.supplementaryRegister
        supplementaryRegister.forEach {
            tableView.register(
                $0.aClass,
                forHeaderFooterViewReuseIdentifier: $0.identifier
            )
        }
    }

    func configureHierarchy() {
        [tableView].forEach { view.addSubview($0) }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func tabBarIsHidden(_ isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }

    func presentErrorToast(message: String) {
        view.makeToast(message)
    }

    func presentPreparingToast(message: String) {
        view.makeToast(message, position: .center)
    }

    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: false)
    }

}
