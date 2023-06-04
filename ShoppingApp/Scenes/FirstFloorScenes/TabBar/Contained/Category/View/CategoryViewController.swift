//
//  CategoryViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import UIKit

final class CategoryViewController: UIViewController {
    private lazy var presenter = CategoryPresenter(
        viewController: self
    )

    // views
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

}

extension CategoryViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter.didSelectItem(at: indexPath)
    }

}

extension CategoryViewController: CategoryViewProtocol {

    /// 네비게이션바 구성하는 메소드
    func configureNavigationBar() {
        let cartBarButtonItem = ShoppingAppBarButtonItem(
            barButtonItemStyle: .cart,
            target: self,
            action: #selector(didTapCartBarButtonItem)
        )

        let searchBarButtonItem = ShoppingAppBarButtonItem(
            barButtonItemStyle: .search,
            target: self,
            action: #selector(didTapSearchBarButtonItem)
        )

        navigationItem.title = "카테고리"
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItems = [
            cartBarButtonItem,
            searchBarButtonItem
        ]
    }

    /// collectionView 구성하는 메소드
    func configureCollectionView() {
        let layout = CategoryCollectioinViewLayout.default.createLayout

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
    }

    func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8.0)
            make.leading.equalToSuperview().inset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
    }

    func tapBarIsHidden(_ isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }

    /// MoreViewController로 push
    func pushToMoreViewController(
        with request: String
    ) {
        let moreViewController = MoreViewController(
            request: request
        )
        navigationController?.pushViewController(
            moreViewController,
            animated: true
        )
    }

    func pushToSearchViewController() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(
            searchViewController,
            animated: true
        )
    }

    func presentPreparingToast(message: String) {
        view.makeToast(message, position: .center)
    }
}

private extension CategoryViewController {

    @objc
    func didTapCartBarButtonItem() {
        presenter.didTapCartBarButtonItem()
    }

    @objc
    func didTapSearchBarButtonItem() {
        presenter.didTapSearchBarButtonItem()
    }

}
