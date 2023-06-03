//
//  FirebaseAuthManager.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/28.
//

import FirebaseAuth
import GoogleSignIn
import Foundation

protocol FirebaseAuthManagerProtocol: AnyObject {
    /// 인증 상태 수신 대기.
    /// 각각의 앱 뷰에서 앱에 로그인한 사용자에 대한 정보를 얻기 위해 FIRAuth 객체와 리스너를 연결
    /// 이 리스너는 사용자의 로그인 상태가 변경될 때마다 호출됩니다.
    func addStateDidChangeListener(
        completion: @escaping (User?) -> ()
    )

    /// 리스너 분리
    func removeStateDidChangeListener()

    /// 신규 유저 가입 - 이메일, 비밀번호
    func createUser(
        email: String,
        password:String,
        completionHandler: @escaping (String?) -> ()
    )

    /// 이메일 로그인
    func signIn(
        email: String,
        password: String,
        completionHandler: @escaping (Bool) -> ()
    )

    /// 구글 로그인, 애플 로그인
    func signIn(
        with credential: AuthCredential,
        completionHandler: @escaping () -> ()
    )

    func signOut(completion: (String?) -> ())

    /// 이메일 계정 삭제
    func userDelete(
        completionHandler: @escaping () -> ()
    )

    var user: User? {get}
}

// 이거 그냥 싱글톤으로 바꾸는게 나을꺼 같긴한데
final class FirebaseAuthManager: FirebaseAuthManagerProtocol {
    static let shared = FirebaseAuthManager()

    private var handle: AuthStateDidChangeListenerHandle?

    var user: User?

    private init() {}

    func addStateDidChangeListener(
        completion: @escaping (User?) -> ()
    ) {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in

            if let user = user {
                self?.user = user
                completion(user)
            } else {
                self?.user = nil
                completion(nil)
            }
        }
    }

    func removeStateDidChangeListener() {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    func createUser(
        email: String,
        password: String,
        completionHandler: @escaping (String?) -> ()
    ) {
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { authResult, error in
            guard error == nil
            else {
                completionHandler(nil)
                return
            }

            let uid = authResult?.user.uid
            completionHandler(uid)
        }
    }

    func signIn(
        email: String,
        password: String,
        completionHandler: @escaping (Bool) -> ()
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { authResult, error in
            guard error == nil else {
                completionHandler(false)
                return
            }

            completionHandler(true)
        }
    }

    func signIn(
        with credential: AuthCredential,
        completionHandler: @escaping () -> ()
    ) {
        Auth.auth().signIn(
            with: credential
        ) { authResult, error in
            guard error == nil else {return}

//            authResult?.user.uid
//            authResult?.user.email
//            authResult?.user.displayName
//            authResult?.user.phoneNumber


            completionHandler()
        }
    }

    func signOut(completion: (String?) -> ()) {
        do {
            // 로그아웃 성공
            try Auth.auth().signOut()
            completion(nil)
        } catch let signOutError as NSError {
            completion(signOutError.localizedDescription)
        }
    }

    func userDelete(
        completionHandler: @escaping () -> ()
    ) {
        let user = Auth.auth().currentUser

        user?.delete { error in
            guard error == nil
            else {
                completionHandler()
                return
            }

            completionHandler()
        }
    }

}
