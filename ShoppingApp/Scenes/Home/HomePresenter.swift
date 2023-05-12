//
//  HomePresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func setupNavigationBar()
    func setupTabBar()
    func setupLayout()
    func presentToSearchViewController()
    func presentToDetailViewController(with clothes: Clothes)
    func reloadCollectionView()
}

final class HomePresenter: NSObject {
    private weak var viewController: HomeViewProtocol?
    private let clothesSearchManager: ClothesSearchManagerProtocol?


    private var clothesList: [Clothes] = []


    init(
        viewController: HomeViewProtocol?,
        clothesSearchManager: ClothesSearchManagerProtocol? = ClothesSearchManager()
    ) {
        self.viewController = viewController
        self.clothesSearchManager = clothesSearchManager
    }


    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
        clothesSearchManager?.request(with: "청바지") { [weak self] results in
            self?.clothesList = results
            self?.viewController?.reloadCollectionView()
        }
    }

    func viewWillAppear() {
        viewController?.setupTabBar()
    }

    func didTapSearchBarButtonItem() {
        viewController?.presentToSearchViewController()
    }

}

extension HomePresenter: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clothesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCollectionViewCell.identifier,
            for: indexPath
        ) as? HomeCollectionViewCell

        let clothes = clothesList[indexPath.item]
        cell?.setData(with: clothes)

        return cell ?? UICollectionViewCell()
    }

}

extension HomePresenter: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let clothes = clothesList[indexPath.item]
        viewController?.presentToDetailViewController(with: clothes)
    }

}

extension HomePresenter: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemSpacing: CGFloat = 16.0
        let width: CGFloat = (collectionView.bounds.width - itemSpacing * 3) / 2
        let height: CGFloat = width * 1.5

        return CGSize(width: width, height: height)
    }

}
