//
//  MoreViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/28.
//

import SnapKit
import UIKit

final class MoreViewController: UIViewController {
    private lazy var presenter = MorePresenter(viewController: self)

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.delegate = self

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            return self?.createTwoColumnSection()
        }

        return layout
    }

    func createTwoColumnSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(8.0)
        group.contentInsets = .init(
            top: 0, leading: 8.0, bottom: 0, trailing: 8.0
        )

        let section = NSCollectionLayoutSection(
            group: group
        )
        section.interGroupSpacing = 16.0

//        let sectionHeader = createSectionHeader()
//        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

}

extension MoreViewController: UICollectionViewDelegate {

}

extension MoreViewController: MoreViewProtocol {

    func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

}


