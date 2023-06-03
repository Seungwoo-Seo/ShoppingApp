//
//  CategoryItem.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/22.
//

import Foundation

struct CategoryItem: Hashable {
    let category: String
    private let id = UUID()
}
