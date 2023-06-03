//
//  AccountPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/28.
//

import UIKit

protocol AccountViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureTableView()
    func configureHierarchy()
    func tabBarIsHidden(_ isHidden: Bool)
    func presentErrorToast(message: String)
    func presentPreparingToast(message: String)
    func popToRootViewController()
}

final class AccountPresenter: NSObject {
    private weak var viewController: AccountViewProtocol!

    private let firebaseAuthManager: FirebaseAuthManagerProtocol

    init(
        viewController: AccountViewProtocol!,
        firebaseAuthManager: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared
    ) {
        self.viewController = viewController
        self.firebaseAuthManager = firebaseAuthManager
    }

    func viewDidLoad() {
        viewController.configureNavigationBar()
        viewController.configureTableView()
        viewController.configureHierarchy()
        viewController.tabBarIsHidden(true)
    }

}

extension AccountPresenter: UITableViewDataSource {

    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return AccountTableViewSectionKind.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return AccountTableViewSectionKind(
            rawValue: section
        )?.subTitles.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let section = AccountTableViewSectionKind(
            rawValue: indexPath.section
        )

        let cell = tableView.dequeueReusableCell(
            withIdentifier: AccountTableViewCell.identifier,
            for: indexPath
        ) as? AccountTableViewCell

        cell?.selectionStyle = .none

        let title = section?.subTitles[indexPath.row]

        switch section {
        case .알림설정:
            if indexPath.row == 1 {
                cell?.configure(
                    with: title,
                    isSwitchHidden: false,
                    setOn: false
                )
            } else {
                cell?.configure(
                    with: title,
                    isSwitchHidden: false,
                    setOn: true
                )
            }
            return cell ?? UITableViewCell()

        case .none:
            fatalError("존재할 수 없는 섹션의 cell을 설정함")

        default:
            cell?.configure(with: title)
            return cell ?? UITableViewCell()
        }
    }

}

// view의 UITableViewDelegate extension
extension AccountPresenter {

    func didSelectRow(at indexPath: IndexPath) {
        guard let section = AccountTableViewSectionKind(
            rawValue: indexPath.section
        ) else {return}

        switch section {
        case .로그아웃_탈퇴하기:
            firebaseAuthManager.signOut { error in
                guard error == nil else {
                    viewController.presentErrorToast(
                        message: "로그아웃 실패 : \(error!)"
                    )
                    return
                }
                viewController.popToRootViewController()
                NotificationCenter.default.post(
                    name: NSNotification.Name.moveHomeTabmanViewController,
                    object: nil
                )
            }
        default:
            viewController.presentPreparingToast(
                message: "준비중~"
            )
        }
    }

    func viewForHeaderInSection(
        _ tableView: UITableView,
        section: Int
    ) -> UIView? {
        let section = AccountTableViewSectionKind(
            rawValue: section
        )

        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: AccountTableViewHeader.identifier
        ) as? AccountTableViewHeader

        let headerTitle = section?.headerTitle

        header?.configure(with: headerTitle)

        switch section {
        case .로그아웃_탈퇴하기:
            return nil

        case .none:
            fatalError("존재할 수 없는 섹션의 헤더 설정")

        default:
            return header
        }
    }

    func viewForFooterInSection(
        _ tableView: UITableView,
        section: Int
    ) -> UIView? {
        let section = AccountTableViewSectionKind(
            rawValue: section
        )

        // 마지막 섹션만 Footer가 있음
        switch section {
        case .로그아웃_탈퇴하기:
            let footer = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: AccountTableViewFooter.identifier
            ) as? AccountTableViewFooter

            return footer

        case .none:
            fatalError("존재할 수 없는 섹션의 푸터 설정")

        default:
            return nil
        }
    }

    var rowHeight: CGFloat {
        return 40.0
    }

    func heightForRowAt(
        _ indexPath: IndexPath
    ) -> CGFloat {
        return rowHeight
    }

    func heightForHeaderInSection(
        _ section: Int
    ) -> CGFloat {
        let section = AccountTableViewSectionKind(
            rawValue: section
        )

        switch section {
        case .로그아웃_탈퇴하기:
            return 0
        default:
            return rowHeight + 8.0
        }
    }

    func heightForFooterInSection(
        _ section: Int
    ) -> CGFloat {
        let section = AccountTableViewSectionKind(
            rawValue: section
        )

        switch section {
        case .로그아웃_탈퇴하기:
            return rowHeight
        default:
            return 0
        }
    }

}

