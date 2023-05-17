//
//  UserDefaultsManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/31.
//

import Foundation

protocol UserDefaultsManagerProtocl {
    func getClothes() -> [Clothes]
    func addClothes(_ newClothes: Clothes)
    func removeClothes(_ clothes: Clothes)
    func saveClothes(_ newClothes: [Clothes])
}

struct UserDefaultsManager: UserDefaultsManagerProtocl {
    enum UserDefaultsKey: String {
        case clothes
    }

    func getClothes() -> [Clothes] {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.clothes.rawValue) else {
            return []
        }

        return (try? PropertyListDecoder().decode([Clothes].self, from: data)) ?? []
    }

    func addClothes(_ newClothes: Clothes) {
        var currentClothesList: [Clothes] = getClothes()
        currentClothesList.insert(newClothes, at: 0)

        saveClothes(currentClothesList)
    }

    func removeClothes(_ clothes: Clothes) {
        let currentClothesList: [Clothes] = getClothes()
        let newClothes = currentClothesList.filter { $0.title != clothes.title }

        saveClothes(newClothes)
    }

    internal func saveClothes(_ newClothes: [Clothes]) {
        UserDefaults.standard.setValue(
            try? PropertyListEncoder().encode(newClothes),
            forKey: UserDefaultsKey.clothes.rawValue
        )
    }

}
