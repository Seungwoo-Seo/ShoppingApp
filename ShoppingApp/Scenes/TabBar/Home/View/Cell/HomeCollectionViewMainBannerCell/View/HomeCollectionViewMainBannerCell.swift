//
//  HomeCollectionViewMainBannerCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/22.
//

import SnapKit
import UIKit
import Kingfisher

final class HomeCollectionViewMainBannerCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewMainBannerCell"

    private lazy var presenter = HomeCollectionViewMainBannerCellPresenter(
        view: self
    )

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(
            MainBannerCellCollectionViewCell.self,
            forCellWithReuseIdentifier: MainBannerCellCollectionViewCell.identifier
        )

        return collectionView
    }()

    private lazy var bannerIndexLabel: PaddingLabel = {
        let label = PaddingLabel(
            padding: .init(
                top: 4.0,
                left: 16.0,
                bottom: 4.0,
                right: 16.0
            )
        )
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.cornerRadius = 12.0
        label.clipsToBounds = true

        return label
    }()

    weak var delegate: HomeCollectionViewMainBannerCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        presenter.cellInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        with goodsList: [Goods],
        delegate: HomeCollectionViewMainBannerCellDelegate?
    ) {
        presenter.fetchData(goodsList)
        self.delegate = delegate
    }

}

extension HomeCollectionViewMainBannerCell: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height

        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        delegate?.mainBannerCellCollectionView(
            didSelectItemAt: indexPath
        )
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        presenter.scrollViewWillBeginDragging()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.scrollViewDidScroll(
            scrollView: scrollView,
            collectionView: collectionView
        )
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        presenter.scrollViewDidEndDecelerating(
            scrollView: scrollView,
            collectionView: collectionView
        )
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        presenter.scrollViewDidEndScrollingAnimation(
            scrollView: scrollView,
            collectionView: collectionView
        )
    }

}

extension HomeCollectionViewMainBannerCell: HomeCollectionViewMainBannerCellProtocol {

    func configureHierarchy() {
        [
            collectionView,
            bannerIndexLabel
        ].forEach { contentView.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bannerIndexLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
    }

    func reloadCollectionView() {
        // layoutIfNeeded()를 먼저 호출하는 이유는
        // reloadData() 호출 후 collectionView.scrollToItem()을
        // 호출해도 적용되지 않음
        // 이유는 collectionView의 레이아웃이 다 그려지지 않았기 때문
        // layoutIfNeeded()를 먼저 호출해줌으로 레이아웃을 강제로
        // 먼저 그리기 때문에 데이터와 상관없이 scrollToItem()를 사용가능
        // 다른 방법으로 reloadData() 이후
        // DispatchQueue를 사용해서 0.1초 딜레이 주는 방법도 있음
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
    }

    func bannerMove(
        at indexPath: IndexPath,
        at scrollPosition: UICollectionView.ScrollPosition,
        animated: Bool
    ) {
        collectionView.scrollToItem(
            at: indexPath,
            at: scrollPosition,
            animated: animated
        )
    }

    func updateBannerIndexLabel(by text: String?) {
        bannerIndexLabel.text = text
    }

}
