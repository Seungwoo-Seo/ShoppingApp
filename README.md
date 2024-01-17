# NETPING

<p>
  네이버 쇼핑 API를 기반으로 만든 쇼핑 앱입니다.
</p>
  
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

## 목차

- [🚀 주요 기능](#-주요-기능)
- [🛠 구현 기술](#-구현-기술)
- [💻 기술 스택](#-기술-스택)
- [📱 서비스](#-서비스)
- [🚧 기술적 도전](#-기술적-도전)
- [🚨 트러블 슈팅](#-트러블-슈팅)
- [📝 회고](#-회고)
- [🖼 아이콘 출처 및 저작권 정보](#-아이콘-출처-및-저작권-정보)

## 🚀 주요 기능

- 상품 목록 및 상세 정보 조회
- 카테고리 및 스타일 추천
- 찜 목록 및 최근 본 상품
- 회원인증 및 소셜로그인
- Auto Scroll

## 🛠 구현 기술

- `offset` 기반의 `페이지네이션` 구현
- `UserDefaults`를 활용해 `최근 검색어 CRUD` 구현
- `FirebaseRealtimeDatabase`를 활용해 `인기 검색어` 구현
- `FirebaseRealtimeDatabase`를 활용해 `찜 CRUD`와 `최근 본 상품 CRUD` 구현
- `DiffableDataSource`를 활용해 `Expandable Cell` 구현

## 💻 기술 스택

- `Swift`
- `MVP`, `Singleton`
- `UIKit`, `WebKit`
- `Codable`, `CodeBase UI`, `AutoLayout`, `CompositionalLayout`, `DiffableDataSource`
- `Alamofire`, `SnapKit`, `Kingfisher`, `Tabman`, `TTGTagCollectionView`, `Toast`
- `Firebase`

## 📱 서비스

- 최소 버전 : iOS 15.0
- 개발 인원 : 1인
- 개발 기간 : 2023년 3월 ~ 2023년 6월 (3개월)

## 🚧 기술적 도전

<!-- 프로젝트를 진행하면서 겪은 기술적인 도전과 어떻게 해결했는지에 대한 설명을 추가한다. -->
### 1. Compositional Layout
- **도전 상황**</br>
다양한 레이아웃을 가진 복잡한 화면을 구성하고 싶었습니다. TableView + CollectionView의 조합으로 구성하는데 코드도 굉장히 복잡해지고 핸들링하는데 어려움을 느꼈습니다. 그래서 `Compositional Layout`을 도입해봤습니다.

- **도전 결과**</br>
단일 collectionView만으로 다양하고 복잡한 레이아웃을 상당히 직관적으로 계층을 그릴 수 있었습니다. 각각의 레이아웃 요소들을 모듈화 할 수 있었기에 레이아웃이 복잡해지더라도 가독성이 향상되어 유지보수가 쉬워졌습니다.
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

### 2. Diffable DataSource를 활용해 Expandable Cell 구현

- **도전 상황**</br>
`Expandable Cell`을 구현하고 싶었습니다.

- **도전 결과**</br>
<img src="https://github.com/Seungwoo-Seo/ShoppingApp/assets/72753868/1d8a747d-a42e-44fd-92c0-8378673b7619" width="130"></br>
`DiffableDataSource`와 `Notification`을 활용하여 구현에 성공했습니다. 구현 내용은 아래와 같습니다.

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
### 1. 이미지 뷰에 cornerRadius와 shadow 동시 설정 불가 이슈
- **문제 상황**</br>
이미지뷰에 cornerRadius와 shadow를 동시에 설정하고 싶었습니다. 하지만 clipsToBounds를 true로 설정하는 순간 cornerRadius는 적용되어도 shadow는 적용이 되지 않았습니다.

- **해결 방법**</br>
먼저 원인은 clipsToBounds를 true로 설정하면 레이어 외부의 모든 항목을 잘라냈기 때문입니다. 레이어 외부에 그림자가 그려지므로 그림자도 잘리게 됩니다. 따라서 이 두 가지 효과를 동시에 사용할 수 없었습니다.
그래서 적용한 방법은 shadow를 적용한 뷰 위에 clipsToBounds를 적용한 ImageView를 추가하는 형태로 해결할 수 있었습니다.

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

### 2. Auto Scroll 구현 이슈
- **문제 상황** </br>
`Auto Scroll`을 제대로 구현하기 위해 1. 화면을 잡고 있을 때 auto Scroll을 멈춘다. 2. 화면을 놓으면 auto Scroll이 시작한다. 3. Infinite Carousel Effect가 적용되어 어떤 방향으로든 무한히 스크롤 가능하다. 4. 스크롤을 해서 Auto Scroll Section이 보이지 않거나 다른 화면으로 전환했을 때 Auto Scroll이 멈춰야 한다. 최소한 4가지 이상의 조건이 필요하다고 생각했습니다. 하지만 직접 구현하는데 상당히 어려움을 느꼈습니다.

- **해결 방법** </br>
`Pageboy` 라이브러리를 활용하여 허무할 정도로 간단하게 해결되었습니다..
~~~swift
final class InfinityCarouselViewController: PageboyViewController {

    func configurePageboyViewController() {
        isInfiniteScrollEnabled = true // 무한 스크롤 구현
    }

    func configureAutoScroller() {
        // 멈췄을 때 다시 시작할지 여부
        autoScroller.restartsOnScrollEnd = true
    }

    func autoScroll(_ duration: TimeInterval) {
        // autoScroll 간격
        autoScroller.enable(
            withIntermissionDuration: .custom(duration: duration)
        )
    }

}
~~~

## 📝 회고
<!-- 프로젝트를 마무리하면서 느낀 소회, 개선점, 다음에 시도해보고 싶은 것 등을 정리한다. -->
👍 **성취한 점**
1. `Compositional Layout`를 적용하여 복잡하고 다양한 뷰를 직관적으로 구성할 수 있었습니다. 레이아웃 요소들을 모듈화하여 가독성 및 유지보수성을 향상시킬 수 있었습니다.
2. `Diffable DataSource`를 적용하여 indexPath를 신경쓰지 않고 식별자를 통해 추가, 삭제, 이동 등의 변경사항에 대한 애니메이션을 처리할 수 있었습니다.
3. `MVP 패턴`을 도입하여 view와 presenter 간에 코드 분리를 경험했고 presenter와 protocol을 이용해서 `Unit Test`를 편리하게 할 수 있었습니다.
4. `BDD` 기반의 `Unit Test`를 경험해 보았습니다.

## 🖼 아이콘 출처 및 저작권 정보

이 프로젝트에서 사용된 아이콘들은 아래와 같은 출처에서 제공되었습니다. 각 아이콘의 저작권은 해당 제작자에게 있습니다. 아이콘을 사용하려면 각 아이콘의 출처로 이동하여 저작권 관련 정보를 확인하세요.

출처 <a href="https://kr.freepik.com/free-vector/hand-drawn-shopping-horizontal-sale-banner_41538524.htm#query=horizontal%20banner&position=30&from_view=search&track=ais">Freepik</a>
</br>
출처 <a href="https://kr.freepik.com/free-vector/flat-design-horizontal-sale-banner_40125112.htm#query=horizontal%20banner&position=49&from_view=search&track=ais">Freepik</a>
