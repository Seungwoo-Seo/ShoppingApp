//
//  FirebaseAuthManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/28.
//

import FirebaseAuth
import Foundation

protocol FirebaseAuthManagerProtocol {
    func addStateDidChangeListener() -> AuthStateDidChangeListenerHandle
    func removeStateDidChangeListener(handle: AuthStateDidChangeListenerHandle?)
    func createUser(email: String, password: String)
    func login(email: String, password: String)
}

struct FirebaseAuthManager: FirebaseAuthManagerProtocol {

    // 인증 상태 수신 대기
    // 각각의 앱 뷰에서 앱에 로그인한 사용자에 대한 정보를 얻기 위해 FIRAuth 객체와 리스너를 연결
    // 이 리스너는 사용자의 로그인 상태가 변경될 때마다 호출됩니다.
    func addStateDidChangeListener() -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                let uid = user.uid
                let email = user.email

            }
        }
    }

    // 리스너 분리
    func removeStateDidChangeListener(handle: AuthStateDidChangeListenerHandle?) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    // 신규 유저 가입 - 이메일, 비밀번호
    func createUser(email: String, password: String) {
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { authResult, error in
            guard error == nil else {return}

        }
    }

    // 기존 유저 로그인 - 이메일, 비밀번호
    func login(email: String, password: String) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { authResult, error in
            guard error == nil else {return}

        }
    }

}
