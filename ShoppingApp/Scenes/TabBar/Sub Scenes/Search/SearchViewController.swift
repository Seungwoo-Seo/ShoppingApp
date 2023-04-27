//
//  SearchViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import SnapKit
import UIKit

final class SearchViewController: UIViewController {
    private lazy var presenter = SearchPresenter(viewController: self)

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"

        return searchBar
    }()

    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTapCancelBarButtonItem)
        )

        return barButtonItem
    }()

    private lazy var searchResultsView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = presenter
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

extension SearchViewController: UITableViewDelegate {

}

extension SearchViewController: SearchViewProtocol {

    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = cancelBarButtonItem
    }

    func setupLayout() {
        tabBarController?.tabBar.isHidden = true

        [searchResultsView].forEach { view.addSubview($0) }

        searchResultsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func popViewController() {
        navigationController?.popViewController(animated: true)
    }

}

private extension SearchViewController {

    @objc func didTapCancelBarButtonItem() {
        presenter.didTapCancelBarButtonItem()
    }

}
