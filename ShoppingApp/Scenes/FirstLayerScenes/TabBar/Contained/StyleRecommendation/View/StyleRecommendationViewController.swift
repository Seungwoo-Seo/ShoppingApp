//
//  StyleRecommendationViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import Toast_Swift
import UIKit

final class StyleRecommendationViewController: UIViewController {
    private lazy var presenter = StyleRecommendationPresenter(
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

        presenter.viewWillAppear()
    }

}

extension StyleRecommendationViewController: UICollectionViewDelegate {

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
            indexPath: indexPath
        )
    }

}

extension StyleRecommendationViewController: LikedButtonDelegate {

    func didTapLikedButton(_ sender: LikedButton) {
        presenter.didTapLikedButton(sender)
    }

}

extension StyleRecommendationViewController: StyleRecommendationViewProtocol {

    /// 네비게이션바 구성하는 메소드
    func configureNavigationBar() {
        // 장바구니 BarButtonItem 설정
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

        navigationItem.title = "스타일 추천"
        navigationItem.rightBarButtonItems = [
            cartBarButtonItem,
            searchBarButtonItem
        ]
    }

    /// collectioView 구성하는 메소드
    func configureCollectionView() {
        // 레이아웃 생성
        let layout = StyleRecommendationCollectionViewLayout.default.createLayout

        // UIRefreshControl 인스턴스 생성
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(didValueChangedRefreshControl),
            for: .valueChanged
        )

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.prefetchDataSource = presenter
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl

        // cell 등록
        let cellRegister = StyleRecommendationCollectionViewRegister.default.cellRegister
        cellRegister.forEach {
            collectionView.register(
                $0.cellClass,
                forCellWithReuseIdentifier: $0.identifier
            )
        }

        // supplementary 등록
        let supplementaryRegister = StyleRecommendationCollectionViewRegister.default.supplementaryRegister
        supplementaryRegister.forEach {
            collectionView.register(
                $0.viewClass,
                forSupplementaryViewOfKind: $0.kind,
                withReuseIdentifier: $0.identifier
            )
        }
    }

    /// 계층구조 설정 및 오토레이아웃 설정
    func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func tapBarIsHidden(_ isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
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

    /// collectionview를 reload하는 메소드
    func reloadCollectionView() {
        collectionView.reloadData()
    }

    /// collectionView의 refreshing 끝내는 메소드
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }

}

private extension StyleRecommendationViewController {

    /// cartBarButtonItem tap 했을 때
    @objc
    func didTapCartBarButtonItem() {
        presenter.didTapCartBarButtonItem()
    }

    /// searchBarButtonItem tap 했을 때
    @objc
    func didTapSearchBarButtonItem() {
        presenter.didTapSearchBarButtonItem()
    }

    /// refreshControl valueChanged 했을 때
    @objc
    func didValueChangedRefreshControl() {
        presenter.didValueChangedRefreshControl()
    }

}
