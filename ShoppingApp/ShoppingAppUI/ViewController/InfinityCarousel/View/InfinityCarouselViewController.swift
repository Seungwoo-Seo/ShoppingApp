//
//  InfinityCarouselViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/18.
//

import SnapKit
import UIKit
import Pageboy

final class InfinityCarouselViewController: PageboyViewController {
    // presenter
    private var presenter: InfinityCarouselPresenter!

    // views
    private lazy var bannerIndexLabel: PaddingLabel = {
        let label = PaddingLabel(
            padding: .init(
                top: 4.0,
                left: 16.0,
                bottom: 4.0,
                right: 16.0
            )
        )
        label.font = .systemFont(
            ofSize: 14.0,
            weight: .regular
        )
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.cornerRadius = 12.0
        label.clipsToBounds = true

        return label
    }()

    // inits
    init(
        goodsList: [Goods]?
    ) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = InfinityCarouselPresenter(
            viewController: self,
            goodsList: goodsList
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

}

extension InfinityCarouselViewController: PageboyViewControllerDelegate {

    func pageboyViewController(
        _ pageboyViewController: Pageboy.PageboyViewController,
        willScrollToPageAt index: Pageboy.PageboyViewController.PageIndex,
        direction: Pageboy.PageboyViewController.NavigationDirection,
        animated: Bool
    ) {}

    func pageboyViewController(
        _ pageboyViewController: Pageboy.PageboyViewController,
        didScrollTo position: CGPoint,
        direction: Pageboy.PageboyViewController.NavigationDirection,
        animated: Bool
    ) {}

    func pageboyViewController(
        _ pageboyViewController: Pageboy.PageboyViewController,
        didCancelScrollToPageAt index: Pageboy.PageboyViewController.PageIndex,
        returnToPageAt previousIndex: Pageboy.PageboyViewController.PageIndex
    ) {}

    func pageboyViewController(
        _ pageboyViewController: Pageboy.PageboyViewController,
        didScrollToPageAt index: Pageboy.PageboyViewController.PageIndex,
        direction: Pageboy.PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        presenter.didScrollToPage(at: index)
    }

    func pageboyViewController(
        _ pageboyViewController: Pageboy.PageboyViewController,
        didReloadWith currentViewController: UIViewController,
        currentPageIndex: Pageboy.PageboyViewController.PageIndex
    ) {}

}

extension InfinityCarouselViewController: InfinityCarouselViewProtocol {

    func configurePageboyViewController() {
        dataSource = presenter
        delegate = self
        isInfiniteScrollEnabled = true
    }

    func configureAutoScroller() {
        // 멈췄을 때 다시 시작할지 여부
        autoScroller.restartsOnScrollEnd = true
    }

    func configureHierarchy() {
        [bannerIndexLabel].forEach { view.addSubview($0) }

        bannerIndexLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
    }

    func reloadPageboyViewControllerDataSource() {
        reloadData()
    }

    func updateBannerIndexLabel(by text: String?) {
        bannerIndexLabel.text = text
    }

    func autoScroll(_ duration: TimeInterval) {
        autoScroller.enable(
            withIntermissionDuration: .custom(duration: duration)
        )
    }

}
