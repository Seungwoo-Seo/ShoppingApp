//
//  AccountViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/28.
//

import SnapKit
import UIKit

final class AccountViewController: UIViewController {
    private lazy var presenter = AccountPresenter(viewController: self)

    private lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .grouped
        )
        tableView.dataSource = presenter
        tableView.delegate = presenter
        tableView.sectionHeaderTopPadding = 8.0

        // 셀 등록
        tableView.register(
            AccountTableViewCell.self,
            forCellReuseIdentifier: AccountTableViewCell.identifier
        )

        let cells = RegisterProvider.accountTableView.cellRegister
        cells.forEach {
            tableView.register(
                $0.cellClass,
                forCellReuseIdentifier: $0.identifier
            )
        }

        let headerFooter = RegisterProvider.accountTableViewHeaderFooter.cellRegister

        headerFooter.forEach {
            tableView.register(
                $0.cellClass,
                forHeaderFooterViewReuseIdentifier: $0.identifier
            )
        }

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

extension AccountViewController: AccountViewProtocol {

    func setupNavigationBar() {
        navigationItem.title = "설정"
    }

    func setupLayout() {
        [tableView].forEach { view.addSubview($0) }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}

private extension AccountViewController {



}
