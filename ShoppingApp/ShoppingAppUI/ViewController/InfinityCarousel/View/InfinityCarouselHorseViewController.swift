//
//  InfinityCarouselHorseViewController.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/18.
//

import Kingfisher
import SnapKit
import UIKit

final class InfinityCarouselHorseViewController: UIViewController {
    // presenter
    private var presenter: InfinityCarouselHorsePresenter!

    // views
    private lazy var thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill

        return imageView
    }()

    // inits
    init(
        goods: Goods
    ) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = InfinityCarouselHorsePresenter(
            viewController: self,
            goods: goods
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

extension InfinityCarouselHorseViewController: InfinityCarouselHorseViewProtocol {

    func configureHierarchy() {
        [thumnailImageView].forEach { view.addSubview($0) }

        thumnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setImageThumnailImageView(by imageURL: URL?) {
        thumnailImageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage.placeholder
        )
    }

    func addTapGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapGesture)
        )
        view.addGestureRecognizer(tap)
    }

}

private extension InfinityCarouselHorseViewController {

    @objc
    func didTapGesture() {
        presenter.didTapGesture()
    }

}
