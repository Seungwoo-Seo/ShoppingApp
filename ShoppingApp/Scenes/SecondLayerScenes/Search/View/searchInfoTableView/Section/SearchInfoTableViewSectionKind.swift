//
//  SearchInfoTableViewSectionKind.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/25.
//

import Foundation

enum SearchInfoTableViewSectionKind: String, CaseIterable {
    case 최근_검색어
    case 인기_검색어

    var headerTitle: String? {
        switch self {
        case .최근_검색어: return "최근 검색어"
        case .인기_검색어: return "인기 검색어"
        }
    }

}

struct SearchInfo: Hashable {
    // 최근 검색어
    let recenetSearch: [String]?
    // 인기 검색어
    let popularSearch: String?

    private let id = UUID()
}
