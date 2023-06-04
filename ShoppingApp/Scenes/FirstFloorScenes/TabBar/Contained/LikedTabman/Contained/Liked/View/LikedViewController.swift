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
        viewController: self
    )

    // views
    private var collectionView: UICollectionView!
    private var hiddenLabel: UILabel!
    private var hiddenButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

}

extension LikedViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter.didSelectItem(at: indexPath)
    }

}

extension LikedViewController: LikedButtonDelegate {

    func didTapLikedButton(_ sender: LikedButton) {
        presenter.didTapLikedButton(sender)
    }

}

extension LikedViewController: LikedViewProtocol {

    func configureCollectionView() {
        let layout = LikedCollectionViewLayout.default.createLayout
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = presenter
        collectionView.delegate = self

        // cell 등록
        let cellRegister = LikedCollectionViewRegister.default.cellRegister
        cellRegister.forEach {
            collectionView.register(
                $0.cellClass,
                forCellWithReuseIdentifier: $0.identifier
            )
        }
    }

    func configureHiddenLabel() {
        hiddenLabel = UILabel()
        hiddenLabel.text = """
            마음에 드는 상품을 발견하면
            하트를 눌러 찜해보세요!
        """
        hiddenLabel.textColor = .gray
        hiddenLabel.textAlignment = .center
        hiddenLabel.font = .systemFont(
            ofSize: 16.0,
            weight: .bold
        )
        hiddenLabel.numberOfLines = 2
    }

    func configureHiddenButton() {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.background.backgroundColor = .black
        config.title = "추천 상품 보러가기"
        config.background.cornerRadius = 0

        hiddenButton = UIButton(configuration: config)
        hiddenButton.addTarget(
            self,
            action: #selector(didTapHiddenButton),
            for: .touchUpInside
        )
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

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func isHidden(
        collectionView: Bool,
        hiddenLabel: Bool,
        hiddenButton: Bool
    ) {
        self.collectionView.isHidden = collectionView
        self.hiddenLabel.isHidden = hiddenLabel
        self.hiddenButton.isHidden = hiddenButton
    }

    func pushToWebViewController(with goods: Goods) {
        let webViewController = WebViewController(
            goods: goods
        )
        navigationController?.pushViewController(
            webViewController,
            animated: true
        )
    }

    func pushToMoreViewController(with request: String) {
        let moerViewController = MoreViewController(
            request: request
        )
        navigationController?.pushViewController(
            moerViewController,
            animated: true
        )
    }

    func collectionViewDeleteItems(
        at indexPaths: [IndexPath]
    ) {
        collectionView.deleteItems(at: indexPaths)
    }

}

private extension LikedViewController {

    @objc
    func didTapHiddenButton() {
        presenter.didTapHiddenButton()
    }

}
