//
//  StyleRecommendationPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/03.
//

import UIKit

protocol StyleRecommendationViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureCollectionView()
    func configureHierarchy()
    func reloadCollectionView()
    func endRefreshing()

    func createLayout() -> UICollectionViewLayout
    func createTwoColumnSection() -> NSCollectionLayoutSection
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem
}

final class StyleRecommendationPresenter: NSObject {
    private weak var viewController: StyleRecommendationViewProtocol?
    private var goodsSearchManager: GoodsSearchManagerProtocol?

    private var goodsList: [Goods] = []

    // 지금까지 request 된, 가지고 있는 보여주고 있는 page가 어디인지
    private var currentPage = 0
    // 한 페이지에 최대 몇 개까지 보여줄건지
    private let display = 20


    init(
        viewController: StyleRecommendationViewProtocol?,
        goodsSearchManager: GoodsSearchManagerProtocol? = GoodsSearchManager()
    ) {
        self.viewController = viewController
        self.goodsSearchManager = goodsSearchManager
    }

    func viewDidLoad() {
        viewController?.configureNavigationBar()
        viewController?.configureCollectionView()
        viewController?.configureHierarchy()

        requestNewList(isNeededToReset: false)
    }

    func createLayout(
        sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? {
        guard let sectionLayoutKind = StyleRecommendationCollectionViewSectionKind(
            rawValue: sectionIndex
        ) else { return nil }

        switch sectionLayoutKind {
        case .당신을위한추천:
            return viewController?.createTwoColumnSection()
        }
    }

    func didValueChangedRefreshControl() {
        requestNewList(isNeededToReset: true)
    }

}

extension StyleRecommendationPresenter: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return goodsList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StyleRecommendationCollectionViewCell.identifier,
            for: indexPath
        ) as? StyleRecommendationCollectionViewCell

        if !goodsList.isEmpty {
            let goods = goodsList[indexPath.item]
            cell?.configure(with: goods)
        }

        return cell ?? UICollectionViewCell()
    }

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
}

extension StyleRecommendationPresenter: UICollectionViewDataSourcePrefetching {

    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        guard currentPage != 0 else {return}

        indexPaths.forEach {
            if ($0.item + 1)/display + 1 == currentPage {
                requestNewList(isNeededToReset: false)
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
    ) {

    }

}

private extension StyleRecommendationPresenter {

    func requestNewList(isNeededToReset: Bool) {
        if isNeededToReset {
            goodsList = []
            currentPage = 0
            goodsSearchManager?.dataTasksReset()
        }

        goodsSearchManager?.request(
            with: "세트",
            display: display,
            start: (currentPage * display) + 1
        ) { [weak self] results in
            self?.goodsList += results
            self?.currentPage += 1
            self?.viewController?.reloadCollectionView()
            self?.viewController?.endRefreshing()
        }
    }

}
