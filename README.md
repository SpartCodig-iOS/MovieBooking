# MovieBooking

SwiftUI와 TCA(The Composable Architecture)를 기반으로 만든 영화 예매 iOS 애플리케이션입니다. TMDB(The Movie Database)의 공개 API를 활용해 상영 중·개봉 예정·인기 영화 정보를 제공하며, Supabase 인증을 통해 이메일 및 애플·구글·카카오 소셜 로그인을 지원합니다. 예매 정보는 로컬(UserDefaults)에 저장되고, 자체 디자인 시스템으로 일관된 UI/UX를 유지합니다.

## 프로젝트 개요
- 단일 앱에서 영화 발견 → 상세 조회 → 좌석 선택 및 예매 → 예매 내역 관리까지 완결된 사용자 여정을 제공합니다.
- 소셜 로그인과 로컬 계정을 모두 지원해 다양한 이용자 접근성을 확보했습니다.
- SwiftUI + TCA 조합으로 명확한 상태 관리와 모듈화된 UI 구성을 지향하며, Feature 단위의 독립적인 개발·테스트가 가능합니다.

## 프로젝트 특징
- **스플래시 & 세션 관리**: 앱 시작 시 Splash 화면에서 Supabase 세션과 토큰 만료 시간을 검사해 로그인 여부에 따라 인증 플로우 또는 메인 탭으로 전환합니다.
- **다중 로그인 옵션**: 이메일, 애플, 구글, 카카오 로그인을 제공하며 PKCE 기반 Supabase OAuth와 Nonce 관리로 보안을 강화했습니다.
- **영화 탐색**: TMDB API를 호출해 Now Playing, Coming Soon, Popular 섹션을 동시에 불러오고, 실패 시 재시도 알림을 제공합니다. 요청은 `withThrowingTaskGroup`으로 병렬 처리합니다.
- **검색 최적화**: 로컬에 캐시된 영화 리스트를 활용해 디바운스 검색으로 빠른 응답을 제공하고, 빈 검색어 입력 시 즉시 결과를 초기화합니다.
- **예매 시나리오**: 영화 상세 → 극장/시간 선택 → 인원 수 입력 → 예매 완료 알림까지 플로우를 제공합니다. 예매 성공 시 선택 내역과 금액을 안내하는 Alert를 띄웁니다.
- **티켓 관리**: UserDefaults 기반 저장소를 통해 예매 내역을 조회·삭제하고, 예매 삭제 성공 시 로컬 상태를 즉시 갱신합니다.
- **마이 페이지**: 마지막 로그인 이력과 로그인 공급자를 노출하고 Supabase 로그아웃을 수행합니다. 로그아웃 시 팝업 확인 뒤 세션을 종료합니다.

## 사용자 여정
1. **앱 실행**: Splash 애니메이션이 진행되며 Supabase 세션을 확인합니다.
2. **세션 판별**: 기존 세션이 유효하면 토큰을 갱신하거나 메인 탭으로 이동하고, 없으면 AuthCoordinator가 표시됩니다.
3. **로그인/회원가입**: 이메일 또는 소셜 로그인으로 인증을 진행합니다. 회원가입 성공 시 사용자 정보가 `UserEntity`로 공유됩니다.
4. **홈 탭**: 영화 섹션을 스크롤로 탐색하고, 영화 선택 시 상세 화면으로 이동합니다.
5. **상세 & 예매**: 추가 정보를 확인한 뒤 예매 버튼을 통해 극장/시간/인원 선택 화면으로 이동합니다.
6. **예매 완료**: 예매 정보를 저장하고 완료 알림을 확인합니다. 예매 내역은 BookingList에서 확인합니다.
7. **마이 페이지**: 계정 정보, 로그인 타입을 확인하고 필요 시 로그아웃합니다.

## 주요 화면 구성
- **SplashFeature**: 세션 점검, 페이드 아웃 애니메이션, 로그인 여부 판단.
- **AuthCoordinator**: 로그인/회원가입 플로우 관리, 소셜 인증 후 메인 탭 전환.
- **MainTabFeature**: 홈, 검색, 예매 내역, 마이 페이지 탭을 관리하고 TCA 스코프를 분배합니다.
- **MovieListFeature**: 영화 목록 섹션과 오류 처리, 영화 선택 액션을 담당합니다.
- **MovieDetailFeature**: 영화 상세 정보, 장르, 줄거리, 별점 표시 및 예매 화면 라우팅을 담당합니다.
- **MovieBookFeature**: 극장/상영 시간 불러오기, 인원 수 조절, 총액 계산, 예매 완료 Alert를 제공합니다.
- **BookingListFeature**: 저장된 예매 목록을 표시하고 삭제 요청을 처리합니다.
- **MyPageFeature**: 사용자 프로필, 로그인 제공자, 로그아웃 확인 팝업을 제공합니다.

## 기술 구성
- **UI 레이어**: SwiftUI, TCA(Perception 지원)로 화면 구성 및 상태 관리.
- **의존성 주입 및 상태 공유**: TCA `Dependencies`, WeaveDI, `@Shared` 스토리지 조합.
- **백엔드 & 인증**: Supabase Client, PKCE 기반 OAuth, 커스텀 URL 스킴 `movieBooking://login-callback/`.
- **네트워크 계층**: URLSession, 커스텀 `TargetType`/`NetworkProvider`, LoggerEventMonitor.
- **데이터 계층**: Actor 기반 Repository, DTO ↔ Domain 매퍼, UserDefaults 기반 Local DataSource.
- **디자인 시스템**: Pretendard 가변 폰트, 컬러 토큰, 카드·버튼 등 공통 UI 컴포넌트.
- **테스트**: swift-testing(`@Test`) 기반 네트워크, 데이터 매퍼, 세션 로직 단위 테스트.

