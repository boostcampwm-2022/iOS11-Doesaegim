# 당신의 여행을, 되새김 ✈️

<img src="https://user-images.githubusercontent.com/76734067/207257347-98c2c9e4-013f-4132-8029-99bbaa743d73.png">

> 되새김은 여행을 계획하고, 여행을 떠나서 일정과 지출을 관리하고 다이러리도 작성해 실용성과 추억관리 두마리 토끼를 모두 잡은 애플리케이션 입니다.

![Swift](https://img.shields.io/badge/swift-v5.7-orange?logo=swift) 
![Xcode](https://img.shields.io/badge/xcode-v14.0-blue?logo=xcode)
![SnapKit](https://img.shields.io/badge/SnapKit-v14.0-green)

## 배포 링크

> 되새김을 다운로드할 수 있는 링크입니다.

<img width="100" src="https://user-images.githubusercontent.com/76734067/207779701-cd44d8b6-d3eb-473d-86f6-50fc0f439374.png">

[되새김 링크](https://apps.apple.com/kr/app/%EB%90%98%EC%83%88%EA%B9%80/id6444737875)

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



## 프로젝트 구조

> 되새김에서 사용하고있는 프로젝트 구조입니다.

<img src="https://user-images.githubusercontent.com/76734067/207780104-3a489812-6340-46bd-8087-56a2bd7cb229.png">

- 애플리케이션의 구조가 크기 않아 코디네이터 패턴이나 클린아키텍쳐의 필요성을 느끼지 못했습니다.
- `MVVM`만으로도 저희 애플리케이션을 충분히 유지보수할 수 있다고 생각하여 MVVM 디자인 패턴을 선택하였습니다.