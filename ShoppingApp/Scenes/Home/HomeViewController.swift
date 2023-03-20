//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    private lazy var presenter = HomePresenter(viewController: self)

    private lazy var appNameBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "쇼핑~",
            style: .plain,
            target: self,
            action: #selector(didTapAppNameBarButtonItem)
        )

        return barButtonItem
    }()

    private lazy var searchBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didTapSearchBarButtonItem)
        )

        return barButtonItem
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16.0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(
            top: 16.0,
            left: 16.0,
            bottom: 16.0,
            right: 16.0
        )

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = presenter
        collectionView.dataSource = presenter
        collectionView.backgroundColor = .red
        collectionView.register(
            HomeCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeCollectionViewCell.identifier
        )

        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

}

extension HomeViewController: HomeViewProtocol {

    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = appNameBarButtonItem
        navigationItem.rightBarButtonItem = searchBarButtonItem
    }

    func setupTabBar() {
        tabBarController?.tabBar.isHidden = false
    }

    func setupLayout() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func presentToSearchViewController() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(
            searchViewController,
            animated: true
        )
    }

    func presentToDetailViewController(with clothes: Clothes) {
        let detailViewController = DetailViewController(clothes: clothes)
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

}

private extension HomeViewController {

    @objc func didTapAppNameBarButtonItem() {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }

    @objc func didTapSearchBarButtonItem() {
        presenter.didTapSearchBarButtonItem()
    }

}
