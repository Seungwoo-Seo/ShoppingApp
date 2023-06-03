//
//  FirebaseRealtimeDatabaseManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/25.
//

import FirebaseDatabase
import Foundation

protocol FirebaseRealtimeDatabaseManagerProtocol {
    func incrementSearchCount(for keyword: String)
    func getSearches(
        completionHandler: @escaping ([String]) -> ()
    )

    func getLikeds(
        uid: String,
        completion: @escaping ([Goods]) -> ()
    )
    func updateLikeds(uid: String, goods: Goods)
    func removeLikeds(uid: String, goods: Goods)
}

final class FirebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol {
    static let shared = FirebaseRealtimeDatabaseManager()

    private let ref = Database.database().reference()

    private init() {}

    func incrementSearchCount(for keyword: String) {
        let keywordRef = ref.child("searches").child(keyword)

        // Increment the search count for the keyword by 1
        keywordRef.runTransactionBlock { (currentData: MutableData) -> TransactionResult in
            if var count = currentData.value as? Int {
                count += 1
                currentData.value = count
                return TransactionResult.success(
                    withValue: currentData
                )
            } else {
                currentData.value = 1
                return TransactionResult.success(
                    withValue: currentData
                )
            }
        }
    }

    func getSearches(
        completionHandler: @escaping ([String]) -> ()
    ) {
        let searchesRef = ref.child("searches")

        searchesRef
            .queryOrderedByValue()
            .queryLimited(toLast: 10)
            .observeSingleEvent(of: .value) { (snapshot) in
                var searches: [String] = []

                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        let keyword = snapshot.key
                        searches.insert(keyword, at: 0)
                    }
                }

                completionHandler(searches)
            }
    }

    func getLikeds(
        uid: String,
        completion: @escaping ([Goods]) -> ()
    ) {
        let likedsRef = ref.child("likeds").child(uid)

        // uid가 같은 찜을 가져와야겠지?
        likedsRef
            .observeSingleEvent(of: .value) { (snapshot)  in
                var goodsList: [Goods] = []

                for child in snapshot.children {
                    if let dataSnapshot = child as? DataSnapshot,
                       let value = dataSnapshot.value as? [String: String] {
                        let goods = Goods(
                            title: value["title"]!,
                            link: value["link"]!,
                            image: value["image"]!,
                            lprice: value["lprice"]!,
                            hprice: value["hprice"]!,
                            mallName: value["mallName"]!
                        )

                        goodsList.insert(goods, at: 0)
                    }
                }

                completion(goodsList)
            }

    }

    func updateLikeds(uid: String, goods: Goods) {
        let likedsRef = ref.child("likeds").child(uid)

        guard let key = likedsRef.childByAutoId().key
        else { return }

        let post: [String: Any] = [
            "title": goods.title,
            "link": goods.link,
            "image": goods.imageURL!.absoluteString,
            "lprice": goods.lprice,
            "hprice": goods.hprice,
            "mallName": goods.mallName
        ]

        let childUpdates = [
            "\(key)": post
        ]
        likedsRef.updateChildValues(childUpdates)
    }

    func removeLikeds(uid: String, goods: Goods) {
        let likedsRef = ref.child("likeds").child(uid)

        // 삭제 대상 노드를 찾는 쿼리 작성
        let query = likedsRef
            .queryOrdered(
                byChild: "image"
            )
            .queryEqual(
                toValue: goods.imageURL!.absoluteString
            )

        // 데이터를 가져온 후 삭제 작업을 수행
        query.observeSingleEvent(of: .value) { snapshot in
            // 해당 위치의 데이터가 존재하는 경우 삭제
            if snapshot.exists() {
                guard let value = snapshot.value as? [String: [String: String]],
                      let key = value.keys.first
                else {return}

                snapshot.ref.child(key).removeValue()
            }
        }
    }

}
