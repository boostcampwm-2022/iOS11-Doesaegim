# 당신의 여행을, 되새김 ✈️

<img src="https://user-images.githubusercontent.com/76734067/207257347-98c2c9e4-013f-4132-8029-99bbaa743d73.png">

> 되새김은 여행을 계획하고, 여행을 떠나서 일정과 지출을 관리하고 다이러리도 작성해 실용성과 추억관리 두마리 토끼를 모두 잡은 애플리케이션 입니다.

![Swift](https://img.shields.io/badge/swift-v5.7-orange?logo=swift) 
![Xcode](https://img.shields.io/badge/xcode-v14.0-blue?logo=xcode)
![SnapKit](https://img.shields.io/badge/SnapKit-v14.0-green)

## 배포 링크

> 되새김을 다운로드할 수 있는 링크입니다.

<a href="https://apps.apple.com/kr/app/%EB%90%98%EC%83%88%EA%B9%80/id6444737875">
  <img width="100" src="https://user-images.githubusercontent.com/76734067/207779701-cd44d8b6-d3eb-473d-86f6-50fc0f439374.png">
</a>

## 팀 소개

|S003 김민석|S006 김선경|S022 서보경|S023 소재훈|
|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/77199797?v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/81314063?v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/50136980?v=4" width=100>|<img src="https://avatars.githubusercontent.com/u/76734067?v=4" width=100>|
|[@mandos1995](https://github.com/mandos1995)|[@skkimeo](https://github.com/skkimeo)|[@Be-beee](https://github.com/Be-beee)|[@January1st-98](https://github.com/January1st-98)|

## 주요 기능

### ✈️ 여행관리
- 내가 다녀온 여행을 한 눈에! 일정 탭에서 다녀온 여행목록을 조회할 수 있습니다. ✈️
- 여행을 계획 중이라면? 👀 여행을 계획하고 일정을 추가할 수 있습니다.
- 일정 관리도 손쉽게! 여행별로 일정을 관리할 수 있습니다.😎

### 💰 지출관리
- 헉, 나 지금까지 얼마 썼더라? 🤑 일자별, 카테고리별 비용을 그래프로 한 눈에 확인하세요!
- 환율 계산? 귀찮은데…🫤 현지에서 사용한 통화를 입력하면 원화로 변환해 보여줍니다!

### 🗺 다이어리를 지도로!
- 제주도에서 내가 뭘 했었지? 위치정보를 바탕으로 작성한 다이어리를 지도 위에 보여줍니다!📍

### 📝 다이어리
- 글과 사진으로 여행에서의 기억하고 싶은 순간을 기록해보세요.
- 다이어리의 사진을 인스타그램으로 공유할 수 있습니다.
- 개인정보 지켜~✋ 배경에 나온 타인의 얼굴을 쉽게 블러 처리해 공유할 수 있습니다.

### ⚙️ 설정
- 날짜 및 시간 형식을 변경할 수 있어요.
- 궁금한 내용이 있으신가요❓ 메일을 보내 문의하실 수 있어요.
- 개인 정보 처리 방침, 오픈소스 및 라이브러리를 확인할 수 있어요.

## 동작화면

|<img src="https://user-images.githubusercontent.com/76734067/207781971-47476431-72ef-4129-b9af-e3272b98fb3e.png">|<img src="https://user-images.githubusercontent.com/76734067/207781978-678f5dd3-d284-4954-81f2-ade9d3ac3f97.png">|<img src="https://user-images.githubusercontent.com/76734067/207781979-eff40a32-937d-449a-8950-af2416a9450b.png">|<img src="https://user-images.githubusercontent.com/76734067/207781983-91bcaf7d-8bef-4778-b20c-3f73260a8acd.png">|
|:-:|:-:|:-:|:-:|
|`여행목록`|`일정관리`|`지출관리`|`지도-다이어리 보기`|
|<img src="https://user-images.githubusercontent.com/76734067/207781984-cf015692-8754-40d5-b097-1ad2260fee75.png">|<img src="https://user-images.githubusercontent.com/76734067/207781987-f29f289c-652e-48bb-93cd-dda38d6117f8.png">|<img src="https://user-images.githubusercontent.com/76734067/207781989-1b64e17f-4c44-4f08-84e4-a8bd990c7cf4.png">|<img src="https://user-images.githubusercontent.com/76734067/207781991-3fa9e5aa-75f2-42f4-9100-808d48b8f3fa.png">|
|`다이어리`|`다이어리 확인`|`얼굴선택`|`모자이크 - 인스타 공유`|

## 프로젝트 구조

> 되새김에서 사용하고있는 프로젝트 구조입니다.

<img src="https://user-images.githubusercontent.com/76734067/207780104-3a489812-6340-46bd-8087-56a2bd7cb229.png">

- 애플리케이션의 구조가 크기 않아 코디네이터 패턴이나 클린아키텍쳐의 필요성을 느끼지 못했습니다.
- `MVVM`만으로도 저희 애플리케이션을 충분히 유지보수할 수 있다고 생각하여 `MVVM` 디자인 패턴을 선택하였습니다.

## 기술 스택

### 💿 CoreData
- 서드파티를 지양하고 애플의 라이브러리를 활용해 안정성을 높이기 위해 `CoreData`를 활용했습니다.
- 안드로이드 출시 계획이 없고, 앱 기능 상 서버가 필요없다고 생각해 `CoreData`를 선택했습니다.

### 🧭 MapKit & CoreLocation
- 사용자가 작성한 다이어리를 지도상에서 보여주는 기능에 활용하였습니다.

### 🙈 Vision
- 사진상의 얼굴을 인식하고 위치를 파악해 모자이크 처리하는데 활용하였습니다.

### 📊 Core Graphics
- 지출 내역을 지출 카테고리 또는 날짜별로 확인할 수 있는 차트를 직접 구현해 활용했습니다.
- `CoreAnimation`을 활용해 차트 애니메이션을 직접 구현했습니다.

## 기술적 도전
- [커스텀 캘린더로 날짜 선택](https://github.com/boostcampwm-2022/iOS11-Doesaegim/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EC%BB%A4%EC%8A%A4%ED%85%80-%EC%BA%98%EB%A6%B0%EB%8D%94%EB%A1%9C-%EB%82%A0%EC%A7%9C-%EC%84%A0%ED%83%9D)
- [환율에 캐시 적용..?](https://github.com/boostcampwm-2022/iOS11-Doesaegim/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%ED%99%98%EC%9C%A8%EC%97%90-%EC%BA%90%EC%8B%9C-%EC%A0%81%EC%9A%A9)
- [우리 집 차트는 애니메이션 나온다?!](https://github.com/boostcampwm-2022/iOS11-Doesaegim/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EC%9A%B0%EB%A6%AC-%EC%A7%91-%EC%B0%A8%ED%8A%B8%EB%8A%94-%EC%95%A0%EB%8B%88%EB%A9%94%EC%9D%B4%EC%85%98-%EB%82%98%EC%98%A8%EB%8B%A4)
- [일정이 무한 증식한다면? 도와줘 CoreData~](https://github.com/boostcampwm-2022/iOS11-Doesaegim/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EC%9D%BC%EC%A0%95%EC%9D%B4-%EB%AC%B4%ED%95%9C-%EC%A6%9D%EC%8B%9D%ED%95%9C%EB%8B%A4%EB%A9%B4-%EB%8F%84%EC%99%80%EC%A4%98-coredata)
- [블러 처리? CoreImage한테 맡겨 달라고](https://github.com/boostcampwm-2022/iOS11-Doesaegim/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EB%B8%94%EB%9F%AC-%EC%B2%98%EB%A6%AC-coreimage%ED%95%9C%ED%85%8C-%EB%A7%A1%EA%B2%A8-%EB%8B%AC%EB%9D%BC%EA%B3%A0)
- [얼굴인식, Vision이냐 CIDetector냐](https://github.com/boostcampwm-2022/iOS11-Doesaegim/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EC%96%BC%EA%B5%B4%EC%9D%B8%EC%8B%9D-vision%EC%9D%B4%EB%83%90-cidetector%EB%83%90)
- [🍎 기타 기술공유](https://github.com/boostcampwm-2022/iOS11-Doesaegim/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EA%B8%B0%ED%83%80-%EA%B8%B0%EC%88%A0-%EA%B3%B5%EC%9C%A0)
