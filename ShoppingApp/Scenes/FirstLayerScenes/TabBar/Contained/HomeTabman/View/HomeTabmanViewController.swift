//
//  HomeTabmanViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/04.
//

import Pageboy
import SnapKit
import Tabman
import UIKit

final class HomeTabmanViewController: TabmanViewController {
    private lazy var presenter = HomeTabmanPresenter(
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

extension HomeTabmanViewController: HomeTabmanViewProtocol {

    /// 네비게이션바 구성하는 메소드
    func configureNavigationBar() {
        // 앱의 이름 BarButtonItem 설정
        let appNameBarButtonItem = ShoppingAppBarButtonItem(
            barButtonItemStyle: .appName,
            target: self,
            action: #selector(didTapAppNameBarButtonItem)
        )

        // 검색 BarButtonItem 설정
        let searchBarButtonItem = ShoppingAppBarButtonItem(
            barButtonItemStyle: .search,
            target: self,
            action: #selector(didTapSearchBarButtonItem)
        )

        navigationItem.leftBarButtonItem = appNameBarButtonItem
        navigationItem.rightBarButtonItem = searchBarButtonItem
        navigationItem.backButtonTitle = ""
    }

    /// Tabman의 ButtonBar를 구성하는 메소드
    func configureButtonBar() {
        self.dataSource = presenter

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
        bar.layout.contentInset = .init(
            top: 0.0,
            left: 16.0,
            bottom: 0.0,
            right: 16.0
        )

        addBar(
            bar,
            dataSource: presenter,
            at: .top // 상단 탭바로 설정
        )
    }

    /// tabBar의 isHidden 속성을 설정하는 메소드
    func tabBarUpdate(isHidden: Bool) {
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

}

private extension HomeTabmanViewController {

    // appNameBarButtonItem tap 했을 때
    @objc
    func didTapAppNameBarButtonItem() {
        presenter.didTapAppNameBarButtonItem()
    }

    // searchBarButtonItem tap 했을 때
    @objc
    func didTapSearchBarButtonItem() {
        presenter.didTapSearchBarButtonItem()
    }

}

