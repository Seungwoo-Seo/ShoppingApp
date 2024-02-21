# NETPING

> 네이버 쇼핑 API를 기반으로 만든 쇼핑 앱입니다.
  
<p align="center">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/db4aefe5-30f4-4446-a98e-42c38261a164" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/98f10dba-cb3c-4c91-8754-e60e85691e63" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/f76f6dbd-843c-444c-b299-7f3e7cc9dc1e" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/4d2000e7-1973-4ef2-991c-8a848e92abe1" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/4a120d90-ca6f-46ff-840b-7a4aeecba901" width="130">
  <img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/fb21d33c-9ba7-4b4f-b447-3d8d311e81aa" width="130">
</p>

|홈|검색|찜|최근 본 상품|소셜 로그인|
|:---:|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/f6dd7d9d-04d6-4cb1-966e-75f83a5f10a2" width="150">|<img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/c1a2cd45-297b-4a33-b5c7-2a5c500bede0" width="150">|<img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/63584591-40da-4c71-bc91-aba6abccf07e" width="150">|<img src="https://github.com/Seungwoo-Seo/ExemplaryRestaurantIB/assets/72753868/17f8f139-ebc0-419b-accf-1bc09975b2f5" width="150">|<img src="https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/7e553976-f1b5-49ee-b005-f4921e6dcb3d" width="150">|

## 📱 서비스

- 최소 버전 : iOS 15.0
- 개발 인원 : 1인
- 개발 기간 : 2023.05.12 ~ 2023.06.21 (6주)

## 🚀 서비스 기능

- 이메일 회원인증과 구글, 애플 소셜로그인 기능 제공
- 네이버 쇼핑 API 기반 주제/스타일 추천/카테고리 상품 정보 제공
- 검색/최근 검색어/찜/최근 본 상품 기능 제공

## 🛠 사용 기술

- Swift
- Foundation, UIKit, WebKit, CryptoKit, Authentication Services
- MVP, Singleton, Delegate Pattern
- Alamofire, SnapKit, Kingfisher, Tabman, TTGTagCollectionView, Toast
- CodeBase UI, AutoLayout, CompositionalLayout, DiffableDataSource, UserDefaults, Codable, 
- Firebase RealtimeDatabase, Firebase FireStore, Firebase Auth, Unit Test

## 💻 핵심 설명

- Firebase Auth, Firebase FireStore를 활용해 OAuth 2.0 기반 `이메일 회원인증/소셜 로그인(구글, 애플)` 구현
- 애플 로그인 구현 시, Firebase 무결성 검사를 위해 CryptoKit 기반 `nonce 생성 로직` 추가
- Alamofire를 사용한 `REST API 통신` 구현
- offset 기반 `페이지 네이션`을 통해 상품 정보 표현
- UserDefaults를 활용해 `최근 검색어 CRUD` 구현, Firebase RealtimeDatabase를 활용해 `찜/최근 본 상품 CRUD` 구현
- CompositionalLayout을 활용해 `그리드, 리스트` 레이아웃 구현
- DiffableDataSource + Notification을 통한 `Expandable Section` 구현
- BDD 기반의 `Unit Test` 구현

## 🚧 기술적 도전

<!-- 프로젝트를 진행하면서 겪은 기술적인 도전과 어떻게 해결했는지에 대한 설명을 추가한다. -->
### 1. CompositionalLayout
- **도전 상황**</br>
복잡한 화면을 구현할 때, UITableView + UICollectionView 구조로 구현하면 코드도 복잡해지고 핸들링하는데 많은 리소스가 들어가기 때문에 `CompositionalLayout`을 도입

- **도전 결과**</br>
단일 collectionView만으로 복잡한 레이아웃을 직관적으로 구현. 각각의 레이아웃 요소들을 모듈화 할 수 있었기에 레이아웃이 복잡해지더라도 가독성 및 유지보수 용이성 향상
~~~swift
/// HomeViewController에 collectionView의  layout
enum HomeCollectionViewLayout {
    case `default`

    /// layout 생성
    var createLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in

            let section = HomeCollectionViewSectionKind(
                rawValue: sectionIndex
            )

            switch section {
            case .메인배너:
                return self.createMainBannerSection()
            case .카테고리:
                return self.createCategorySection()
            case .오늘의랭킹:
                return self.createRankSection()
            case .오늘구매해야할제품:
                return self.createTwoColumGridSection()
            case .이주의브랜드이슈:
                return self.createBrandOfTheWeekSection()
            case .지금눈에띄는후드티:
                return self.createTwoColumGridSection()
            case .서브배너:
                return self.createSubBannerSection()
            case .일초만에사로잡는나의취향:
                return self.createTwoColumGridSection()
            case .none:
                fatalError(
                    "레이아웃을 설정할 수 없는 섹션입니다."
                )
            }
        }

        return layout
    }
}
~~~
~~~swift
// Section
private extension HomeCollectionViewLayout {

