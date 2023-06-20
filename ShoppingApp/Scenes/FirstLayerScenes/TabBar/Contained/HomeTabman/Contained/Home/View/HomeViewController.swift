//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import SnapKit
import Toast_Swift
import UIKit

final class HomeViewController: UIViewController {
    private lazy var presenter = HomePresenter(
        viewController: self
    )

    // view
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter.viewWillDisappear()
    }

}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter.didSelectItem(at: indexPath)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        presenter.willDisplay(
            cell: cell,
            forItemAt: indexPath
        )
    }

}

extension HomeViewController: LikedButtonDelegate {

    func didTapLikedButton(_ sender: LikedButton) {
        presenter.didTapLikedButton(sender)
    }

}

extension HomeViewController: HomeCollectionViewMoreFooterDelegate {

    /// HomeCollectionViewMoreFooter에서
    /// MoreButton을 tap 했을 때
    func didTapMoreButton(_ tag: Int) {
        presenter.didTapMoreButton(tag: tag)
    }

}

extension HomeViewController: HomeViewProtocol {

    /// collectionView 구성하는 메소드
    func configureCollectionView() {
        let layout = HomeCollectionViewLayout.default.createLayout

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.delegate = self

        // Cell 등록
        let cellRegister = HomeCollectionViewRegister.default.cellRegister
        cellRegister.forEach {
            collectionView.register(
                $0.cellClass,
                forCellWithReuseIdentifier: $0.identifier
            )
        }

        // Supplementary 등록
        let supplementaryRegister = HomeCollectionViewRegister.default.supplementaryRegister
        supplementaryRegister.forEach {
            collectionView.register(
                $0.viewClass,
                forSupplementaryViewOfKind: $0.kind,
                withReuseIdentifier: $0.identifier
            )
        }
    }

    /// 계층구조 설정 및 오토레이아웃 설정
    func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    /// notification 옵저버 추가
    func addNotification() {
        // horseViewController에서 tap 이벤트가 발생했을 때
        // 해당 goods를 전달 받기 위해서 옵저버 추가
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(goodsOfHorseNotificationCame),
            name: NSNotification.Name.goodsOfHorse,
            object: nil
        )
    }

    /// notification 옵저버 해제
    func removeNotification() {
        // goodsOfHorse 옵저버 해제
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.goodsOfHorse,
            object: nil
        )
    }

    /// SearchViewController로 push
    func pushToSearchViewController() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(
            searchViewController,
            animated: true
        )
    }

    /// WebViewController로 push
    func pushToWebViewController(
        with goods: Goods
    ) {
        let webViewController = WebViewController(
            goods: goods
        )
        navigationController?.pushViewController(
            webViewController,
            animated: true
        )
    }

    /// MoreViewController로 push
    func pushToMoreViewController(
        with request: String
    ) {
        let moreViewController = MoreViewController(
            request: request
        )
        navigationController?.pushViewController(
            moreViewController,
            animated: true
        )
    }

    /// collectionview를 reload하는 메소드
    func reloadCollectionView() {
        collectionView.reloadData()
    }

    /// collectionview의 특정 섹션만 reload하는 메소드
    func reloadCollectionView(with rawValue: Int) {
        collectionView.reloadSections(
            IndexSet(integer: rawValue)
        )
    }

    /// InfinityCarouselViewController를 표시하는 메소드
    /// - Parameters
    ///     - container: container가 될 view
    ///     - goodsList: content에 전달할 데이터
    func display(
        to container: UIView,
        goodsList: [Goods]
    ) {
        let content = InfinityCarouselViewController(
            goodsList: goodsList
        )
        addChild(content)
        content.view.frame = container.bounds
        container.addSubview(content.view)
        content.didMove(toParent: self)
    }

    func presentErrorToast(message: String) {
        view.makeToast(message, position: .bottom)
    }

}

private extension HomeViewController {

    /// goodsOfHorse란 이름을 가진
    /// Notification이 post를 보냈을 때
    @objc
    func goodsOfHorseNotificationCame(
        _ notification: NSNotification
    ) {
        presenter.goodsOfHorseNotificationCame(
            notification
        )
    }

}
