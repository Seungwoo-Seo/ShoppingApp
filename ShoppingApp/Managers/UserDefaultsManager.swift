//
//  UserDefaultsManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/31.
//

import Foundation

protocol UserDefaultsManagerProtocl {
    func getClothes() -> [Goods]
    func addClothes(_ newClothes: Goods?)
    func removeClothes(_ clothes: Goods)
    func saveClothes(_ newClothes: [Goods])
}

struct UserDefaultsManager: UserDefaultsManagerProtocl {
    enum UserDefaultsKey: String {
        case clothes
    }

    func getClothes() -> [Goods] {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.clothes.rawValue) else {
            return []
        }

        return (try? PropertyListDecoder().decode([Goods].self, from: data)) ?? []
    }

    func addClothes(_ newClothes: Goods?) {
        guard let newClothes = newClothes else {return}

        var currentClothesList: [Goods] = getClothes()
        currentClothesList.insert(newClothes, at: 0)

        saveClothes(currentClothesList)
    }

    func removeClothes(_ clothes: Goods) {
        let currentClothesList: [Goods] = getClothes()
        let newClothes = currentClothesList.filter { $0.title != clothes.title }

        saveClothes(newClothes)
    }

    internal func saveClothes(_ newClothes: [Goods]) {
        UserDefaults.standard.setValue(
            try? PropertyListEncoder().encode(newClothes),
            forKey: UserDefaultsKey.clothes.rawValue
        )
    }

}
