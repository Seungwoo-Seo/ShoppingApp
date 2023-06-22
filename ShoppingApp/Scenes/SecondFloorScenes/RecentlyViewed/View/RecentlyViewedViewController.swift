//
//  RecentlyViewedViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import UIKit

final class RecentlyViewedViewController: UIViewController {
    private lazy var presenter = RecentlyViewedPresenter(
        viewController: self
    )

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

}

extension RecentlyViewedViewController: UICollectionViewDelegate {

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

extension RecentlyViewedViewController: RecentlyViewedCollectionViewCellDelegate {

    func didTapDeleteButton(_ sender: UIButton) {
        presenter.didTapDeleteButton(tag: sender.tag)
    }

}

extension RecentlyViewedViewController: LikedButtonDelegate {

    func didTapLikedButton(_ sender: LikedButton) {
        presenter.didTapLikedButton(sender)
    }

}

extension RecentlyViewedViewController: RecentlyViewedViewProtocol {

    func configureNavigationBar() {
        navigationItem.title = "최근 본 상품"
    }

    func configureCollectionView() {
        let layout = RecentlyViewedCollectionViewLayout.default.createLayout

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.delegate = self

        // cell 등록
        let cellRegister = RecentlyViewedCollectionViewRegister.default.cellRegister
        cellRegister.forEach {
            collectionView.register(
                $0.cellClass,
                forCellWithReuseIdentifier: $0.identifier
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

    func reloadCollectionView() {
        collectionView.reloadData()
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

}
