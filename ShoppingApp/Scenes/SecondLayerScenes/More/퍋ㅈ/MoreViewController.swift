//
//  MoreViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/28.
//

import SnapKit
import Toast_Swift
import UIKit

final class MoreViewController: UIViewController {
    private var presenter: MorePresenter!

    // views
    private var collectionView: UICollectionView!

    init(
        request: String
    ) {
        super.init(nibName: nil, bundle: nil)

        self.presenter = MorePresenter(
            viewController: self,
            request: request
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

extension MoreViewController: UICollectionViewDelegate {

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

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter.didSelectItem(at: indexPath)
    }

}

extension MoreViewController: LikedButtonDelegate {

    func didTapLikedButton(_ sender: LikedButton) {
        presenter.didTapLikedButton(sender)
    }

}

extension MoreViewController: MoreCollectionViewHeaderDelegate {

    func didTapOrderOfPopularityButton() {
        presenter.didTapOrderOfPopularityButton()
    }

    func didTapFilterButton() {
        presenter.didTapFilterButton()
    }

}

extension MoreViewController: MoreViewProtocol {

    func configureNavigationBar(with title: String) {
        let cartBarButtonItem = ShoppingAppBarButtonItem(
            barButtonItemStyle: .cart,
            target: self,
            action: #selector(didTapCartBarButtonItem)
        )

        // 검색 BarButtonItem 설정
        let searchBarButtonItem = ShoppingAppBarButtonItem(
            barButtonItemStyle: .search,
            target: self,
            action: #selector(didTapSearchBarButtonItem)
        )

        navigationItem.title = title
        navigationItem.rightBarButtonItems = [
            cartBarButtonItem,
            searchBarButtonItem
        ]
    }

    func configureCollectionView() {
        let layout = MoreCollectionViewLayout.default.createLayout

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.prefetchDataSource = presenter
        collectionView.delegate = self

        // cell 등록
        let cellRegister = MoreCollectionViewRegister.default.cellRegister
        cellRegister.forEach {
            collectionView.register(
                $0.cellClass,
                forCellWithReuseIdentifier: $0.identifier
            )
        }

        // supplementary 등록
        let supplementaryRegister = MoreCollectionViewRegister.default.supplementaryRegister
        supplementaryRegister.forEach {
            collectionView.register(
                $0.viewClass,
                forSupplementaryViewOfKind: $0.kind,
                withReuseIdentifier: $0.identifier
            )
        }

        // refreshControl 설정
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(didValueChangedRefreshControl),
            for: .valueChanged
        )
        collectionView.refreshControl = refreshControl
    }

    func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
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

    func presentErrorToast(message: String) {
        view.makeToast(message, position: .center)
    }

}

private extension MoreViewController {

    @objc
    func didTapCartBarButtonItem() {
        presenter.didTapCartBarButtonItem()
    }

    @objc
    func didTapSearchBarButtonItem() {
        presenter.didTapSearchBarButtonItem()
    }

    @objc
    func didValueChangedRefreshControl() {
        presenter.didValueChangedRefreshControl()
    }

}


