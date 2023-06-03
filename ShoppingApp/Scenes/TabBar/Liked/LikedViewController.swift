//
//  LikedViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/13.
//

import SnapKit
import UIKit

final class LikedViewController: UIViewController {
    private lazy var presenter = LikedPresenter(
        viewController: self,
        collectionView: collectionView
    )

    private lazy var cartBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: BarButtonItem.cart.image,
            style: .plain,
            target: self,
            action: #selector(didTapCartBarButtonItem)
        )

        return barButtonItem
    }()

    private lazy var searchBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: BarButtonItem.search.image,
            style: .plain,
            target: self,
            action: #selector(didTapSearchBarButtonItem)
        )

        return barButtonItem
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        return collectionView
    }()

    private lazy var hiddenLabel: UILabel = {
        let label = UILabel()
        label.text = """
            마음에 드는 상품을 발견하면
            하트를 눌러 찜해보세요!
        """
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(
            ofSize: 16.0,
            weight: .bold
        )
        label.numberOfLines = 2

        return label
    }()

    private lazy var hiddenButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.background.backgroundColor = .black
        config.title = "추천 상품 보러가기"
        config.background.cornerRadius = 0

        let button = UIButton(configuration: config)
        button.addTarget(
            self,
            action: #selector(didTapHiddenButton),
            for: .touchUpInside
        )

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

extension LikedViewController {

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
            heightDimension: .fractionalHeight(0.1)
        )

        let group: NSCollectionLayoutGroup
        if #available(iOS 16.0, *) {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 2
            )
        } else {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 2
            )
        }

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    func createJustOneItemSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.6),
            heightDimension: .fractionalHeight(0.3)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = .init(
            top: 32.0, leading: 0, bottom: 0, trailing: 0
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

}

extension LikedViewController {



}

extension LikedViewController: LikedViewProtocol {

    func configureNavigationBar() {
        navigationItem.title = "찜"
        navigationItem.rightBarButtonItems = [
            cartBarButtonItem,
            searchBarButtonItem
        ]
    }

    func configureHierarchy() {
        let stackView = UIStackView(
            arrangedSubviews: [
                hiddenLabel,
                hiddenButton
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0

        [collectionView, stackView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

}

private extension LikedViewController {

    @objc
    func didTapCartBarButtonItem() {

    }

    @objc
    func didTapSearchBarButtonItem() {

    }

    @objc
    func didTapHiddenButton() {

    }

}
