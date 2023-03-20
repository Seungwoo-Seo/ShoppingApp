//
//  SearchPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
    func popViewController()
}

final class SearchPresenter: NSObject {
    private weak var viewController: SearchViewProtocol?

    private var clothesList: [Clothes] = []

    init(
        viewController: SearchViewProtocol?
    ) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
    }

    func didTapCancelBarButtonItem() {
        viewController?.popViewController()
    }

}

extension SearchPresenter: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return clothesList.count
        14
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = "\(indexPath)"

        return cell
    }


}
