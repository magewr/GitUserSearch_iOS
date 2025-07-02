# GitHub 사용자 검색 앱 테스트케이스 문서

## 개요
본 문서는 GitHub 사용자 검색 iOS 앱의 단위 테스트케이스를 BDD(Behavior-Driven Development) 형식으로 정의합니다.
각 레이어별로 성공과 실패 시나리오를 명확하게 구분하여 작성하였습니다.

---

## 1. Domain Layer 테스트케이스

### 1.1 SearchUserUseCase

#### Feature: GitHub API를 통한 사용자 검색
**As a** 사용자  
**I want to** GitHub에서 사용자를 검색할 수 있다  
**So that** 원하는 개발자를 찾을 수 있다  

##### Scenario: 유효한 검색어로 사용자 검색 성공
```gherkin
Given 유효한 검색 파라미터가 주어졌을 때
  And SearchUserInteractor가 정상적으로 동작할 때
When searchUsers 메서드를 호출하면
Then SearchResult가 반환된다
  And 검색된 사용자 목록이 포함되어 있다
```

##### Scenario: 빈 검색어로 사용자 검색 실패
```gherkin
Given 빈 검색어가 주어졌을 때
When searchUsers 메서드를 호출하면
Then 적절한 에러가 발생한다
```

##### Scenario: 네트워크 오류로 인한 검색 실패
```gherkin
Given 유효한 검색 파라미터가 주어졌을 때
  And SearchUserInteractor에서 네트워크 오류가 발생할 때
When searchUsers 메서드를 호출하면
Then NetworkError가 발생한다
```

#### Feature: 즐겨찾기에서 사용자 검색
**As a** 사용자  
**I want to** 즐겨찾기한 사용자들을 검색할 수 있다  
**So that** 저장된 사용자를 빠르게 찾을 수 있다  

##### Scenario: 즐겨찾기 사용자 검색 성공
```gherkin
Given 즐겨찾기에 사용자들이 저장되어 있을 때
  And 유효한 검색어가 주어졌을 때
When searchFavoriteUsers 메서드를 호출하면
Then 검색어와 일치하는 즐겨찾기 사용자 목록이 반환된다
```

##### Scenario: 즐겨찾기가 비어있을 때 검색
```gherkin
Given 즐겨찾기가 비어있을 때
When searchFavoriteUsers 메서드를 호출하면
Then 빈 SearchResult가 반환된다
```

### 1.2 FavoriteUserUseCase

#### Feature: 사용자를 즐겨찾기에 추가
**As a** 사용자  
**I want to** 마음에 드는 개발자를 즐겨찾기에 추가할 수 있다  
**So that** 나중에 쉽게 찾을 수 있다  

##### Scenario: 새로운 사용자 즐겨찾기 추가 성공
```gherkin
Given 즐겨찾기에 없는 사용자가 주어졌을 때
When addFavoriteUser 메서드를 호출하면
Then 사용자가 즐겨찾기에 추가된다
  And 에러가 발생하지 않는다
```

##### Scenario: 이미 즐겨찾기에 있는 사용자 추가 시도
```gherkin
Given 이미 즐겨찾기에 있는 사용자가 주어졌을 때
When addFavoriteUser 메서드를 호출하면
Then 적절한 에러가 발생한다
```

#### Feature: 즐겨찾기에서 사용자 제거
**As a** 사용자  
**I want to** 즐겨찾기에서 사용자를 제거할 수 있다  
**So that** 더 이상 관심없는 개발자를 정리할 수 있다  

##### Scenario: 즐겨찾기 사용자 제거 성공
```gherkin
Given 즐겨찾기에 있는 사용자가 주어졌을 때
When removeFavoriteUser 메서드를 호출하면
Then 사용자가 즐겨찾기에서 제거된다
  And 에러가 발생하지 않는다
```

##### Scenario: 즐겨찾기에 없는 사용자 제거 시도
```gherkin
Given 즐겨찾기에 없는 사용자가 주어졌을 때
When removeFavoriteUser 메서드를 호출하면
Then 적절한 에러가 발생한다
```

#### Feature: 즐겨찾기 토글
**As a** 사용자  
**I want to** 사용자의 즐겨찾기 상태를 토글할 수 있다  
**So that** 간편하게 즐겨찾기를 관리할 수 있다  

##### Scenario: 즐겨찾기에 없는 사용자 토글 (추가)
```gherkin
Given 즐겨찾기에 없는 사용자가 주어졌을 때
When toggleFavoriteUser 메서드를 호출하면
Then 사용자가 즐겨찾기에 추가된다
```

##### Scenario: 즐겨찾기에 있는 사용자 토글 (제거)
```gherkin
Given 즐겨찾기에 있는 사용자가 주어졌을 때
When toggleFavoriteUser 메서드를 호출하면
Then 사용자가 즐겨찾기에서 제거된다
```

---

## 2. Data Layer 테스트케이스

### 2.1 NetworkClient

#### Feature: HTTP 요청 처리
**As a** 시스템  
**I want to** HTTP 요청을 안전하게 처리할 수 있다  
**So that** 안정적인 네트워크 통신이 가능하다  

