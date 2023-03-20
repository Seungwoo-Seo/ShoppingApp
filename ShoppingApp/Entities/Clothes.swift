//
//  Clothes.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import Foundation

struct Clothes: Decodable {

    let title: String
    let link: String
    private let image: String
    let lprice: String
    let hprice: String
    let mallName: String


    var imageURL: URL? {
        return URL(string: image)
    }

}
