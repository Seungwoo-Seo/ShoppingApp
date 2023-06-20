//
//  WebViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/20.
//

import SnapKit
import UIKit
import WebKit

final class WebViewController: UIViewController {
    private var presenter: WebPresenter!

    // views
    private var webView: WKWebView!

    init(goods: Goods) {
        super.init(nibName: nil, bundle: nil)

        self.presenter = WebPresenter(
            viewController: self,
            goods: goods
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

extension WebViewController: WKUIDelegate {

}

extension WebViewController: WebViewProtocol {

    func configureTabBar() {
        tabBarController?.tabBar.isHidden = true
    }

    func configureWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(
            frame: .zero,
            configuration: webConfiguration
        )
        webView.uiDelegate = self
    }

    func configureHierarchy() {
        [webView].forEach { view.addSubview($0) }

        webView.snp.makeConstraints { make in
            make.top.equalTo(
                view.safeAreaLayoutGuide.snp.top
            )
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(
                view.safeAreaLayoutGuide.snp.bottom
            )
        }
    }

    func loadWebView(request: URLRequest) {
        webView.load(request)
    }
}
