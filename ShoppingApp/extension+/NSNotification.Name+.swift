//
//  NSNotification.Name+.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/04/20.
//

import UIKit

extension NSNotification.Name {

    static let likeRadioButton = NSNotification.Name("likeRadioButton")

//    static let stopBannerTimer = NSNotification.Name("stopBannerTimer")
//
//    static let startBannerTimer = NSNotification.Name("startBannerTimer")


    /// InfinityCarouselHorseViewController를
    /// tap 했을 때 해당 goods를 전송하기 위한 노티
    static let goodsOfHorse = NSNotification.Name("goodsOfHorse")


    // 회원가입에서 이메일, 비밀번호를 성공적으로 작성 후
    // nextButton을 눌렀을 때
    static let emailPasswordSucces = NSNotification.Name("emailPasswordSucces")

    // 회원가입에서 이름, 휴대폰 번호를 성공적으로 작성 후
    // userCreateEndButton을 눌렀을 때
    static let namePhoneNumberSucces = NSNotification.Name("namePhoneNumberSucces")

    // UIResponder
    // presenter에서 import UIKit 없이 사용하기 위해서
    static let keyboardFrameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey


    static let moveHomeTabmanViewController = NSNotification.Name("moveHomeTabmanViewController")
}