##### Scenario: 성공적인 HTTP GET 요청
```gherkin
Given 유효한 엔드포인트가 주어졌을 때
  And 서버가 정상적으로 응답할 때
When request 메서드를 호출하면
Then 올바른 응답 데이터가 반환된다
  And 네트워크 에러가 발생하지 않는다
```

##### Scenario: 네트워크 연결 실패
```gherkin
Given 네트워크 연결이 불가능할 때
When request 메서드를 호출하면
Then NetworkError.noConnection이 발생한다
```

##### Scenario: 서버 오류 응답 (4xx, 5xx)
```gherkin
Given 서버가 오류 상태 코드를 반환할 때
When request 메서드를 호출하면
Then NetworkError.serverError가 발생한다
  And 적절한 상태 코드가 포함된다
```

##### Scenario: 잘못된 JSON 응답
```gherkin
Given 서버가 잘못된 JSON을 반환할 때
When request 메서드를 호출하면
Then NetworkError.decodingError가 발생한다
```

### 2.2 GitHubAPIService

#### Feature: GitHub API 사용자 검색
**As a** 시스템  
**I want to** GitHub API를 통해 사용자를 검색할 수 있다  
**So that** 실시간 사용자 정보를 제공할 수 있다  

##### Scenario: 유효한 검색 파라미터로 API 호출 성공
```gherkin
Given 유효한 SearchParameters가 주어졌을 때
  And NetworkClient가 정상적으로 동작할 때
When searchUsers 메서드를 호출하면
Then SearchResult가 반환된다
  And GitHub API가 한 번 호출된다
```

##### Scenario: API 호출 한도 초과
```gherkin
Given GitHub API 호출 한도가 초과된 상태일 때
When searchUsers 메서드를 호출하면
Then NetworkError.rateLimitExceeded가 발생한다
```

##### Scenario: 잘못된 검색 파라미터
```gherkin
Given 잘못된 검색 파라미터가 주어졌을 때
When searchUsers 메서드를 호출하면
Then NetworkError.invalidRequest가 발생한다
```

### 2.3 Repository Layer

#### Feature: 사용자 검색 데이터 관리
**As a** 시스템  
**I want to** 사용자 검색 데이터를 안전하게 관리할 수 있다  
**So that** 일관된 데이터 접근이 가능하다  

##### Scenario: SearchUserRepository 정상 동작
```gherkin
Given GitHubAPIService가 정상적으로 동작할 때
When SearchUserRepository.searchUsers를 호출하면
Then GitHubAPIService.searchUsers가 호출된다
  And 결과가 그대로 반환된다
```

##### Scenario: FavoriteUserRepository 정상 동작
```gherkin
Given FavoriteUserLocalService가 정상적으로 동작할 때
When FavoriteUserRepository의 메서드들을 호출하면
Then FavoriteUserLocalService의 해당 메서드가 호출된다
  And 결과가 그대로 반환된다
```

### 2.4 Local Storage

#### Feature: 로컬 즐겨찾기 데이터 관리
**As a** 시스템  
**I want to** 즐겨찾기 데이터를 로컬에 안전하게 저장할 수 있다  
**So that** 오프라인에서도 즐겨찾기를 확인할 수 있다  

##### Scenario: 즐겨찾기 사용자 추가 성공
```gherkin
Given 유효한 GitUser 객체가 주어졌을 때
  And UserDefaults가 정상적으로 동작할 때
When addFavoriteUser 메서드를 호출하면
Then 사용자가 로컬 저장소에 추가된다
  And 에러가 발생하지 않는다
```

##### Scenario: 즐겨찾기 사용자 조회 성공
```gherkin
Given 로컬 저장소에 즐겨찾기 사용자들이 있을 때
When getFavoriteUsers 메서드를 호출하면
Then 저장된 모든 즐겨찾기 사용자 목록이 반환된다
```

##### Scenario: 로컬 저장소 접근 실패
```gherkin
Given 로컬 저장소에 접근할 수 없을 때
When 저장소 관련 메서드를 호출하면
Then LocalStorageError가 발생한다
```

---

## 3. Presentation Layer 테스트케이스

### 3.1 SearchUsersViewModel

#### Feature: 사용자 검색 상태 관리
**As a** 사용자  
**I want to** 검색 상태가 명확하게 표시되기를 원한다  
**So that** 현재 상황을 쉽게 파악할 수 있다  

##### Scenario: 초기 상태 확인
```gherkin
Given SearchUsersViewModel이 초기화되었을 때
Then searchText는 빈 문자열이다
  And users는 빈 배열이다
  And isLoading은 false이다
  And errorMessage는 nil이다
  And currentSearchMode는 .api이다
```

##### Scenario: 유효한 검색어로 검색 성공
```gherkin
Given 유효한 검색어가 입력되었을 때
  And SearchUserUseCase가 성공적으로 응답할 때
When searchUsers 메서드를 호출하면
Then isLoading이 true에서 false로 변경된다
  And users에 검색 결과가 설정된다
  And errorMessage가 nil이 된다
```

