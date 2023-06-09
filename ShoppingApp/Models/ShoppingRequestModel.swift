//
//  ShoppingRequestModel.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import Foundation

struct ShoppingRequestModel: Codable {
    /// 검색어
    let query: String
    /// 한 번에 표시할 검색 결과 개수(기본값: 10, 최댓값: 100)
    let display: Int
    /// 검색 시작 위치(기본값: 1, 최댓값: 1000)
    let start: Int

    var url: URL? {
        var components = URLComponents(
            string: "https://openapi.naver.com/v1/search/shop.json"
        )
        let display = URLQueryItem(
            name: "display",
            value: "\(display)"
        )
        let start = URLQueryItem(
            name: "start",
            value: "\(start)"
        )
        components?.queryItems = [
            display,
            start
        ]

        return components?.url
    }
}
