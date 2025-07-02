# GitHub 사용자 검색 iOS 앱

GitHub API를 활용한 모던 iOS 앱입니다. 사용자를 검색하고 즐겨찾기에 추가할 수 있으며, 클린 아키텍처와 최신 iOS 기술을 적용했습니다.

## 🏗️ 아키텍처

### 클린 아키텍처 (Clean Architecture)
프로젝트는 의존성 역전 원칙을 따르는 3계층 클린 아키텍처로 구성되어 있습니다:

```
┌─────────────────┐
│ Presentation    │ ← SwiftUI, ViewModel, @Observable
│                 │
├─────────────────┤
│ Domain          │ ← Use Cases, Entities, Protocols
│                 │
├─────────────────┤
│ Data            │ ← Repository, API, Local Storage
└─────────────────┘
```

#### Presentation Layer
- **기술**: SwiftUI, Observation 프레임워크
- **패턴**: MVVM (Model-View-ViewModel)
- **특징**: `@Observable` 매크로를 사용한 리액티브 UI

#### Domain Layer  
- **구성**: Use Cases, Entities, Repository Protocols
- **역할**: 비즈니스 로직의 핵심, 프레임워크 독립적
- **의존성**: 외부 의존성 없음 (순수 Swift)

#### Data Layer
- **구성**: Repository 구현체, API 서비스, 로컬 저장소
- **역할**: 외부 데이터 소스와의 통신
- **기술**: URLSession, UserDefaults, JSON Codable

### 모듈화 (Tuist)
프로젝트는 Tuist를 사용하여 모듈화되어 있습니다:

- **GitUserSearch**: 메인 앱 타겟
- **PresentationLayer**: UI 및 뷰 모델
- **DomainLayer**: 비즈니스 로직
- **DataLayer**: 데이터 처리
- **GitUserSearchTests**: 통합 테스트

## 🛠️ 기술 스택

### Core Technologies
- **iOS 17.0+** - 최신 iOS 기능 활용
- **Swift 5** - 타입 안전성과 성능
- **SwiftUI** - 선언적 UI 프레임워크
- **Swift Concurrency** - async/await, Task, MainActor

### Architecture & Patterns
- **Clean Architecture** - 계층 분리와 의존성 역전
- **MVVM Pattern** - 뷰와 비즈니스 로직 분리
- **Repository Pattern** - 데이터 접근 추상화
- **Dependency Injection** - 느슨한 결합과 테스트 용이성

### UI & State Management
- **Observation Framework** - `@Observable` 매크로
- **SwiftUI Bindings** - 양방향 데이터 바인딩
- **Navigation** - SwiftUI NavigationView

### Networking & Data
- **URLSession** - HTTP 네트워킹
- **Codable** - JSON 직렬화/역직렬화
- **UserDefaults** - 로컬 데이터 저장

### Development Tools
- **Tuist** - 프로젝트 생성 및 모듈화
- **Xcode 16** - 개발 환경
- **XCTest** - 유닛 테스트 프레임워크

## 🧪 테스트

프로젝트는 포괄적인 테스트 코드를 포함하고 있습니다.

### 테스트 구조
```
Tests/
├── TestHelpers/MockObjects.swift          # 공통 Mock 객체
├── DomainLayerTests/UseCases/             # Use Case 테스트
├── DataLayerTests/                        # Data Layer 테스트
│   ├── Network/                           # 네트워크 관련 테스트
│   ├── Remote/API/                        # API 서비스 테스트
│   ├── Repository/                        # Repository 테스트
│   └── Local/Storage/                     # 로컬 저장소 테스트
└── PresentationLayerTests/                # ViewModel 테스트
```

### 테스트 통계
- **총 48개 테스트 케이스** (모두 통과 ✅)
- **Domain Layer**: 6개 테스트
- **Data Layer**: 30개 테스트  
- **Presentation Layer**: 10개 테스트
- **기타**: 2개 테스트

### 테스트 특징
- **BDD 패턴**: Given-When-Then 구조
- **Mock 기반**: 완전한 의존성 격리
- **@MainActor 지원**: SwiftUI + Concurrency 환경 대응

