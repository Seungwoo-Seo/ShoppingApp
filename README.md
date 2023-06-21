# ShoppingApp
"하이버"라는 남성 전문 쇼핑앱을 참고하여 만든 앱입니다.
## ⏰  개발기간
3월 19일 ~ 6월 1일
## 💻 개발인원
1인
## ⚙️  개발환경
- IDE : Xcode 14.2
- Language : Swift 5.x
- iOS Deployment Target : 15.6
- Framework : UIKit
- Database : Firebase Realtime Database, Firebase FireStore
- UI : Code
- Design Pattern : MVP
- 의존성 관리 도구 : SPM, CocoaPods
- 외부 라이브러리 : SnapKit, Kingfisher, Alamofire, Tabman, TTGTagCollectionView, Toast
## 📌  주요화면 및 주요기능
### 홈 - https://youtube.com/shorts/jkuCFmnSQxk?feature=share

![홈_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/f5b2ebb6-f3a3-495e-9ab1-85e25ea822e6) 
- 다양한 레이아웃을 가진 여러 섹션이 존재 
- 배너 자동으로 스크롤, 무한히 회전함
- 사용자가 마음대로 스크롤 한 후에도 다시 자동으로 스크롤
- 상단 탭바를 통해서 다른 레이아웃을 가진 화면 추가 구현 가능
- 검색 아이콘 클릭시 검색 화면으로 이동
- 더보기 버튼 혹은 카테고리 섹션 클릭 시 더보기 화면으로 이동
- 상품 자체를 클릭하면 해당 상품을 판매하는 네이버 쇼핑 웹사이트로 이동
- 찜 버튼은 로그인 유무에 따라 선택 가능
- 상품 선택 시 최근 본 상품을 UserDefaults에 저장
