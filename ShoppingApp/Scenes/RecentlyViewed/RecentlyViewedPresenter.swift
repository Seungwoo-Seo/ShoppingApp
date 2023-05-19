//
//  RecentlyViewedPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import UIKit

protocol RecentlyViewedViewProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
    func reloadCollectionView()
}

final class RecentlyViewedPresenter: NSObject {
    private weak var viewController: RecentlyViewedViewProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtocl?
    private var recentlyViewedClothesList: [Clothes] = []

    init(
        viewController: RecentlyViewedViewProtocol?,
        userDefaultsManager: UserDefaultsManagerProtocl? = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
    }

    func viewWillAppear() {
        recentlyViewedClothesList =  userDefaultsManager?.getClothes() ?? []
        viewController?.reloadCollectionView()
    }

}

extension RecentlyViewedPresenter: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentlyViewedClothesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedCollectionViewCell.identifier, for: indexPath) as? RecentlyViewedCollectionViewCell

        let clothes = recentlyViewedClothesList[indexPath.item]
        cell?.configure(with: clothes)

        return cell ?? UICollectionViewCell()
    }

}

extension RecentlyViewedPresenter: UICollectionViewDelegate {

}

extension RecentlyViewedPresenter: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemSpacing: CGFloat = 8.0
        let contentInset: CGFloat = 16.0

        let witdh = (collectionView.bounds.width - itemSpacing * 2 - contentInset * 2) / 3
        let height = witdh * 1.7

        return CGSize(width: witdh, height: height)
    }

}
