//
//  MorePresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/28.
//

import UIKit

protocol MoreViewProtocol: AnyObject {
    func configureHierarchy()
}


enum MoreCollectionViewSectionKind: Int, CaseIterable {
    case 더보기
}


final class MorePresenter: NSObject {
    private weak var viewController: MoreViewProtocol?

    init(
        viewController: MoreViewProtocol?
    ) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.configureHierarchy()
    }

}

extension MorePresenter: UICollectionViewDataSource {

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return MoreCollectionViewSectionKind.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        UICollectionViewCell()
    }


}
