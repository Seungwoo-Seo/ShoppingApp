//
//  HomeCollectionViewSectionKind.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/14.
//

import Foundation

/// HomeViewController에 collectionView의  섹션 종류
enum HomeCollectionViewSectionKind: Int, CaseIterable {
    case 메인배너
    case 카테고리
    case 오늘의랭킹
    case 오늘구매해야할제품
    case 이주의브랜드이슈
    case 지금눈에띄는후드티
    case 서브배너
    case 일초만에사로잡는나의취향

    var title: String? {
        switch self {
        case .오늘의랭킹: return "오늘의 랭킹"
        case .오늘구매해야할제품: return "오늘 구매해야할 제품"
        case .이주의브랜드이슈: return "이주의 브랜드 이슈"
        case .지금눈에띄는후드티: return "지금 눈에 띄는 후드티"
        case .일초만에사로잡는나의취향: return "1초만에 사로잡는 나의 취향"
        default: return nil
        }
    }
}
