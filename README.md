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
ShoppingApp 사용 영상
- https://youtu.be/wwq6doWtnNE
-------

### First Floor Scenes - tabBarItem에 해당하는 화면들. 즉, 최상단 화면들

#### 홈 화면 - https://youtube.com/shorts/jkuCFmnSQxk?feature=share

![홈_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/f5b2ebb6-f3a3-495e-9ab1-85e25ea822e6) 
- 배너 섹션은 자동으로 스크롤되며 무한히 회전함
- 사용자가 배너 섹션을 스크롤할 땐 자동 스크롤이 멈추지만 사용자가 스크롤 하지 않으면 다시 자동 스크롤
- 상단 탭바를 통해 더 다양한 화면을 구성할 수 있음
- 찜 버튼은 로그인 후 사용가능
- 더보기 버튼과 카테고리 섹션은 선택 시 더보기 화면으로 이동
- 상품 선택 시 네이버 쇼핑 웹사이트로 이동
- 검색 버튼 선택 시 검색 화면으로 이동

#### 스타일추천 화면 - https://youtube.com/shorts/AAxjKTUXLKA?feature=share

![스타일_추천_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/a8cad637-7545-430b-8ee8-54f4a87bb11e)
- 하단으로 스크롤하면 계속해서 새로운 상품을 가져옴
- 최상단에서 당기면 상품 초기화 및 새로고침
- 상품 선택 시 네이버 쇼핑 웹사이트로 이동
- 찜 버튼은 로그인 후 사용가능
- 검색 버튼 선택 시 검색 화면으로 이동

#### 카테고리 화면 - https://youtube.com/shorts/B0Qx54EbJMo?feature=share

![카테고리_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/625de542-a5bc-4d34-87c5-17167524da28)
- 각 섹션 헤더를 선택하면 하위 상품 카테고리를 보여줌
- 섹션 헤더의 악세서리 버튼들은 Radio 버튼처럼 동작함
- 하위 카테고리 선택 시 더보기 화면으로 이동

#### 찜 화면 - https://youtube.com/shorts/s03R-FtJpVI?feature=share

![찜_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/814353ce-3937-453f-b115-fbb914bea5b4)
![찜_화면_로그인](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/f8d1421e-f459-4423-888e-b3ac79885812)
- 로그인 시 사용가능
- 로그인한 상태에서 상품 찜 버튼을 선택 했을 때 찜 화면에 상품들이 추가됌
- 추천 상품 버튼 선택 시 더보기 화면으로 이동
- 검색 버튼 선택 시 검색 화면으로 이동

#### 로그인 화면 - https://youtube.com/shorts/cVNS4OdRNXg?feature=share

![로그인_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/9607ea40-d434-4313-9f9c-75c91deb6de0)
- 로그인 하지 않았을 때 tabBarItem 중 MY 버튼을 선택하면 보여지는 화면
- 이메일, 비밀번호로 로그인 가능
- 애플로 로그인 가능 (디바이스에서 실제로 동작함, 시뮬레이터에선 동작하지 않음)
- 구글로 로그인 가능
- 회원가입 가능

#### MY 화면 - https://youtube.com/shorts/AjgsIFY_Iv8?feature=share

![MY_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/b82c6b98-5694-42cb-83b4-7f6bfc1593de)
- 네비게이션바의 타이틀은 로그인 한 사용자의 이메일
- 최근 본 상품 섹션은 최근 본 상품이 있을 때만 생성되고 없으면 사라짐. 찜 여부도 나타나고 찜 선택해제도 가능
- 최근 본 상품 섹션 헤더의 악세서리 버튼을 선택하면 최근 본 상품 화면으로 이동
- 설정 버튼을 선택하면 설정 화면으로 이동

------

### Second Floor Scenes - First Floor Scenes를 거쳐야지 보여지는 화면들

#### 검색 화면 - https://youtube.com/shorts/0IIMLr5KWbw?feature=share

