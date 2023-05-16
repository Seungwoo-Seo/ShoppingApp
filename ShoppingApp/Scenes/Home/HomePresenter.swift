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

    private var model = HomeModel()

    private var mainClothes: [Clothes] = []
    private var categorys = [
        "남성패션",
        "여성패션",
        "화장품",
        "가구",
        "식품",
        "유아동",
        "반려동물",
        "생활/주방",
        "가전",
        "스포츠"
    ]
    private var clothesList: [Clothes] = []
    private var threeRowClothes: [Clothes] = []
    private var rankClothes: [Clothes] = []

    private var nowLookingClothes: [Clothes] = []
    private var subBannerClothes: [Clothes] = []
    private var oneSecondMyFavoriteClothes: [Clothes] = []


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
        clothesSearchManager?.request(with: "자켓") { [weak self] results in
            self?.mainClothes = results
            self?.viewController?.reloadCollectionView()
        }
        clothesSearchManager?.request(with: "남성 청바지") { [weak self] results in
            self?.clothesList = results
            self?.viewController?.reloadCollectionView()
        }
        clothesSearchManager?.request(with: "셔츠") { [weak self] results in
            self?.threeRowClothes = results
            self?.viewController?.reloadCollectionView()
        }
        clothesSearchManager?.request(with: "양말") { [weak self] results in
            self?.rankClothes = results
            self?.viewController?.reloadCollectionView()
        }
        clothesSearchManager?.request(with: "후드티") { [weak self] results in
            self?.nowLookingClothes = results
            self?.viewController?.reloadCollectionView()
        }
        clothesSearchManager?.request(with: "양말") { [weak self] results in
            self?.subBannerClothes = results
            self?.viewController?.reloadCollectionView()
        }
        clothesSearchManager?.request(with: "스포츠 의류") { [weak self] results in
            self?.oneSecondMyFavoriteClothes = results
            self?.viewController?.reloadCollectionView()
        }
    }

    func viewWillAppear() {
        viewController?.setupTabBar()
        model.addStateDidChangeListener()
    }

    func viewWillDisappear() {
        model.removeStateDidChangeListener()
    }

    func didTapSearchBarButtonItem() {
        viewController?.presentToSearchViewController()
    }

}

extension HomePresenter: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mainClothes.count
        case 1:
            return categorys.count
        case 2:
            return rankClothes.count
        case 3:
            return clothesList.count
        case 4:
            return threeRowClothes.count
        case 5:
            return nowLookingClothes.count
        case 6:
            return subBannerClothes.count
        case 7:
            return oneSecondMyFavoriteClothes.count
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeCollectionViewHeader.identifier,
                for: indexPath
              ) as? HomeCollectionViewHeader else { return UICollectionReusableView() }

        switch indexPath.section {
        case 2:
            headerView.setData(with: "오늘의 랭킹")
            return headerView
        case 3:
            headerView.setData(with: "오늘 구매해야 할 아우터")
            return headerView
        case 4:
            headerView.setData(with: "이주의 브랜드 이슈")
            return headerView
        case 5:
            headerView.setData(with: "지금 눈에띄는 후드티")
            return headerView
        case 7:
            headerView.setData(with: "1초만에 사로잡는 나의 취향")
            return headerView
        default:
            return headerView
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewFullOneRowListCell.identifier,
                for: indexPath
            ) as? CollectionViewFullOneRowListCell


            let mainClothes = mainClothes[indexPath.item]
            cell?.setData(with: mainClothes)

            return cell ?? UICollectionViewCell()

        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewFiveColumnGridCell.identifier,
                for: indexPath
            ) as? CollectionViewFiveColumnGridCell

            let category = categorys[indexPath.item]
            cell?.setData(with: category)

            return cell ?? UICollectionViewCell()

        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewRankOneRowListCell.identifier,
                for: indexPath
            ) as? CollectionViewRankOneRowListCell

            let clothes = rankClothes[indexPath.item]
            cell?.setData(
                with: clothes,
                item: indexPath.item + 1
            )

            return cell ?? UICollectionViewCell()

        case 3:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewTwoColumnGridCell.identifier,
                for: indexPath
            ) as? CollectionViewTwoColumnGridCell

            let clothes = clothesList[indexPath.item]
            cell?.setData(with: clothes)

            return cell ?? UICollectionViewCell()

        case 4:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewThreeRowListCell.identifier,
                for: indexPath
            ) as? CollectionViewThreeRowListCell

            let clothes = threeRowClothes[indexPath.item]
            cell?.setData(with: clothes)

            return cell ?? UICollectionViewCell()

        case 5:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewNowLookingCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewNowLookingCell

            let clothes = nowLookingClothes[indexPath.item]
            cell?.setData(with: clothes)

            return cell ?? UICollectionViewCell()

        case 6:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewSubBannerCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewSubBannerCell

            let clothes = subBannerClothes[indexPath.item]
            cell?.setData(with: clothes)

            return cell ?? UICollectionViewCell()

        case 7:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCollectionViewOneSecondMyFavoriteCell.identifier,
                for: indexPath
            ) as? HomeCollectionViewOneSecondMyFavoriteCell

            let clothes = oneSecondMyFavoriteClothes[indexPath.item]
            cell?.setData(with: clothes)

            return cell ?? UICollectionViewCell()

        default:
            return UICollectionViewCell()
        }
    }

}

extension HomePresenter: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var clothes: Clothes

        switch indexPath.section {
        case 0:
            clothes = mainClothes[indexPath.item]
        case 1:
            // MARK: 여기 데이터 바꿔야해~
            clothes = mainClothes[indexPath.item]
        case 2:
            clothes = rankClothes[indexPath.item]
        case 3:
            clothes = clothesList[indexPath.item]
        case 4:
            clothes = threeRowClothes[indexPath.item]
        case 5:
            clothes = nowLookingClothes[indexPath.item]
        case 6:
            clothes = subBannerClothes[indexPath.item]
        case 7:
            clothes = oneSecondMyFavoriteClothes[indexPath.item]
        default:
            fatalError("뭐냐 넌")
        }

        viewController?.presentToDetailViewController(with: clothes)
    }

}
