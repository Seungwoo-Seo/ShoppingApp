//
//  SearchPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import Foundation
import UIKit

protocol SearchViewProtocol: AnyObject {
    func configureSearchBar()
    func cofigureNavigationBar()
    func configureSearchInfoTableView()
    func configureSearchResultsView()
    func configureHierarchy()

    func tabBarUpdate(isHidden: Bool)
    func popViewController()
    func reloadSearchResultsView()
    func reloadTableView()
    func searchResultsView(isHidden: Bool)
    func tableView(isHidden: Bool)
    func pushToMoreViewController(
        with request: String
    )
    func pushToWebViewController(with goods: Goods)


    func searchInfotableViewLayoutIfNeeded()
}

final class SearchPresenter: NSObject {
    private weak var viewController: SearchViewProtocol!

    // apis
    private let userDefaultsManager: UserDefaultsManagerProtocl
    private let firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol
    private let goodsSearchManager: GoodsSearchManagerProtocol

    private var searchInfoDataSource: UITableViewDiffableDataSource<
        SearchInfoTableViewSectionKind,
        SearchInfo
    >!

    // 최근 검색 리스트
    private var recentSearchList: [String] = []
    // 인기 검색 리스트
    private var popularSearchList: [String] = []
    // 검색 결과 goods 리스트
    private var searchResultGoodsList: [Goods] = []

    init(
        viewController: SearchViewProtocol!,
        userDefaultsManager: UserDefaultsManagerProtocl = UserDefaultsManager(),
        firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol = FirebaseRealtimeDatabaseManager.shared,
        goodsSearchManager: GoodsSearchManagerProtocol = GoodsSearchManager()
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
        self.firebaseRealtimeDatabaseManager = firebaseRealtimeDatabaseManager
        self.goodsSearchManager = goodsSearchManager
    }

    func viewDidLoad() {
        viewController.configureSearchBar()
        viewController.cofigureNavigationBar()
        viewController.configureSearchInfoTableView()
        configureSearchInfoTableViewDataSource()
        viewController.configureSearchResultsView()
        viewController.configureHierarchy()
        viewController.tabBarUpdate(isHidden: true)



        firebaseRealtimeDatabaseManager.getSearches { [weak self] (searchList) in
            self?.popularSearchList = searchList
            self?.applyTestSnapShot()
        }
    }

    func viewWillAppear() {
        recentSearchList = userDefaultsManager.getRecentSearchList()
        applyAddSnapShot()
    }

}

extension SearchPresenter: UITableViewDataSource {

    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return SearchResultsTableViewSectionKind.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return searchResultGoodsList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultsTableViewCell.identifier,
            for: indexPath
        ) as! SearchResultsTableViewCell

        let title = searchResultGoodsList[indexPath.row].title
        cell.configure(
            with: title
        )

        return cell
    }

}


// diffable dataSource 구성
extension SearchPresenter {

    func configureSearchInfoTableViewDataSource() {
        let tableView = (viewController as! SearchViewController).searchInfotableView!

        searchInfoDataSource = UITableViewDiffableDataSource<
            SearchInfoTableViewSectionKind,
            SearchInfo
        >(
            tableView: tableView
        ) { [weak self] (tableView, indexPath, searchInfo) in
            guard let self = self else {
                return UITableViewCell()
            }

            let sectionIdentifier = self.searchInfoDataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch sectionIdentifier {
            case .최근_검색어:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchInfoTableViewRecentSearchCell.identifier,
                    for: indexPath
                ) as! SearchInfoTableViewRecentSearchCell

                cell.delegate = self.viewController as! SearchViewController
                cell.configure(
                    with: self.recentSearchList
                )

                return cell

            case .인기_검색어:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchInfoTableViewPopularSearchCell.identifier,
                    for: indexPath
                ) as! SearchInfoTableViewPopularSearchCell


                let popularSearch = self.popularSearchList[indexPath.row]
//                let popularSearch = searchInfo.popularSearch!
                cell.configure(
                    with: popularSearch,
                    ranking: "\(indexPath.row + 1)"
                )

                return cell
            }
        }

        applyInitialSnapShot()
    }

    func applyInitialSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<
            SearchInfoTableViewSectionKind,
            SearchInfo
        >()
        snapshot.appendSections([])
        searchInfoDataSource.apply(snapshot)
    }

    func applyAddSnapShot() {
        // 1. 최근 검색어 없으면 생성하지 않음
        guard !recentSearchList.isEmpty else {return}

        var snapshot = searchInfoDataSource.snapshot()
        // 2. 최근 검색어 섹션이 존재한다면 Reload, 없어야 guard문 통과
        guard !snapshot.sectionIdentifiers.contains(.최근_검색어) else {
            snapshot.reloadSections([.최근_검색어])
            searchInfoDataSource.applySnapshotUsingReloadData(snapshot)
            return
        }

        // 3. 최근 검색어 섹션 추가
        if snapshot.sectionIdentifiers.contains(.인기_검색어) {
            snapshot.insertSections([.최근_검색어], beforeSection: .인기_검색어)
        } else {
            snapshot.appendSections([.최근_검색어])
        }

        let searchInfo = SearchInfo(
            recenetSearch: recentSearchList,
            popularSearch: nil
        )

        snapshot.appendItems([searchInfo], toSection: .최근_검색어)
//        snapshot.appendItems([searchInfo])
        searchInfoDataSource.apply(snapshot)
        viewController.searchInfotableViewLayoutIfNeeded()
    }

    func applytest() {
        var snapshot = searchInfoDataSource.snapshot()
        snapshot.reloadSections([.최근_검색어, .인기_검색어])
    }

    func applyTestSnapShot() {
        var snapshot = searchInfoDataSource.snapshot()
        snapshot.appendSections([.인기_검색어])

        let searchInfos = popularSearchList.map {
            SearchInfo(
                recenetSearch: nil,
                popularSearch: $0
            )
        }

        snapshot.appendItems(searchInfos)
        searchInfoDataSource.apply(
            snapshot,
            animatingDifferences: false
        )
    }

}

