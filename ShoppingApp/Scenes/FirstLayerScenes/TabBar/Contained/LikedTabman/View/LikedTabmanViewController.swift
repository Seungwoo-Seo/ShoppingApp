//
//  LikedTabmanViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/06/01.
//

import Pageboy
import SnapKit
import Tabman
import UIKit

final class LikedTabmanViewController: TabmanViewController {
    private lazy var presenter = LikedTabmanPresenter(
        viewController: self
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

}

extension LikedTabmanViewController: LikedTabmanViewProtocol {

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

        navigationItem.rightBarButtonItems = [
            cartBarButtonItem,
            searchBarButtonItem
        ]
        navigationItem.title = "찜"
        navigationItem.backButtonTitle = ""
    }

    /// Tabman의 ButtonBar를 구성하는 메소드
    func configureButtonBar() {
        dataSource = presenter

        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.backgroundView.style = .clear
        bar.buttons.customize { (button) in
            button.backgroundColor = .white
            button.tintColor = .black
            button.selectedTintColor = .brown
        }
        bar.indicator.weight = .light
        bar.indicator.tintColor = .brown
        bar.layout.contentMode = .fit
        bar.layout.contentInset = .init(
            top: 0.0,
            left: 16.0,
            bottom: 0.0,
            right: 16.0
        )
        bar.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        bar.layer.borderWidth = 1.0

        addBar(
            bar,
            dataSource: presenter,
            at: .top // 상단 탭바로 설정
        )
    }

    /// tabBar의 isHidden 속성을 설정하는 메소드
    func tabBarIsHidden(_ isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }

    /// searchViewController로 push하는 메소드
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

private extension LikedTabmanViewController {

    // cartBarButtonItem tap 했을 때
    @objc
    func didTapCartBarButtonItem() {
        presenter.didTapCartBarButtonItem()
    }

    // searchBarButtonItem tap 했을 때
    @objc
    func didTapSearchBarButtonItem() {
        presenter.didTapSearchBarButtonItem()
    }

}

