//
//  MyModel.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/31.
//

import UIKit

struct MyModel {

    func cellCount(of section: Int) -> Int {
        switch section {
        case 0:
            return MyCollectionViewFirstSectionButtonData.allCases.count
        case 1:
            return 1
        case 2:
            return MyCollectionViewThirdSectionButtonData.allCases.count
        default:
            return 0
        }
    }

    func cellData(of section: Int, item: Int) -> Any? {
        switch section {
        case 0:
            return MyCollectionViewFirstSectionButtonData.allCases[item]
        case 2:
            return MyCollectionViewThirdSectionButtonData.allCases[item]
        default:
            return nil
        }
    }

    enum MyCollectionViewFirstSectionButtonData: CaseIterable {
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

        var icon: UIImage? {
            switch self {
            case .포인트: return UIImage(systemName: "heart")
            case .쿠폰: return UIImage(systemName: "heart")
            case .주문_배송조회: return UIImage(systemName: "heart")
            }
        }
    }

    enum MyCollectionViewThirdSectionButtonData: CaseIterable {
        case 장바구니
        case 친구초대
        case QnA
        case MY리뷰
        case 고객센터
        case FAQ
        case 빠른페이관리

        var title: String {
            switch self {
            case .장바구니: return "장바구니"
            case .친구초대: return "친구초대"
            case .QnA: return "Q&A"
            case .MY리뷰: return "MY리뷰"
            case .고객센터: return "고객센터"
            case .FAQ: return "FAQ"
            case .빠른페이관리: return "빠른페이 관리"
            }
        }

        var icon: UIImage? {
            switch self {
            case .장바구니: return UIImage(systemName: "heart")
            case .친구초대: return UIImage(systemName: "heart")
            case .QnA: return UIImage(systemName: "heart")
            case .MY리뷰: return UIImage(systemName: "heart")
            case .고객센터: return UIImage(systemName: "heart")
            case .FAQ: return UIImage(systemName: "heart")
            case .빠른페이관리: return UIImage(systemName: "heart")
            }
        }
    }

}