// view의 UISearchBarDelegate extension
extension SearchPresenter {

    func textDidChange(_ searchText: String) {
        // 검색어가 비었다면
        if searchText.isEmpty {
            // 1. searchResultsView -> 숨긴다
            viewController.searchResultsView(
                isHidden: true
            )
            // 2. tableView -> 보인다
            viewController.tableView(
                isHidden: false
            )
        } else {
            // 1. searchResultsView -> 보인다
            viewController.searchResultsView(
                isHidden: false
            )
            // 2. tableView -> 숨긴다
            viewController.tableView(
                isHidden: true
            )
            // 3. 검색어를 검색한다
            goodsSearchManager.request(
                with: searchText
            ) { [weak self] (results) in
                self?.searchResultGoodsList = results
                self?.viewController.reloadSearchResultsView()
            }
        }
    }

    func searchButtonClicked(with searchText: String?) {
        guard let searchText = searchText,
              !searchText.isEmpty
        else {return}

        userDefaultsManager.addRecentSearch(searchText)
        incrementSearchCount(for: searchText)
        viewController.pushToMoreViewController(
            with: searchText
        )
    }

}

// view의 UITableViewDelegate extension
extension SearchPresenter {

    func didSelectRow(
        at indexPath: IndexPath,
        tag: Int
    ) {
        let searchText: String
        // searchInfoTableView
        if tag == 0 {
            let sectionIdentifier = searchInfoDataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch sectionIdentifier {
            case .최근_검색어:
                searchText = recentSearchList[indexPath.row]
            case .인기_검색어:
                searchText = popularSearchList[indexPath.row]
            }
            userDefaultsManager.addRecentSearch(searchText)
            incrementSearchCount(for: searchText)
            viewController.pushToMoreViewController(
                with: searchText
            )
        }
        // searchResultsTableView
        else {
            let searchResultsGoods = searchResultGoodsList[indexPath.row]
            userDefaultsManager.addGoods(searchResultsGoods)
            viewController.pushToWebViewController(
                with: searchResultsGoods
            )
        }
    }

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        switch tableView.tag {
        case 0:
            let sectionIdentifier = searchInfoDataSource.snapshot().sectionIdentifiers[section]

            switch sectionIdentifier {
            case .최근_검색어:
                let header = tableView.dequeueReusableHeaderFooterView(
                    withIdentifier: SearchInfoTableViewRecentSearchHeader.identifier
                ) as! SearchInfoTableViewRecentSearchHeader

                header.delegate = viewController as! SearchViewController
                header.configure(
                    with: sectionIdentifier.headerTitle
                )

                return header

            case .인기_검색어:
                let header = tableView.dequeueReusableHeaderFooterView(
                    withIdentifier: SearchInfoTableViewPopularSearchHeader.identifier
                ) as! SearchInfoTableViewPopularSearchHeader

                header.configure(
                    with: sectionIdentifier.headerTitle
                )

                return header
            }

        default: return nil
        }
    }

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        switch tableView.tag {
        case 0: return 44.0
        default: return 0
        }
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch tableView.tag {
        case 0:
            let sectionIdentifier = searchInfoDataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch sectionIdentifier {
            case .최근_검색어:
                return UITableView.automaticDimension
            case .인기_검색어:
                return 44.0
            }
        default: return 44.0
        }
    }

}

// view의 SearchInfoTableViewRecentSearchHeaderDelegate extension
extension SearchPresenter {

    func didTapRemoveButton() {
        recentSearchList.removeAll()
        userDefaultsManager.removeRecentSearchAll()

        var snapshot = searchInfoDataSource.snapshot()
        snapshot.deleteSections([.최근_검색어])
        searchInfoDataSource.apply(snapshot)
    }

}

// view의 SearchInfoTableViewRecentSearchCellDelegate extension
extension SearchPresenter {

    func didTapTag(at index: Int) {
        let recentSearch = recentSearchList[index]

        userDefaultsManager.addRecentSearch(recentSearch)
        incrementSearchCount(
            for: recentSearch
        )
        viewController.pushToMoreViewController(
            with: recentSearch
        )
    }
}

// view의 private extension
extension SearchPresenter {

    func didTapCancelBarButtonItem() {
        viewController.popViewController()
    }

}

private extension SearchPresenter {
    // 1. searchBar의 text가 비어있지 않고 키보드 엔터를 눌렀을 때
    // 2. 최근 검색어를 눌렀을 때 &&&&&&&&&&&&
    // 3. 인기 검색 순위를 눌렀을 때 &&&&&&&
    // 4. searchResultsView의 cell을 didSelected 했을 때 &&&&&&&
    func incrementSearchCount(for searchText: String) {
        firebaseRealtimeDatabaseManager.incrementSearchCount(
            for: searchText
        )
    }
}
