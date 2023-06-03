//
//  FirebaseFireStoreManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/15.
//

import FirebaseFirestore
import Foundation

protocol FirebaseFireStoreManagerProtocol: AnyObject {
    func emailCheck(
        _ email: String,
        completionHandler: @escaping (Bool) -> ()
    )

    func createUserInfo(
        uid: String,
        email: String,
        name: String,
        phoneNumber: String,
        completionHandler: @escaping (Bool) -> ()
    )

    func updateIsEnabled(
        uid: String,
        isEnabled: Bool,
        completionHandler: @escaping (Bool) -> ()
    )
}

final class FirebaseFireStoreManager: FirebaseFireStoreManagerProtocol {
    static let shared = FirebaseFireStoreManager()

    private let db = Firestore.firestore()

    private init() {}


    // 이메일 중복 검사
    func emailCheck(
        _ email: String,
        completionHandler: @escaping (Bool) -> ()
    ) {
        let usersCollection = db.collection("Users")
        // 입력한 이메일이 있는지 확인 쿼리
        let query = usersCollection.whereField(
            "email",
            isEqualTo: email
        )
        query.getDocuments() { (querySnapshot, error) in
            guard error == nil else {return}

            if querySnapshot?.documents.isEmpty == true {
                // 문서가 비어있어야 사용가능
                completionHandler(true)
            } else {
                // 문서가 비어있지 않아서 사용불가
                completionHandler(false)
            }
        }
    }

    // 이 메서드를 사용하기 전에
    // 확실한 보증을 받아야한다 -> 즉, 이메일 중복을 미리 햇어야함!
    // 이게 성공하면 찜도 realTime에 만들어야지?
    func createUserInfo(
        uid: String,
        email: String,
        name: String,
        phoneNumber: String,
        completionHandler: @escaping (Bool) -> ()
    ) {
        db.collection("Users").document(uid).setData(
            [
                "email": email,
                "name": name,
                "phoneNumber": phoneNumber,
                // user 정보가
                // 완벽하게 만들어진건지 확인하기 위한 속성
                "isEnabled": false
            ]
        ) { [weak self] (error) in
            guard error == nil
            else {
                // fireStore에 userInfo 생성 실패
                completionHandler(false)
                return
            }

            // fireStore에 userInfo 생성 성공하면
            // 활성화
            self?.updateIsEnabled(
                uid: uid,
                isEnabled: true
            ) {
                completionHandler($0)
            }
        }
    }

    // userInfo의 isEnabled 속성을 업데이트 하는 메소드
    func updateIsEnabled(
        uid: String,
        isEnabled: Bool,
        completionHandler: @escaping (Bool) -> ()
    ) {
        let ref = db.collection("Users").document(uid)

        ref.updateData(
            ["isEnabled": isEnabled]
        ) { error in
            guard error == nil
            else {
                completionHandler(false)
                return
            }

            completionHandler(true)
        }
    }

}