##### Scenario: 빈 검색어로 검색 시도
```gherkin
Given 빈 검색어가 입력되었을 때
When searchUsers 메서드를 호출하면
Then users가 빈 배열로 설정된다
  And isLoading이 false를 유지한다
  And API가 호출되지 않는다
```

##### Scenario: 검색 중 에러 발생
```gherkin
Given 유효한 검색어가 입력되었을 때
  And SearchUserUseCase에서 에러가 발생할 때
When searchUsers 메서드를 호출하면
Then isLoading이 false가 된다
  And errorMessage에 에러 메시지가 설정된다
  And users가 빈 배열로 설정된다
```

#### Feature: 무한 스크롤 페이지네이션
**As a** 사용자  
**I want to** 스크롤을 통해 더 많은 검색 결과를 볼 수 있다  
**So that** 한 번에 모든 데이터를 로딩하지 않아도 된다  

##### Scenario: 추가 페이지 로딩 성공
```gherkin
Given 검색 결과가 이미 있을 때
  And 더 많은 페이지가 있을 때
  And 현재 로딩 중이 아닐 때
When loadMoreUsers 메서드를 호출하면
Then 기존 users 배열에 새로운 결과가 추가된다
  And currentPage가 증가한다
```

##### Scenario: 마지막 페이지에서 추가 로딩 시도
```gherkin
Given 마지막 페이지까지 로딩되었을 때
When loadMoreUsers 메서드를 호출하면
Then API가 호출되지 않는다
  And users 배열이 변경되지 않는다
```

##### Scenario: 페이지 로딩 중 에러 발생
```gherkin
Given 추가 페이지 로딩 중 에러가 발생할 때
When loadMoreUsers 메서드를 호출하면
Then currentPage가 이전 값으로 롤백된다
  And errorMessage에 에러가 설정된다
```

#### Feature: 즐겨찾기 관리
**As a** 사용자  
**I want to** 사용자의 즐겨찾기 상태를 토글할 수 있다  
**So that** 관심있는 개발자를 관리할 수 있다  

##### Scenario: 즐겨찾기 토글 성공
```gherkin
Given 특정 사용자가 주어졌을 때
  And FavoriteUserUseCase가 정상적으로 동작할 때
When toggleFavorite 메서드를 호출하면
Then FavoriteUserUseCase.toggleFavoriteUser가 호출된다
  And favoriteUsers가 업데이트된다
```

##### Scenario: 즐겨찾기 토글 실패
```gherkin
Given 특정 사용자가 주어졌을 때
  And FavoriteUserUseCase에서 에러가 발생할 때
When toggleFavorite 메서드를 호출하면
Then errorMessage에 에러가 설정된다
```

#### Feature: 검색 모드 전환
**As a** 사용자  
**I want to** API 검색과 즐겨찾기 검색 사이를 전환할 수 있다  
**So that** 다양한 방식으로 사용자를 찾을 수 있다  

##### Scenario: 검색 모드 전환 성공
```gherkin
Given 현재 검색 모드가 .api일 때
When switchSearchMode(.favorites)를 호출하면
Then currentSearchMode가 .favorites로 변경된다
  And 새로운 모드로 검색이 실행된다
```

---

## 4. Integration Test Cases

### 4.1 End-to-End 검색 플로우

#### Scenario: 완전한 사용자 검색 플로우
```gherkin
Given 앱이 시작되었을 때
When 사용자가 검색어를 입력하고 검색을 실행하면
Then GitHub API가 호출된다
  And 검색 결과가 화면에 표시된다
  And 로딩 상태가 올바르게 관리된다
```

#### Scenario: 네트워크 오류 처리 플로우
```gherkin
Given 네트워크 연결이 없는 상태일 때
When 사용자가 검색을 실행하면
Then 적절한 에러 메시지가 표시된다
  And 사용자가 재시도할 수 있는 옵션이 제공된다
```

---

## 5. Test Data & Mock Objects

### 5.1 Test Data
- **유효한 GitUser 객체들**
- **다양한 SearchParameters 조합**
- **에러 케이스별 Mock 응답**

### 5.2 Mock Objects
- **MockNetworkClient**: 네트워크 요청 시뮬레이션
- **MockGitHubAPIService**: GitHub API 응답 시뮬레이션
- **MockLocalStorage**: 로컬 저장소 동작 시뮬레이션
- **MockUseCases**: UseCase 동작 시뮬레이션

---

## 6. Test Coverage Goals

- **Unit Tests**: 90% 이상 코드 커버리지
- **Integration Tests**: 주요 플로우 100% 커버리지
- **UI Tests**: 핵심 사용자 시나리오 100% 커버리지

---

## 7. Test Execution Strategy

1. **개발 중**: 단위 테스트 자동 실행
2. **PR 생성**: 모든 테스트 실행 및 커버리지 확인
3. **배포 전**: 통합 테스트 및 UI 테스트 실행
4. **성능 테스트**: 주기적으로 실행하여 성능 저하 방지 