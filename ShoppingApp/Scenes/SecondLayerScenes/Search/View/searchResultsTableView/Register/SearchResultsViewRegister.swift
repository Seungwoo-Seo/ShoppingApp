//
//  SearchResultsViewRegister.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/25.
//

import Foundation

enum SearchResultsViewRegister: TableViewRegister {
    case `default`

    var cellRegister: [CellRegister] {
        return [
            (
                SearchResultsTableViewCell.self,
                SearchResultsTableViewCell.identifier
            )
        ]
    }

    var supplementaryRegister: [SupplementaryRegister] {
        return []
    }

}
