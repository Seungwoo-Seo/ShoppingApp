//
//  MyPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/29.
//

import UIKit

protocol MyViewProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
    func pushToAccountViewController()
    func reloadCollectionView()
    func pushToRecentlyViewedViewController()
}

final class MyPresenter: NSObject {
    private weak var viewController: MyViewProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtocl?

    private var model = MyModel()

    private var recentlyViewedClothesList: [Goods] = []

    init(
        viewController: MyViewProtocol?,
        userDefaultsManager: UserDefaultsManagerProtocl? = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }

    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
    }

    func viewWillApper() {
        recentlyViewedClothesList = userDefaultsManager?.getClothes() ?? []
        viewController?.reloadCollectionView()
    }

    func didTapAccountBarButtonItem() {
        viewController?.pushToAccountViewController()
    }

}

extension MyPresenter: UICollectionViewDataSource {

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        if recentlyViewedClothesList.isEmpty {
            return 3
        } else {
            return 4
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if section == 3 {
            return recentlyViewedClothesList.count
        }

        return model.cellCount(of: section)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCollectionViewPointCouponOrderDeliveryCell.identifier,
                for: indexPath
            ) as? MyCollectionViewPointCouponOrderDeliveryCell

            let cellData = model.cellData(
                of: indexPath.section,
                item: indexPath.item
            )

            cell?.configure(with: cellData)

            return cell ?? UICollectionViewCell()

        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCollectionViewBannerCell.identifier,
                for: indexPath
            ) as? MyCollectionViewBannerCell

            return cell ?? UICollectionViewCell()

        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCollectionViewMyShoppingCell.identifier,
                for: indexPath
            ) as? MyCollectionViewMyShoppingCell

            let cellData = model.cellData(
                of: indexPath.section,
                item: indexPath.item
            )

            cell?.configure(with: cellData)

            return cell ?? UICollectionViewCell()

        case 3:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCollectionViewRecentlyViewedCell.identifier,
                for: indexPath
            ) as? MyCollectionViewRecentlyViewedCell

            let clothes = recentlyViewedClothesList[indexPath.item]
            cell?.configure(with: clothes)

            return cell ?? UICollectionViewCell()

        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 2:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyCollectionViewHeader.identifier,
                    for: indexPath
                ) as? MyCollectionViewHeader

                headerView?.configure(with: "MY쇼핑")

                return headerView ?? UICollectionReusableView()
            case 3:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyCollectionViewDetailHeader.identifier,
                    for: indexPath
                ) as? MyCollectionViewDetailHeader

                headerView?.configure(
                    with: "최근 본 상품",
                    delegate: self
                )

                return headerView ?? UICollectionReusableView()
            default:
                return UICollectionReusableView()
            }

        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyCollectionViewFooter.identifier,
                for: indexPath
            ) as? MyCollectionViewFooter

            return footerView ?? UICollectionReusableView()

        default:
            return UICollectionReusableView()
        }
    }

}

extension MyPresenter: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }

}

extension MyPresenter: MyCollectionViewButtonDelegate {

    func didTapAccessoryButton() {
        viewController?.pushToRecentlyViewedViewController()
    }

}
