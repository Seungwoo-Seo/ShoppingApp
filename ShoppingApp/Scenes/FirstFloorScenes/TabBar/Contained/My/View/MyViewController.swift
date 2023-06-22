//
//  MyViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/29.
//

import SnapKit
import Toast_Swift
import UIKit

final class MyViewController: UIViewController {
    private lazy var presenter = MyPresenter(
        viewController: self
    )

    // views
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillApper()
    }

}

extension MyViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter.didSelectItem(at: indexPath)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        presenter.willDisplay(
            cell: cell,
            forItemAt: indexPath
        )
    }

}

extension MyViewController: MyCollectionViewRecentlyViewedHeaderDelegate {

    func didTapDetailButton() {
        presenter.didTapDetailButton()
    }

}

extension MyViewController: LikedButtonDelegate {

    func didTapLikedButton(_ sender: LikedButton) {
        presenter.didTapLikedButton(sender)
    }

}

extension MyViewController: MyViewProtocol {

    func configureNavigationBar() {
        let settingBarButtonItem = ShoppingAppBarButtonItem(
            barButtonItemStyle: .setting,
            target: self,
            action: #selector(didTapSettingBarButtonItem)
        )

        navigationItem.rightBarButtonItem = settingBarButtonItem
        navigationItem.backButtonTitle = ""
    }

    func configureCollectionView() {
        let layout = MyCollectionViewLayout.default.createLayout
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.delegate = self

        // cell 등록
        let cellRegister = MyCollectionViewRegister.default.cellRegister
        cellRegister.forEach {
            collectionView.register(
                $0.cellClass,
                forCellWithReuseIdentifier: $0.identifier
            )
        }

        // supplementary 등록
        let supplementaryRegister = MyCollectionViewRegister.default.supplementaryRegister
        supplementaryRegister.forEach {
            collectionView.register(
                $0.viewClass,
                forSupplementaryViewOfKind: $0.kind,
                withReuseIdentifier: $0.identifier
            )
        }
    }

    func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func tabBarIsHidden(_ isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }

    func navigationBarTitleUpdate(_ title: String) {
        navigationItem.title = title
    }

    func pushToAccountViewController() {
        let accountViewController = AccountViewController()
        navigationController?.pushViewController(
            accountViewController,
            animated: true
        )
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func pushToRecentlyViewedViewController() {
        let recentlyViewedViewController = RecentlyViewedViewController()
        navigationController?.pushViewController(
            recentlyViewedViewController,
            animated: true
        )
    }

    func pushToWebViewController(with goods: Goods) {
        let webViewController = WebViewController(
            goods: goods
        )
        navigationController?.pushViewController(
            webViewController,
            animated: true
        )
    }

    func presentPreparingToast(message: String) {
        view.makeToast(message)
    }

    func tabBarControllerSelectedIndex(_ index: Int) {
        tabBarController?.selectedIndex = index
    }

    func addNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(moveHomeTabmanViewController),
            name: NSNotification.Name.moveHomeTabmanViewController,
            object: nil
        )
    }

    func removeNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.moveHomeTabmanViewController,
            object: nil
        )
    }
}

private extension MyViewController {

    @objc
    func moveHomeTabmanViewController() {
        presenter.moveHomeTabmanViewController()
    }

    @objc
    func didTapSettingBarButtonItem() {
        presenter.didTapSettingBarButtonItem()
    }

}