### 테스트 실행
```bash
# 테스트 실행
xcodebuild test -workspace GitUserSearch.xcworkspace -scheme GitUserSearch -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# 특정 테스트만 실행
xcodebuild test -workspace GitUserSearch.xcworkspace -scheme GitUserSearch -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:GitUserSearchTests/SearchUserUseCaseTests
```

### 테스트 문서
상세한 테스트 케이스는 [TestCases.md](TestCases.md)를 참조하세요.

## 🚀 시작하기

### 필수 조건
- **Xcode 16.0+**
- **iOS 17.0+**
- **macOS 13.0+** (개발 환경)
- **Tuist** (프로젝트 생성 도구)

### Tuist 설치
```bash
# Homebrew를 통한 설치
brew install tuist

# 또는 curl을 통한 설치
curl -Ls https://install.tuist.io | bash
```

### 프로젝트 설정

1. **저장소 클론**
```bash
git clone <repository-url>
cd GitUserSearch_iOS
```

2. **Tuist 프로젝트 생성**
```bash
tuist generate
```

3. **워크스페이스 열기**
```bash
open GitUserSearch.xcworkspace
```

### 빌드 및 실행

#### Xcode에서 실행
1. Xcode에서 `GitUserSearch.xcworkspace` 열기
2. Scheme을 `GitUserSearch`로 선택
3. 시뮬레이터 또는 실제 기기 선택
4. `Cmd + R`로 빌드 및 실행

#### 명령어로 빌드
```bash
# 시뮬레이터용 빌드
xcodebuild -workspace GitUserSearch.xcworkspace -scheme GitUserSearch -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build

# 실제 기기용 빌드 (개발자 계정 필요)
xcodebuild -workspace GitUserSearch.xcworkspace -scheme GitUserSearch -destination 'platform=iOS,name=Your Device Name' build
```

### API 설정
GitHub API는 별도 인증 없이 사용할 수 있지만, API 제한이 있습니다. 더 높은 제한을 원하는 경우:

1. [GitHub Personal Access Token](https://github.com/settings/tokens) 생성
2. `DataLayer/Remote/API/GitHubAPIService.swift`에서 토큰 추가

## 📁 프로젝트 구조

```
GitUserSearch_iOS/
├── Project.swift                          # Tuist 프로젝트 설정
├── Sources/
│   ├── App/                               # 메인 앱
│   │   ├── GitUserSearchApp.swift
│   │   └── Resources/
│   ├── PresentationLayer/                 # UI 레이어
│   │   ├── Scenes/SearchUsers/
│   │   │   ├── SearchUsersView.swift
│   │   │   ├── SearchUsersViewModel.swift
│   │   │   └── ContentView.swift
│   │   └── Common/Components/
│   │       ├── UserRowView.swift
│   │       └── SearchFilterView.swift
│   ├── DomainLayer/                       # 비즈니스 로직
│   │   ├── Entities/
│   │   ├── UseCases/
│   │   └── RepositoryProtocols/
│   └── DataLayer/                         # 데이터 처리
│       ├── Remote/API/
│       ├── Local/Storage/
│       ├── Repository/
│       └── Network/
├── Tests/                                 # 테스트 코드
└── Derived/                               # Tuist 생성 파일
```

## 🎯 핵심 기능 구현

### 검색 디바운스
```swift
// 0.5초 디바운스로 API 호출 최적화
private func scheduleSearch() {
    searchTask?.cancel()
    searchTask = Task {
        try? await Task.sleep(for: .milliseconds(500))
        if !Task.isCancelled {
            await searchUsers()
        }
    }
}
```

### Observation 프레임워크
```swift
@Observable
public class SearchUsersViewModel {
    public var searchText: String = ""
    public var users: [GitUser] = []
    public var isLoading: Bool = false
    // ...
}
```

### Repository 패턴
```swift
protocol SearchUserRepositoryProtocol {
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult
}

final class SearchUserRepository: SearchUserRepositoryProtocol {
    private let apiService: GitHubAPIServiceProtocol
    
    func searchUsers(parameters: SearchParameters) async throws -> SearchResult {
        return try await apiService.searchUsers(parameters: parameters)
    }
}
```

---

**Built with ❤️ using Swift and SwiftUI** 