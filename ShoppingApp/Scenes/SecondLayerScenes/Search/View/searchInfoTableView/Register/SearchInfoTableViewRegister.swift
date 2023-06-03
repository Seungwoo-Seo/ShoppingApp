//
//  SearchInfoTableViewRegister.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/25.
//

import Foundation

enum SearchInfoTableViewRegister: TableViewRegister {
    case `default`

    var cellRegister: [CellRegister] {
        return [
            (
                SearchInfoTableViewRecentSearchCell.self,
                SearchInfoTableViewRecentSearchCell.identifier
            ),
            (
                SearchInfoTableViewPopularSearchCell.self,
                SearchInfoTableViewPopularSearchCell.identifier
            )
        ]
    }

    var supplementaryRegister: [SupplementaryRegister] {
        return [
            (
                SearchInfoTableViewRecentSearchHeader.self,
                SearchInfoTableViewRecentSearchHeader.identifier
            ),
            (
                SearchInfoTableViewPopularSearchHeader.self,
                SearchInfoTableViewPopularSearchHeader.identifier
            )
        ]
    }

}
