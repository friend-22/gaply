# Gaply 🧩

> "Flutter 작업 중 2% 부족했던 그 틈(Gap)을 채웁니다."

Gaply는 거창한 프레임워크가 아닙니다. 기존 Flutter 개발 과정에서 반복되는 스타일링 고충과
애니메이션 구현의 번거로움을 해결하기 위해 만든 **유틸리티 조력자**입니다.

## 핵심 기능
- **Smooth Styling**: `lerp` 기반의 `Params` 시스템으로 모든 스타일 변화를 부드럽게.
- **Fluent Text**: 믹스인 체이닝으로 `Text` 위젯을 쉽고 빠르게 정의.
- **Kinetic Feedback**: 에러엔 흔들림(`Shake`), 성공엔 전환(`Train`)을 기본으로 제공.
- **I18n Ready**: `Tr` 시스템과 결합된 지능형 텍스트 위젯.

## 시작하기
```dart
// 이 한 줄이 주는 편안함
TrText('welcome').fPrimary.fBold.tSlideUpIn