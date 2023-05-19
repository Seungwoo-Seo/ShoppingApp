//
//  RecentlyViewedViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import SnapKit
import UIKit

final class RecentlyViewedViewController: UIViewController {
    private lazy var presenter = RecentlyViewedPresenter(viewController: self)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16.0
        layout.minimumInteritemSpacing = 8.0
        layout.sectionInset = .init(
            top: 16.0,
            left: 16.0,
            bottom: 16.0,
            right: 16.0
        )

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.delegate = presenter
        collectionView.register(
            RecentlyViewedCollectionViewCell.self,
            forCellWithReuseIdentifier: RecentlyViewedCollectionViewCell.identifier
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

extension RecentlyViewedViewController: RecentlyViewedViewProtocol {

    func setupNavigationBar() {
        navigationItem.title = "최근 본 상품"
    }

    func setupLayout() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

}
