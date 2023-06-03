//
//  HomeCollectionViewMainBannerCellPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/22.
//

import Foundation
import UIKit

protocol HomeCollectionViewMainBannerCellProtocol: AnyObject {
    func configureHierarchy()
    func reloadCollectionView()
    func bannerMove(
        at indexPath: IndexPath,
        at scrollPosition: UICollectionView.ScrollPosition,
        animated: Bool
    )
    func updateBannerIndexLabel(by text: String?)
}

final class HomeCollectionViewMainBannerCellPresenter: NSObject {
    private weak var view: HomeCollectionViewMainBannerCellProtocol?

    /// banner를 자동으로 이동시킬 타이머
    private var bannerTimer: Timer?

    /// 현재 banner의 인덱스
    /// 무한 회전목마 CollectionView이기 때문에 시작이 1
    private var currentBanner = 1

    private var isTimerOnceRun = false

    /// collectionView에서 사용할 데이터
    private var goodsList: [Goods] = [] {
        didSet {
            didValueChangedGoodsList()
        }
    }

    init(
        view: HomeCollectionViewMainBannerCellProtocol?
    ) {
        self.view = view
    }

    func cellInit() {
        view?.configureHierarchy()
        addNotification()
    }

    // 상위 presenter로부터 데이터 받아오기
    func fetchData(_ goodsList: [Goods]) {
        guard !goodsList.isEmpty else {return}
        self.goodsList = goodsList
    }

    func scrollViewWillBeginDragging() {
        stopBannerTimer()
    }

    // 무한 회전목마 구현
    func scrollViewDidScroll(
        scrollView: UIScrollView,
        collectionView: UICollectionView
    ) {
        let width = collectionView.bounds.width
        let count = goodsList.count

        // 좌측 끝까지 갔을 때
        if scrollView.contentOffset.x <= 0 {
            scrollView.setContentOffset(
                .init(
                    x: width * Double(count - 2),
                    y: scrollView.contentOffset.y
                ),
                animated: false
            )
        }

        // 우측 끝까지 갔을 때
        if scrollView.contentOffset.x >= Double(count - 1) * width {
            scrollView.setContentOffset(
                .init(
                    x: width,
                    y: scrollView.contentOffset.y
                ),
                animated: false
            )
        }
    }

    func scrollViewDidEndDecelerating(
        scrollView: UIScrollView,
        collectionView: UICollectionView
    ) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        let point = CGPoint(x: x, y: y)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {return}

        if indexPath.item == 0 {
            currentBanner = goodsList.count - 2
        } else if indexPath.item == goodsList.count - 1 {
            currentBanner = 1
        } else {
            currentBanner = indexPath.item
        }

        createBannerText()
        startBannerTimer()
    }

    func scrollViewDidEndScrollingAnimation(
        scrollView: UIScrollView,
        collectionView: UICollectionView
    ) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        let point = CGPoint(x: x, y: y)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {return}

        if indexPath.item == 0 {
            currentBanner = goodsList.count - 2
        } else if indexPath.item == goodsList.count - 1 {
            currentBanner = 1
        }

        createBannerText()
        startBannerTimer()
    }

}

extension HomeCollectionViewMainBannerCellPresenter: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainBannerCellCollectionViewCell.identifier,
            for: indexPath
        ) as? MainBannerCellCollectionViewCell

        let goods = goodsList[indexPath.item]
        cell?.configure(with: goods)

        return cell ?? UICollectionViewCell()
    }

}

private extension HomeCollectionViewMainBannerCellPresenter {

    func addNotification() {
        // viewWillAppear
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didStarBannerTimer),
            name: NSNotification.Name.startBannerTimer,
            object: nil
        )

        // viewWillDisapper
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didStopBannerTimer),
            name: NSNotification.Name.stopBannerTimer,
            object: nil
        )
    }

    @objc
    func didStarBannerTimer()  {
        if isTimerOnceRun {
            startBannerTimer()
        }
    }

    @objc
    func didStopBannerTimer() {
        stopBannerTimer()
    }

    func didValueChangedGoodsList() {
        // timer 딱 한번만 생성
        if bannerTimer == nil {
            view?.reloadCollectionView()
            view?.bannerMove(
                at: IndexPath(
                    item: currentBanner,
                    section: 0
                ),
                at: .centeredHorizontally,
                animated: true
            )
            isTimerOnceRun = true

            createBannerText()
        }
    }

    func createBannerText() {
        let currentBannerText = "\(currentBanner) / \(goodsList.count - 2)"
        view?.updateBannerIndexLabel(by: currentBannerText)
    }

    func startBannerTimer() {
        // 기존의 Timer 객체가 실행 중인 경우에는 먼저 invalidate() 메소드를 호출하여 중지시킨 후에,
        // 새로운 Timer 객체를 생성하는 것이 좋습니다. 그렇지 않으면,
        // 불필요한 리소스를 사용하게 되어 메모리 부족 등의 문제가 발생할 수 있습니다.

        // 여기서 굳이 stopBannerTimer()를 호출하는 이유는
        // 미친듯이 스크롤하다 보면 Timer가 중첩되어서 2개씩 스크롤되었음.
        // 혹시 모르니까 timer를 새로 생성하기 전에 invalidate()을 호출해서 안정성을 높였다.
        stopBannerTimer()
        bannerTimer = Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: false
        ) { [weak self] _ in
            self?.currentBanner += 1
            self?.view?.bannerMove(
                at: .init(
                    item: self?.currentBanner ?? 0,
                    section: 0
                ),
                at: .centeredHorizontally,
                animated: true
            )
        }
    }

    func stopBannerTimer() {
        bannerTimer?.invalidate()
    }

}
