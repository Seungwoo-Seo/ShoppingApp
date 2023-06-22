//
//  MyCollectionViewSectionKind.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/23.
//

import Foundation
import UIKit

enum MyCollectionViewSectionKind: Int, CaseIterable {
    case 포인트_쿠폰_주문배송조회
    case 광고
    case MY쇼핑
    case 최근본상품

    var title: String? {
        switch self {
        case .MY쇼핑: return "MY쇼핑"
        case .최근본상품: return "최근 본 상품"
        default: return nil
        }
    }

}

/// 포인트_쿠폰_주문배송조회 섹션에 사용할 item 종류
enum MyCollectionViewPointCouponOrderDeliveryItemKind: Int, CaseIterable {
    case 포인트
    case 쿠폰
    case 주문_배송조회

    var title: String {
        switch self {
        case .포인트: return "포인트"
        case .쿠폰: return "쿠폰"
        case .주문_배송조회: return "주문/배송조회"
        }
    }

    var image: UIImage? {
        switch self {
        case .포인트: return UIImage(
            systemName: "wonsign.circle"
        )
        case .쿠폰: return UIImage(
            systemName: "giftcard"
        )
        case .주문_배송조회: return UIImage(
            systemName: "bicycle"
        )
        }
    }
}

/// MY쇼핑 섹션에 사용할 item 종류
enum MyCollectionViewMyShoppingItemKind: Int, CaseIterable {
    case 장바구니
    case 친구초대
    case QnA
    case MY리뷰
    case 고객센터
    case FAQ
    case 페이관리
    case 공지사항

    var title: String {
        switch self {
        case .장바구니: return "장바구니"
        case .친구초대: return "친구초대"
        case .QnA: return "Q&A"
        case .MY리뷰: return "MY리뷰"
        case .고객센터: return "고객센터"
        case .FAQ: return "FAQ"
        case .페이관리: return "페이관리"
        case .공지사항: return "공지사항"
        }
    }

    var image: UIImage? {
        switch self {
        case .장바구니: return UIImage(
            systemName: "cart"
        )
        case .친구초대: return UIImage(
            systemName: "person.2"
        )
        case .QnA: return UIImage(
            systemName: "bubble.left.and.bubble.right"
        )
        case .MY리뷰: return UIImage(
            systemName: "heart"
        )
        case .고객센터: return UIImage(
            systemName: "headphones"
        )
        case .FAQ: return UIImage(
            systemName: "questionmark.circle"
        )
        case .페이관리: return UIImage(
            systemName: "creditcard"
        )
        case .공지사항: return UIImage(
            systemName: "megaphone"
        )
        }
    }
}