![검색_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/19dd7486-e1a9-463d-ad9a-fcd8187cfe70)
![검색_결과_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/d30c4c63-2ce6-4cf1-983b-900272c2f50b)
- 최근 검색어 섹션은 최근 검색어가 있으면 생기고 없으면 사라짐. 전체삭제 버튼 선택 시 최근 검색어 섹션 사라짐
- 최근 검색어 섹션은 가장 최신의 검색어들을 최대 10개를 보여줌. 가장 최근에 검색한 검색어가 맨처음
- 인기 검색어 섹션은 firebase Realtime database를 사용해서 실시간 순위를 나타냄
- 검색을 하면 firebase Realtime database에 실시간으로 카운트 증가
- "검색을 했다"의 기준은 키보드에서 리턴버튼, 최근 검색어 섹션, 인기 검색어 섹션의 셀들을 선택해서 더보기 화면으로 넘어갔을 때
- searchBar에 텍스트를 입력할 때마다 검색하고 검색 결과 목록 중 하나를 선택하면 웹 화면으로 이동

#### 웹 화면 - https://youtube.com/shorts/whMbAAKtJfg?feature=share

![웹_처음_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/93254944-0b6a-4944-9945-c5fc6acb4a2a)
![웹_최종_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/f2cd2ac2-7470-4580-b2ab-f007da8ad890)
- WKWebView를 사용함

#### 최근 본 상품 화면 - https://youtube.com/shorts/4S1yNhC85qs?feature=share

![최근_본_상품_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/5c9efa88-b6fb-4b35-9051-6b734d9d838a)
- 카테고리가 아닌 상품 자체를 사용자가 선택하면 UserDefaults에 해당 상품이 저장되고 해당 화면에서 UserDefaults에 있는 상품들을 보여줌
- 삭제 가능
- 찜 여부 가능 (찜 하기, 찜 취소)
- 중복되지 않고 가장 마지막에 선택한 상품이 가장 먼저 보여짐

#### 더보기 화면 - https://youtube.com/shorts/UHOaBkWkhRA?feature=share

![더보기_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/28bf78c6-fbc5-4fa2-bf67-8a7ad701f089)
- 홈 화면에 카테고리 섹션, 카테고리 화면, 검색을 통해서 보여지는 화면
- 하단으로 스크롤하면 계속해서 새로운 상품을 가져옴
- 최상단에서 당기면 상품 초기화 및 새로고침
- 상품 선택 시 네이버 쇼핑 웹사이트로 이동
- 찜 버튼은 로그인 후 사용가능
- 검색 버튼 선택 시 검색 화면으로 이동

#### 설정 화면 - https://youtube.com/shorts/ZcCF77iyC6A?feature=share

![설정_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/0677e2ea-3210-4d7c-8516-2b4188b1fd21)
- 로그아웃 버튼 선택 시 로그아웃

#### 회원가입 화면 - https://youtube.com/shorts/G3GWvFOA0V4?feature=share

![회원가입_이메일비밀번호_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/91e4d6bb-eedc-4735-973c-eb4df74685f3)
![회원가입_이름번호_화면](https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/a48b25f2-9147-4e75-ab3d-1b8da3753612)
- 이메일, 비밀번호를 통한 회원가입
- FirebaseAuth를 사용
- 이메일, 비밀번호, 이름, 휴대폰 번호 모두 정규식을 통과해야 사용가능
- 이메일은 중복확인까지 해야함 (FireStore query를 이용해서 중복체크)
- 정규식에 통과하지 못하면 이유를 보여줌
- 키보드가 올라가고 내려갈때 하단의 버튼도 같이 움직임

------
### Firebase

#### FirebaseAuth
##### 이메일, 구글, 애플 가입
<img width="500" alt="유저" src="https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/7da346b8-478f-4529-81e5-c4b5bf098fbb">

#### FirebaseFirestore
##### 사용자
<img width="500" alt="유저디비" src="https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/5e30ef10-3c3d-43cd-bd32-950c13e06828">

#### FirebaseRealtimeDatabase
##### 찜
<img width="500" alt="찜" src="https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/e7ec7ec9-f36e-49f6-b6b1-c81050bb4b14">

##### 인기검색어
<img width="500" alt="검색디비" src="https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/1b4a11f2-bc41-470b-98ff-fc170ee67008">

------

###### 배너 이미지 출처
출처 <a href="https://kr.freepik.com/free-vector/hand-drawn-shopping-horizontal-sale-banner_41538524.htm#query=horizontal%20banner&position=30&from_view=search&track=ais">Freepik</a>

출처 <a href="https://kr.freepik.com/free-vector/flat-design-horizontal-sale-banner_40125112.htm#query=horizontal%20banner&position=49&from_view=search&track=ais">Freepik</a>
