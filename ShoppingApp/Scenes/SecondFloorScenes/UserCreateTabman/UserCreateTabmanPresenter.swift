//
//  UserCreateTabmanPresenter.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/05/10.
//

import Pageboy
import Tabman
// 여기만 특수 케이스
// presenter에 UIKit이 있으면 안되지만
// 여기선 viewController가 데이터이기 때문에 예외
import UIKit

protocol UserCreateTabmanViewProtocol: AnyObject {
    func configureView()
    func configureNavigationBar()
    func configurePageboyView()
    func configureLineBar()
    func addNotification()
    func removeNotification()
    func scrollToPage()
    func popViewController()
    func confirmAlertToPresent(
        title: String?,
        message: String?
    )
}

final class UserCreateTabmanPresenter: NSObject {
    private weak var viewController: UserCreateTabmanViewProtocol!

    private let firebaseAuthManager: FirebaseAuthManagerProtocol
    private let firebaseFireStoreManager: FirebaseFireStoreManagerProtocol

    // datas
    /// 표시할 viewControllers
    private let viewControllers: [UIViewController] = [
        UserCreateEmailPasswordViewController(),
        UserCreateInfoViewController()
    ]
    /// 최종 이메일
    private var finalEmail: String?
    /// 최종 비밀번호
    private var finalPassword: String?
    /// 최종 이름
    private var finalName: String?
    /// 최종 휴대폰 번호
    private var finalPhoneNumber: String?

    init(
        viewController: UserCreateTabmanViewProtocol!,
        firebaseAuthManager: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared,
        firebaseFireStoreManager: FirebaseFireStoreManagerProtocol = FirebaseFireStoreManager.shared
    ) {
        self.viewController = viewController
        self.firebaseAuthManager = firebaseAuthManager
        self.firebaseFireStoreManager = firebaseFireStoreManager
    }

    func viewDidLoad() {
        viewController.configureView()
        viewController.configureNavigationBar()
        viewController.configurePageboyView()
        viewController.configureLineBar()
        viewController.addNotification()
    }

    func viewWillDisappear() {
        viewController.removeNotification()
    }

}

extension UserCreateTabmanPresenter: PageboyViewControllerDataSource {

    func numberOfViewControllers(
        in pageboyViewController: PageboyViewController
    ) -> Int {
        return viewControllers.count
    }

    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(
        for pageboyViewController: PageboyViewController
    ) -> PageboyViewController.Page? {
        return nil
    }

}

extension UserCreateTabmanPresenter: TMBarDataSource {

    func barItem(
        for bar: TMBar,
        at index: Int
    ) -> TMBarItemable {
        return TMBarItem(title: "")
    }

}

// private
extension UserCreateTabmanPresenter {

    func emailPasswordSucces(
        _ notification: NSNotification
    ) {
        guard let userInfo = notification.userInfo as? [String: String],
              let email = userInfo["email"],
              let password = userInfo["password"]
        else {return}

        finalEmail = email
        finalPassword = password

        viewController.scrollToPage()
    }

    func namePhoneNumberSucces(
        _ notification: NSNotification
    ) {
        guard let userInfo = notification.userInfo as? [String: String],
              let name = userInfo["name"],
              let phoneNumber = userInfo["phoneNumber"]
        else {return}

        finalName = name
        finalPhoneNumber = phoneNumber

        // 유저 가입 및 생성 시작
        startUserCreateFlow()
    }

}

private extension UserCreateTabmanPresenter {

    // 유저 가입 및 생성 메소드
    func startUserCreateFlow() {
        guard let finalEmail = finalEmail,
              let finalPassword = finalPassword,
              let finalName = finalName,
              let finalPhoneNumber = finalPhoneNumber
        else {return}

        // 마침내 회원가입
        firebaseAuthManager.createUser(
            email: finalEmail,
            password: finalPassword
        ) { [weak self] (uid) in
            // 이메일로 회원가입 성공 했을 때
            if let uid = uid {
                // fireStore에 userInfo 생성
                self?.firebaseFireStoreManager.createUserInfo(
                    uid: uid,
                    email: finalEmail,
                    name: finalName,
                    phoneNumber: finalPhoneNumber
                ) {
                    // fireStore에 userInfo 생성 성공
                    if $0 {
                        // 로그인을 하기 위해서
                        // LoginViewController로 이동
                        self?.firebaseAuthManager.signOut { error in
                            guard error == nil else {return}

                            self?.viewController.popViewController()
                        }
                    }

                    // fireStore에 userInfo 생성 실패
                    else {
                        // userInfo는 실패했지만
                        // 계정은 만들어진 상태이기 때문에
                        // 계정 삭제
                        self?.firebaseAuthManager.userDelete {
                            // 계정 삭제 성공 실패 여부 상관없음
                            // 실패 시 해당 플로우에선 할 게 없음
                            // 어차피 isEnabled 속성이 false이기
                            // 때문에 추후에 삭제 가능하다고 판단됌
                            self?.viewController.confirmAlertToPresent(
                                title: "현재 가입할 수 없습니다.",
                                message: nil
                            )
                        }
                    }
                }
            }

            // 이메일로 회원가입 실패 했을 때
            else {
                self?.viewController.confirmAlertToPresent(
                    title: "현재 가입할 수 없습니다.",
                    message: nil
                )
            }
        }
    }

}
