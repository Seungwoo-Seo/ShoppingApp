//
//  CategoryCollectionViewSectionKind.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/22.
//

import Foundation

/// CategoryViewController에 collectionView의 섹션 종류
enum CategoryCollectionViewSectionKind: Int, CaseIterable {
    case 브랜드
    case 쇼핑몰
    case 럭셔리
    case 스포츠
    case 디지털
    case 라이프

    var title: String {
        switch self {
        case .브랜드: return "브랜드"
        case .쇼핑몰: return "쇼핑몰"
        case .럭셔리: return "럭셔리"
        case .스포츠: return "스포츠"
        case .디지털: return "디지털"
        case .라이프: return "라이프"
        }
    }

    var categorys: [CategoryItem] {
        switch self {
        case .브랜드:
            return [
                CategoryItem(category: "아우터"),
                CategoryItem(category: "상의"),
                CategoryItem(category: "셔츠"),
                CategoryItem(category: "바지"),
                CategoryItem(category: "신발"),
                CategoryItem(category: "시계"),
                CategoryItem(category: "모자"),
                CategoryItem(category: "아이웨어"),
                CategoryItem(category: "잡화"),
                CategoryItem(category: "가방"),
                CategoryItem(category: "언더웨어")
            ]
        case .쇼핑몰:
            return [
                CategoryItem(category: "아우터"),
                CategoryItem(category: "상의"),
                CategoryItem(category: "셔츠"),
                CategoryItem(category: "바지"),
                CategoryItem(category: "신발"),
                CategoryItem(category: "시계"),
                CategoryItem(category: "모자"),
                CategoryItem(category: "아이웨어"),
                CategoryItem(category: "잡화"),
                CategoryItem(category: "가방"),
                CategoryItem(category: "빅사이즈")
            ]
        case .럭셔리:
            return [
                CategoryItem(category: "상의"),
                CategoryItem(category: "니트"),
                CategoryItem(category: "아우터"),
                CategoryItem(category: "셔츠"),
                CategoryItem(category: "바지"),
                CategoryItem(category: "언더웨어"),
                CategoryItem(category: "신발"),
                CategoryItem(category: "가방"),
                CategoryItem(category: "잡화")
            ]
        case .스포츠:
            return [
                CategoryItem(category: "패션"),
                CategoryItem(category: "아웃도어"),
                CategoryItem(category: "헬스"),
                CategoryItem(category: "골프"),
                CategoryItem(category: "용품"),
                CategoryItem(category: "기타")
            ]
        case .디지털:
            return [
                CategoryItem(category: "컴퓨터/모바일"),
                CategoryItem(category: "사운드"),
                CategoryItem(category: "홈"),
                CategoryItem(category: "게임"),
                CategoryItem(category: "모빌리티"),
                CategoryItem(category: "포토"),
                CategoryItem(category: "악세서리"),
                CategoryItem(category: "기타")
            ]
        case .라이프:
            return [
                CategoryItem(category: "캠핑"),
                CategoryItem(category: "그루밍"),
                CategoryItem(category: "자동차"),
                CategoryItem(category: "생활용품"),
                CategoryItem(category: "홈데코"),
                CategoryItem(category: "기타")
            ]
        }
    }

}
