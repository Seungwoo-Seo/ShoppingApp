//
//  DetailPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/20.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func setupTabBar()
    func setupWebView()
    func setupLayout()
    func loadWebView(request: URLRequest)
}

final class DetailPresenter {
    private weak var viewController: DetailViewProtocol?

    private var clothes: Goods

    init(
        viewController: DetailViewProtocol?,
        clothes: Goods
    ) {
        self.viewController = viewController
        self.clothes = clothes
    }

    func viewDidLoad() {
        viewController?.setupTabBar()
        viewController?.setupWebView()
        viewController?.setupLayout()

        let myURL = URL(string: clothes.link)
        let myRequest = URLRequest(url: myURL!)
        viewController?.loadWebView(request: myRequest)
    }

}
