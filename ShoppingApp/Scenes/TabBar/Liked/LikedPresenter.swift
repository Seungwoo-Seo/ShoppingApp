//
//  LikedPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/13.
//

import UIKit

protocol LikedViewProtocol: AnyObject {
    func configureNavigationBar()
    func configureHierarchy()
}

final class LikedPresenter {
    private weak var viewController: LikedViewProtocol?
    private weak var collectionView: UICollectionView?

    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemIdentifier>!

    init(
        viewController: LikedViewProtocol?,
        collectionView: UICollectionView?
    ) {
        self.viewController = viewController
        self.collectionView = collectionView
    }

    func viewDidLoad() {
        viewController?.configureNavigationBar()
        viewController?.configureHierarchy()
    }

}

extension LikedPresenter {

    enum Section {
        case hi
    }

    struct ItemIdentifier: Hashable {

        private let id = UUID()
    }

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<LikedCollectionViewCell, ItemIdentifier> { cell, indexPath, itemIdentifier in

        }
    }

}
