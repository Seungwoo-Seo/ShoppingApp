//
//  HomeModel.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import Foundation

struct HomeModel {
    var mainClothes: [Clothes] = []
    var categorys = [
        "남성패션",
        "여성패션",
        "재킷",
        "맨투맨",
        "조거팬츠",
        "데일리룩",
        "스니커즈",
        "헬스",
        "니트",
        "원피스"
    ]
    var clothesList: [Clothes] = []
    var threeRowClothes: [Clothes] = []
    var rankClothes: [Clothes] = []
    var nowLookingClothes: [Clothes] = []
    var subBannerClothes: [Clothes] = []
    var oneSecondMyFavoriteClothes: [Clothes] = []


    let clothesSearchManager = ClothesSearchManager()


    func getHomeData() {
        let requests = [
            "자켓",
            "남성 청바지",
            "셔츠",
            "조끼",
            "후드티",
            "양말",
            "스포츠 의류"
        ]

        requests.forEach {
            clothesSearchManager.request(with: $0) { results in

                // 생각해보니까 지 자리 어떻게 찾아가지?
                // rx쓸 때는 쉬운ㄷ 
            }
        }
    }

}
