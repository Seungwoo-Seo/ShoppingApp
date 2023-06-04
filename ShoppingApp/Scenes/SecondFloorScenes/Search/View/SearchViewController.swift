//
//  SearchViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import SnapKit
import UIKit

final class SearchViewController: UIViewController {
    private lazy var presenter = SearchPresenter(
        viewController: self
    )

    // views
    private var searchBar: UISearchBar!
    /// tag: 0
    /// 최근 검색어, 인기 검색어 순위를 보여줄 tableView
    var searchInfotableView: UITableView!
    /// tag: 1
    /// 검색 결과를 보여줄 tableView
    var searchResultsView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        presenter.textDidChange(searchText)
    }

    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar
    ) {
        presenter.searchButtonClicked(
            with: searchBar.text
        )
    }

}

extension SearchViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter.didSelectRow(
            at: indexPath,
            tag: tableView.tag
        )
    }

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return presenter.tableView(
            tableView,
            viewForHeaderInSection: section
        )
    }

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return presenter.tableView(
            tableView,
            heightForHeaderInSection: section
        )
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return presenter.tableView(
            tableView,
            heightForRowAt: indexPath
        )
    }

}

extension SearchViewController: SearchInfoTableViewRecentSearchHeaderDelegate {

    func didTapRemoveButton() {
        presenter.didTapRemoveButton()
    }

}

extension SearchViewController: SearchInfoTableViewRecentSearchCellDelegate {

    func didTapTag(at index: Int) {
        presenter.didTapTag(at: index)
    }

}

extension SearchViewController: SearchViewProtocol {

    /// searchBar를 구성하는 메소드
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "찾으시는 상품을 검색하세요!"
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.smartDashesType = .no
        searchBar.smartInsertDeleteType = .no
        searchBar.smartQuotesType = .no
    }

    /// 네비게이션바를 구성하는 메소드
    func cofigureNavigationBar() {
        let cancelBarButtonItem = ShoppingAppBarButtonItem(
            barButtonItemStyle: .cancel,
            target: self,
            action: #selector(didTapCancelBarButtonItem)
        )

        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = cancelBarButtonItem
    }

    /// searchInfoTableView를 구성하는 메소드
    func configureSearchInfoTableView() {
        searchInfotableView = UITableView(
            frame: .zero,
            style: .insetGrouped
        )
        searchInfotableView.backgroundColor = .systemBackground
        searchInfotableView.delegate = self
        searchInfotableView.tag = 0

        // cell 등록
        let cellRegister = SearchInfoTableViewRegister.default.cellRegister
        cellRegister.forEach {
            searchInfotableView.register(
                $0.cellClass,
                forCellReuseIdentifier: $0.identifier
            )
        }

        // supplementary 등록
        let supplementaryRegister = SearchInfoTableViewRegister.default.supplementaryRegister
        supplementaryRegister.forEach {
            searchInfotableView.register(
                $0.aClass,
                forHeaderFooterViewReuseIdentifier: $0.identifier
            )
        }
    }

    /// searchResultsView를 구성하는 메소드
    func configureSearchResultsView() {
        searchResultsView = UITableView()
        searchResultsView.backgroundColor = .systemBackground
        searchResultsView.sectionHeaderTopPadding = 0
        searchResultsView.dataSource = presenter
        searchResultsView.delegate = self
        searchResultsView.isHidden = true
        searchResultsView.tag = 1

        // cell 등록
        let cellRegister = SearchResultsViewRegister.default.cellRegister
        cellRegister.forEach {
            searchResultsView.register(
                $0.cellClass,
                forCellReuseIdentifier: $0.identifier
            )
        }
    }

    /// 계층을 구성하고 오토레이아웃을 설정하는 메소드
    func configureHierarchy() {
        [
            searchInfotableView,
            searchResultsView
        ].forEach { view.addSubview($0) }

        searchInfotableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        searchResultsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    /// tabBar 숨김 여부
    func tabBarUpdate(isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }

    /// 이전 화면으로 돌아가는 메소드
    func popViewController() {
        navigationController?.popViewController(
            animated: true
        )
    }

    /// searchResultsView 다시 로드
    func reloadSearchResultsView() {
        searchResultsView.reloadData()
    }

    func reloadTableView() {
        searchInfotableView.reloadData()
    }

    func searchResultsView(isHidden: Bool) {
        searchResultsView.isHidden = isHidden
    }

    func tableView(isHidden: Bool) {
        searchInfotableView.isHidden = isHidden
    }

    func pushToMoreViewController(with request: String) {
        let moreViewController = MoreViewController(
            request: request
        )
        navigationController?.pushViewController(
            moreViewController,
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

    func searchInfotableViewLayoutIfNeeded() {
        searchInfotableView.layoutIfNeeded()
    }

}

private extension SearchViewController {

    @objc func didTapCancelBarButtonItem() {
        presenter.didTapCancelBarButtonItem()
    }

}
