//
//  CategoryCollectionView.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/08.
//

//import SnapKit
//import UIKit
//
//final class CategoryCollectionView: UIView {
//
//    private var collectionView: UICollectionView!
//    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemIdentifier>!
//
//    weak var delegate: CategoryCollectionViewProtocol?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        configureCollectionView()
//        configureHierarchy()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
//extension CategoryCollectionView {
//
//    func createLayout() -> NSCollectionLayoutSection {
//    }
//
//}
//
//extension CategoryCollectionView: CategoryCollectionViewProtocol {
//
//    func configureCollectionView() {
//        collectionView = UICollectionView(
//            frame: .zero,
//            collectionViewLayout: <#T##UICollectionViewLayout#>
//        )
//    }
//
//    func configureHierarchy() {
//        [collectionView].forEach { addSubview($0) }
//
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//}
