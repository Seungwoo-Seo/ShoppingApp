//
//  DetailViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/20.
//

import SnapKit
import UIKit
import WebKit

final class DetailViewController: UIViewController {
    private var presenter: DetailPresenter?

    private var webView: WKWebView!


    init(clothes: Goods) {
        super.init(nibName: nil, bundle: nil)

        self.presenter = DetailPresenter(
            viewController: self,
            clothes: clothes
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
    }

}

extension DetailViewController: WKUIDelegate {

}

extension DetailViewController: DetailViewProtocol {

    func setupTabBar() {
        tabBarController?.tabBar.isHidden = true
    }

    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
    }

    func setupLayout() {
        [webView].forEach { view.addSubview($0) }

        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func loadWebView(request: URLRequest) {
        webView.load(request)
    }
}
