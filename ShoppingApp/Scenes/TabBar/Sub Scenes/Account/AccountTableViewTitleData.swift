//
//  AccountTableViewTitleData.swift
//  ShoppingApp
//
//  Created by 서승우 on 2023/03/29.
//

import Foundation

enum AccountTableViewTitleData: Int, CaseIterable {
    case 회원정보
    case 알림설정
    case 지원
    case 정보
    case 로그아웃_탈퇴하기

    var headerTitle: String {
        switch self {
        case .회원정보: return "회원정보"
        case .알림설정: return "알림 설정"
        case .지원: return "지원"
        case .정보: return "정보"
        case .로그아웃_탈퇴하기: return ""
        }
    }

    var subTitles: [String] {
        switch self {
        case .회원정보:
            return [
                "회원정보 수정",
                "SNS 계정 연동",
                "비밀번호 변경"
            ]
        case .알림설정:
            return [
                "이벤트/마케팅 알림",
                "앱PUSH",
                "SMS",
                "이메일",
                "야간 혜택 알림 (21-08시)"
            ]
        case .지원:
            return [
                "문의/요청하기",
                "문의/신고하기"
            ]
        case .정보:
            return [
                "개인정보처리방침",
                "이용약관"
            ]
        case .로그아웃_탈퇴하기:
            return [
                "로그아웃"
            ]
        }
    }

}