## 아키텍처 개요
TCA Feature → Domain UseCase → Data Repository → DataSource 구조로 레이어를 분리했습니다. 각 Feature는 Reducer 단위로 작성되며, UseCase와 Repository는 `Dependencies` 및 WeaveDI를 통해 주입됩니다.

```
MovieBooking/
├─ App/             # 앱 진입점, AppReducer, DI 부트스트랩
├─ Feature/         # 기능별 TCA Reducer & View (Auth, MovieList 등)
├─ Domain/          # Entity, UseCase, Repository 프로토콜
├─ Data/            # Repository 구현, DataSource, DTO/Request 정의
├─ NetworkService/  # HTTP Core, Provider, Error, 로깅
├─ DesignSystem/    # 색상·폰트·공통 컴포넌트
├─ Resources/       # Info.plist, Assets, FontAsset
├─ Utill/           # Utility, Validation, Navigation 확장
├─ MovieBookingTests/ / MovieBookingUITests/
└─ Config/          # Dev/Release xcconfig (Supabase Key, URL)
```

### 데이터 흐름
1. Feature Reducer가 액션을 받아 도메인 UseCase를 호출합니다.
2. UseCase는 의존성 주입으로 전달받은 Repository에 작업을 위임합니다.
3. Repository는 DataSource를 통해 네트워크 또는 로컬(UserDefaults)에서 데이터를 읽고 씁니다.
4. DataSource에서 받은 DTO를 Domain Entity로 변환해 Feature 상태에 반영합니다.
5. 필요 시 Repository는 결과를 캐시해 검색이나 상세 조회 속도를 높입니다.

## 인증 & 세션 처리
- Splash 단계에서 Supabase 세션 유무를 먼저 확인하고, 만료 임박 시 `refreshSession`을 호출합니다.
- 소셜 로그인은 Supabase OAuth Provider(애플·구글·카카오)를 사용하며, Kakao 인증을 위해 Info.plist에 URL 스킴을 등록했습니다.
- 로그인 성공 시 `UserEntity`를 `@Shared(.inMemory)`로 저장해 탭 간 상태를 공유합니다.

## 네트워크 계층
- 모든 API 요청은 `NetworkProvider`를 통해 이루어지며, `TargetType` 프로토콜로 HTTP Method, Path, Parameters를 정의합니다.
- LoggerEventMonitor가 요청/응답 로깅을 담당하고, `NetworkError`로 에러 유형을 명확하게 분류합니다.
- TMDB 영화 데이터는 `APIConfiguration`에서 baseURL과 API Key를 관리하며, JSON Key는 `convertFromSnakeCase` 전략으로 디코딩합니다.

## 디자인 시스템
- Pretendard Variable 폰트를 번들에 포함해 Weight/Size 조합을 세밀하게 조정합니다.
- `DesignSystem/Color` 모듈에서 색상 토큰을 정의하고, 재사용 가능한 카드·버튼 컴포넌트를 제공합니다.
- `@Shared` Storage로 저장된 테마나 사용자 정보에 따라 UI 요소를 업데이트할 수 있도록 설계했습니다.

## 테스트 전략
- `MovieBookingTests/NetworkTests`는 실제 REST Endpoint를 대상으로 HTTP Method, Parameter Encoding, 에러 핸들링을 검증합니다.
- `MovieBookingTests/DataSourceTests`는 TMDB 응답을 Mocking하여 DTO ↔ Domain 변환을 확인합니다.
- `MovieBookingTests/SessionTest`는 Supabase 세션 Mapper와 만료 처리 로직을 테스트합니다.
- Feature Reducer는 TCA의 `TestStore`를 사용해 상태 전이 검증을 확장할 수 있도록 설계되어 있습니다.

## 빌드 및 실행 방법
1. 저장소를 클론합니다.
   ```bash
   git clone <repo-url>
   cd MovieBooking
   ```
2. `MovieBooking.xcodeproj`를 Xcode 16 이상에서 엽니다. (swift-testing 사용을 위해 16 버전 이상 권장)
3. 스킴 `MovieBooking`을 선택하고 iOS 16.6 이상 시뮬레이터에서 실행합니다.
## 개발 시 참고 사항
- Supabase 세션은 `SplashFeature`에서 초기 확인 후 토큰 만료 여부에 따라 `refreshSession`을 호출합니다.
- 영화 목록은 `withThrowingTaskGroup`으로 병렬 호출하여 로딩 시간을 줄였으며, 실패 시 `AlertState`로 재시도 버튼을 제공합니다.
- 예매 흐름은 로컬 `BookingRepository`(UserDefaults 기반)로 구현되어 실제 결제 없이 플로우만 시뮬레이션합니다.
- `@Shared` 프로퍼티 래퍼를 통해 로그인 정보(`UserEntity`)를 Feature 간에 공유합니다.
- DesignSystem 모듈은 색상·폰트 토큰과 공용 카드/버튼 컴포넌트를 포함합니다.

