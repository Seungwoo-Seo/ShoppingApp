//
//  StyleRecommendationPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import UIKit

protocol StyleRecommendationViewProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
    func reloadCollectionView()
    func endRefreshing()
}

final class StyleRecommendationPresenter: NSObject {
    private weak var viewController: StyleRecommendationViewProtocol?
    private let clothesSearchManager: ClothesSearchManagerProtocol?

    private var styleRecommendationClothesList: [Goods] = []

    // 지금까지 request 된, 가지고 있는 보여주고 있는 page가 어디인지
    private var currentPage = 0
    // 한 페이지에 최대 몇 개까지 보여줄건지
    private let display = 20


    init(
        viewController: StyleRecommendationViewProtocol?,
        clothesSearchManager: ClothesSearchManagerProtocol? = ClothesSearchManager()
    ) {
        self.viewController = viewController
        self.clothesSearchManager = clothesSearchManager
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()

        requestNewList(isNeededToReset: false)
    }

    func didValueChangedRefreshControl() {
        requestNewList(isNeededToReset: true)
    }

}

extension StyleRecommendationPresenter: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleRecommendationClothesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StyleRecommendationCollectionViewCell.identifier,
            for: indexPath
        ) as? StyleRecommendationCollectionViewCell

        let clothes = styleRecommendationClothesList[indexPath.item]
        cell?.configure(with: clothes)

        return cell ?? UICollectionViewCell()
    }

}

extension StyleRecommendationPresenter: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: StyleRecommendationCollectionViewHeader.identifier,
                for: indexPath
            ) as? StyleRecommendationCollectionViewHeader

            header?.configure(with: "당신을 위한 추천")

            return header ?? UICollectionReusableView()
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let currentRow = indexPath.item

        guard (currentRow % display) == display - 4 && (currentRow / display) == (currentPage - 1) else {return}

        requestNewList(isNeededToReset: false)
    }

}

private extension StyleRecommendationPresenter {

    func requestNewList(isNeededToReset: Bool) {
        if isNeededToReset {
            styleRecommendationClothesList = []
            currentPage = 0
        }

        clothesSearchManager?.request(
            with: "세트",
            display: display,
            start: (currentPage * display) + 1
        ) { [weak self] results in
            self?.styleRecommendationClothesList += results
            self?.currentPage += 1
            self?.viewController?.reloadCollectionView()
            self?.viewController?.endRefreshing()
        }
    }

}