    /// 메인배너 섹션 layout.
    /// 하나의 열에 여러 컬럼을 가진 형태
    func createMainBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.65)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

    ...
}
~~~

### 2. DiffableDataSource를 활용해 Expandable Cell 구현

- **도전 상황**</br>
`Expandable Cell`을 구현하기

- **도전 결과**</br>
<img src="https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/1d8a747d-a42e-44fd-92c0-8378673b7619" width="130"></br>
`DiffableDataSource`와 `Notification`을 활용하여 구현

~~~swift
func didTapOutLineButton(_ sender: UIButton) {
    // 버튼의 tag값으로 현재 섹션을 찾고
    guard let section = dataSource.sectionIdentifier(for: sender.tag) else {return}

    // 전체 스냡삿이 아닌 섹션 스냅샷 생성
    var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<CategoryItem>()

    // 버튼이 선택되어 있다면
    if sender.isSelected {
        // 1. 기존 스냅샷을 지운다.
        sectionSnapshot.deleteAll()

        var snapshot = NSDiffableDataSourceSnapshot<CategoryCollectionViewSectionKind, CategoryItem>()
        snapshot.appendSections(CategoryCollectionViewSectionKind.allCases)

        // 2. item을 제외하고 section들만 추가해서 스냅샷을 적용한다.
        dataSource.apply(sectionSnapshot, to: section, animatingDifferences: false)
    }

    // 버튼이 선택되어 있지 않다면
    else {
        // 1. 기존에 선택되어 있는 섹션의 스냅샷을 지운다.
        NotificationCenter.default.post(
            name: Notification.Name.likeRadioButton,
            object: sender.tag,
            userInfo: nil
        )

        // 2. section들을 추가하고
        var snapshot = NSDiffableDataSourceSnapshot<CategoryCollectionViewSectionKind, CategoryItem>()
        snapshot.appendSections(CategoryCollectionViewSectionKind.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)

        let items = section.categorys

        // 3. 해당 섹션에 아이템을 추가한다.
        sectionSnapshot.append(items)

        // 4. 스냅샷 적용
        dataSource.apply(sectionSnapshot, to: section, animatingDifferences: true)
    }

    sender.toggle()
}
~~~

## 🚨 트러블 슈팅

<!-- 프로젝트 중 발생한 문제와 그 해결 방법에 대한 내용을 기록한다. -->
### 1. ImageView에 cornerRadius와 shadow 동시 설정 불가 이슈
- **문제 원인**</br>
shadow는 뷰의 layer 외부에 그려지는데 clipsToBounds를 true로 설정하여 layer 외부의 모든 항목 제거한 상황이 원인

- **해결 방법**</br>
shadow만 적용한 빈 뷰를 두고 바로 위에 clipsToBounds를 true를 설정한 ImageView를 덮어씌우는 형태로 해결

~~~swift
private lazy var thumnailImageViewShadowView: UIView = {
    let view = UIView()
    shadowOffset = CGSize(width: 1, height: 1)
    shadowOpacity = 0.5
    shadowColor = UIColor.gray.cgColor
    return view
}()

private lazy var thumnailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    imageView.layer.cornerRadius = 16.0
    imageView.clipsToBounds = true

    return imageView
}()
~~~
~~~swift
thumnailImageViewShadowView.addSubview(thumnailImageView)

thumnailImageViewShadowView.snp.makeConstraints { make in
    make.top.equalToSuperview()
    make.leading.equalToSuperview()
    make.trailing.equalToSuperview()
}

thumnailImageView.snp.makeConstraints { make in
    make.edges.equalToSuperview()
}
~~~

## 📝 회고
- `CompositionalLayout`를 적용하여 레이아웃 요소들의 모듈화, 가독성 및 유지보수성 향상을 경험
- `DiffableDataSource`를 적용하여 indexPath를 신경쓰지 않고 식별자를 통해 추가, 삭제, 이동 등의 변경사항에 대한 애니메이션을 처리를 경험
- `MVP 패턴`을 도입하여 view와 presenter 간에 코드 분리, presenter와 protocol을 이용해서 편리한 `Unit Test`를 경험
- `BDD` 기반의 `Unit Test`를 경험
