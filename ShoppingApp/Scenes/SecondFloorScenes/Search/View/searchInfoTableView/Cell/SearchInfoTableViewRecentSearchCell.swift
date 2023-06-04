//
//  SearchInfoTableViewRecentSearchCell.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/25.
//

import SnapKit
import UIKit
import TTGTags

protocol SearchInfoTableViewRecentSearchCellDelegate: AnyObject {
    func didTapTag(at index: Int)
}

final class SearchInfoTableViewRecentSearchCell: UITableViewCell {
    static let identifier = "SearchInfoTableViewRecentSearchCell"

    private lazy var tagView: TTGTextTagCollectionView = {
        let tagView = TTGTextTagCollectionView()
        tagView.delegate = self
        tagView.numberOfLines = 2
        tagView.alignment = .left
        tagView.scrollDirection = .vertical
        tagView.showsHorizontalScrollIndicator = false
        tagView.showsVerticalScrollIndicator = false

        let inset: CGFloat = 16.0
        tagView.contentInset = UIEdgeInsets(
            top: inset,
            left: 0,
            bottom: 0,
            right: inset
        )

        return tagView
    }()

    weak var delegate: SearchInfoTableViewRecentSearchCellDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()

        configureCell()
        configureHierarchy()
    }

    func configure(with searches: [String]) {
        tagView.removeAllTags()

        let style = TTGTextTagStyle()
        style.backgroundColor = .systemBackground
        style.borderColor = .secondarySystemBackground
        style.borderWidth = 2.0
        style.cornerRadius = 12.0
        style.shadowOpacity = 0
        style.extraSpace = CGSize(
            width: 20.0,
            height: 12.0
        )

        searches.forEach { search in
            let font = UIFont.systemFont(
                ofSize: 16.0,
                weight: .semibold
            )

            let tagContents = TTGTextTagStringContent(
                text: search,
                textFont: font,
                textColor: .gray
            )

            let tag = TTGTextTag(
                content: tagContents,
                style: style,
                selectedContent: nil,
                selectedStyle: nil
            )

            tagView.addTag(tag)
        }

        tagView.reload()
    }

}

extension SearchInfoTableViewRecentSearchCell: TTGTextTagCollectionViewDelegate {

    func textTagCollectionView(
        _ textTagCollectionView: TTGTextTagCollectionView!,
        didTap tag: TTGTextTag!,
        at index: UInt
    ) {
        delegate?.didTapTag(at: Int(index))
    }

}


private extension SearchInfoTableViewRecentSearchCell {

    func configureCell() {
        selectionStyle = .none
    }

    func configureHierarchy() {
        contentView.addSubview(tagView)

        tagView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
