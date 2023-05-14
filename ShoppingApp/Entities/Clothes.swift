//
//  Clothes.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import Foundation

struct Clothes: Decodable {
    /// 상품 이름
    let title: String
    /// 상품 정보 URL
    let link: String
    /// 섬네일 이미지의 URL
    private let image: String
    /// 최저가. 최저가 정보가 없으면 0을 반환합니다. 가격 비교 데이터가 없으면 상품 가격을 의미합니다.
    let lprice: String
    /// 최고가. 최고가 정보가 없거나 가격 비교 데이터가 없으면 0을 반환합니다.
    let hprice: String
    /// 상품을 판매하는 쇼핑몰. 쇼핑몰 정보가 없으면 네이버를 반환합니다.
    let mallName: String

    /// image 문자열을 URL로 타입 캐스팅합니다.
    var imageURL: URL? {
        return URL(string: image)
    }

}
