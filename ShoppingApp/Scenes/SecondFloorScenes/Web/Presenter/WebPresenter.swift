//
//  DetailPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/20.
//

import Foundation

protocol WebViewProtocol: AnyObject {
    func configureTabBar()
    func configureWebView()
    func configureHierarchy()
    func loadWebView(request: URLRequest)
}

final class WebPresenter {
    private weak var viewController: WebViewProtocol!

    private var goods: Goods

    init(
        viewController: WebViewProtocol!,
        goods: Goods
    ) {
        self.viewController = viewController
        self.goods = goods
    }

    func viewDidLoad() {
        viewController.configureTabBar()
        viewController.configureWebView()
        viewController.configureHierarchy()

        let myURL = URL(string: goods.link)
        let myRequest = URLRequest(url: myURL!)
        viewController.loadWebView(request: myRequest)
    }

}
