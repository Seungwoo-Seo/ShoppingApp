//
//  AccountTableViewRegister.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/23.
//

import UIKit

protocol TableViewRegister {
    typealias CellRegister = (
        cellClass: AnyClass?,
        identifier: String
    )

    typealias SupplementaryRegister = (
        aClass: AnyClass?,
        identifier: String
    )

    var cellRegister: [CellRegister] {get}
    var supplementaryRegister: [SupplementaryRegister] {get}
}

enum AccountTableViewRegister: TableViewRegister {
    case `default`

    var cellRegister: [CellRegister] {
        return [
            (AccountTableViewCell.self,
             AccountTableViewCell.identifier)
        ]
    }

    var supplementaryRegister: [SupplementaryRegister] {
        return [
            (AccountTableViewHeader.self,
             AccountTableViewHeader.identifier),
            (AccountTableViewFooter.self,
             AccountTableViewFooter.identifier)
        ]
    }

}
