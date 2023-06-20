//
//  UserDefaultsManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/31.
//

import Foundation

protocol UserDefaultsManagerProtocl {
    func getGoods() -> [Goods]
    func addGoods(_ newClothes: Goods?)
    func removeGoods(_ clothes: Goods)
    func saveGoods(_ newClothes: [Goods])

    func getRecentSearchList() -> [String]
    func addRecentSearch(_ newSearch: String?)
    func removeRecentSearch(_ oldSearch: String)
    func removeRecentSearchAll()
    func saveRecentSearchList(
        _ newRecentSearchList: [String]
    )
}

struct UserDefaultsManager: UserDefaultsManagerProtocl {
    enum UserDefaultsKey: String {
        // 상품
        case goods
        // 최근 검색어
        case recentSearch
    }

    /// 최근 검색어 리스트를 가져오는 메소드
    func getRecentSearchList() -> [String] {
        guard let data = UserDefaults.standard.data(
            forKey: UserDefaultsKey.recentSearch.rawValue
        ) else {return []}

        return (try? PropertyListDecoder().decode(
            [String].self,
            from: data
        )) ?? []
    }

    /// 최근 검색어를 추가하는 메소드
    func addRecentSearch(_ newSearch: String?) {
        guard let newSearch = newSearch else {return}

        var currentRecentSearchList = getRecentSearchList()
        if let index = currentRecentSearchList.firstIndex(
            of: newSearch
        ) {
            currentRecentSearchList.remove(at: index)
        }
        currentRecentSearchList.insert(newSearch, at: 0)

        saveRecentSearchList(currentRecentSearchList)
    }

    /// 최근 검색어를 삭제하는 메소드
    func removeRecentSearch(_ oldSearch: String) {
        let currentSearchList = getRecentSearchList()
        let newRecentSearchList = currentSearchList.filter {
            $0 != oldSearch
        }

        saveRecentSearchList(newRecentSearchList)
    }

    func removeRecentSearchAll() {
        UserDefaults.standard.removeObject(
            forKey: UserDefaultsKey.recentSearch.rawValue
        )
    }

    /// 최근 검색어 리스트를 저장하는 메소드
    internal func saveRecentSearchList(
        _ newRecentSearchList: [String]
    ) {
        UserDefaults.standard.setValue(
            try? PropertyListEncoder().encode(newRecentSearchList),
            forKey: UserDefaultsKey.recentSearch.rawValue
        )
    }

}

extension UserDefaultsManager {

    func getGoods() -> [Goods] {
        guard let data = UserDefaults.standard.data(
            forKey: UserDefaultsKey.goods.rawValue
        ) else {return []}

        return (try? PropertyListDecoder().decode(
            [Goods].self,
            from: data
        )) ?? []
    }

    func addGoods(_ newGoods: Goods?) {
        guard let newGoods = newGoods else {return}

        var currentGoodsList = getGoods()
        if let index = currentGoodsList.firstIndex(
            of: newGoods
        ) {
            currentGoodsList.remove(at: index)
        }
        currentGoodsList.insert(newGoods, at: 0)

        saveGoods(currentGoodsList)
    }

    func removeGoods(_ goods: Goods) {
        let currentGoodsList: [Goods] = getGoods()
        let newClothes = currentGoodsList.filter { $0.title != goods.title
        }

        saveGoods(newClothes)
    }

    internal func saveGoods(_ newGoods: [Goods]) {
        UserDefaults.standard.setValue(
            try? PropertyListEncoder().encode(newGoods),
            forKey: UserDefaultsKey.goods.rawValue
        )
    }

}
