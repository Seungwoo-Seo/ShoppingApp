//
//  AccountPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/28.
//

import UIKit

protocol AccountViewProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
}

final class AccountPresenter: NSObject {
    private weak var viewController: AccountViewProtocol?

    init(
        viewController: AccountViewProtocol?
    ) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
    }

}

extension AccountPresenter: UITableViewDataSource {

    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return AccountTableViewTitleData.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return AccountTableViewTitleData(
            rawValue: section
        )?.subTitles.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AccountTableViewCell.identifier,
            for: indexPath
        ) as? AccountTableViewCell else {
            return UITableViewCell()
        }

        let title = AccountTableViewTitleData(
            rawValue: indexPath.section
        )?.subTitles[indexPath.row] ?? ""

        cell.selectionStyle = .none

        switch indexPath.section {
        case 1:
            if indexPath.row == 1 {
                cell.setData(
                    with: title,
                    isSwitchHidden: false,
                    setOn: false
                )
            } else {
                cell.setData(
                    with: title,
                    isSwitchHidden: false,
                    setOn: true
                )
            }
            return cell

        default:
            cell.setData(with: title)
            return cell
        }
    }

}

extension AccountPresenter: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: AccountTableViewHeader.identifier
        ) as? AccountTableViewHeader

        let title = AccountTableViewTitleData(
            rawValue: section
        )?.headerTitle ?? ""

        header?.setData(with: title)

        switch section {
        case 4:
            return nil
        default:
            return header
        }
    }

    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        // 마지막 섹션만 Footer가 있음
        switch section {
        case 4:
            let footer = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: AccountTableViewFooter.identifier
            ) as? AccountTableViewFooter

            return footer

        default:
            return nil
        }
    }

    var rowHeight: CGFloat {
        return 40.0
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return rowHeight
    }

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        switch section {
        case 4:
            return 0
        default:
            return rowHeight + 8.0
        }
    }

    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        switch section {
        case 4:
            return rowHeight
        default:
            return 0
        }
    }

}

