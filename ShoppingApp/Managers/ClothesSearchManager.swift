//
//  ClothesSearchManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/19.
//

import Alamofire
import Foundation

// Test를 편하게 하기 위해서 Protocol을 선언
protocol ClothesSearchManagerProtocol {
    func request(with query: String, completionHandler: @escaping ([Clothes]) -> ())
}

struct ClothesSearchManager: ClothesSearchManagerProtocol {

    func request(with query: String, completionHandler: @escaping ([Clothes]) -> ()) {
        guard let url = URL(string: "https://openapi.naver.com/v1/search/shop.json") else {return}
        let parameters = ShoppingRequestModel(query: query)
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "BLrJtVO8Z_5bLS7FfMyy",
            "X-Naver-Client-Secret": "5VXAJgE7V9"
        ]

        AF.request(
            url,
            method: .get,
            parameters: parameters,
            headers: headers
        )
        .responseDecodable(of: ShoppingResponseModel.self) { response in
            switch response.result {
            case .success(let result):
                completionHandler(result.items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .resume()
    }

}
