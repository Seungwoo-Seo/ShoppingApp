//
//  InfinityCarouselHorsePresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/18.
//

import Foundation

protocol InfinityCarouselHorseViewProtocol: AnyObject {
    func configureHierarchy()
    func setImageThumnailImageView(by imageURL: URL?)
    func addTapGesture()
}

final class InfinityCarouselHorsePresenter {
    // view
    private weak var viewController: InfinityCarouselHorseViewProtocol!

    // data
    private var goods: Goods

    init(
        viewController: InfinityCarouselHorseViewProtocol!,
        goods: Goods
    ) {
        self.viewController = viewController
        self.goods = goods
    }

    func viewDidLoad() {
        viewController.configureHierarchy()
        viewController.setImageThumnailImageView(
            by: goods.imageURL
        )
        viewController.addTapGesture()
    }

}

// private
extension InfinityCarouselHorsePresenter {

    func didTapGesture() {
        NotificationCenter.default.post(
            name: NSNotification.Name.goodsOfHorse,
            object: nil,
            userInfo: ["goods": goods]
        )
    }

}
