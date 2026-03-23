import 'package:flutter/material.dart';
import 'package:gaply/gaply.dart';

class GaplyDemoPage extends StatefulWidget {
  const GaplyDemoPage({super.key});

  @override
  State<GaplyDemoPage> createState() => _GaplyDemoPageState();
}

class _GaplyDemoPageState extends State<GaplyDemoPage> {
  // 상태 관리를 위한 변수들
  bool _isLoading = false;
  Color _cardColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // Shimmer 효과를 위한 컬러 프리셋 등록 예시 (간단화)
    GaplyShimmerPreset.register(
      'default',
      const ShimmerParams(
        baseColor: ColorParams(role: ColorRole.surfaceVariant, opacity: ColorOpacity.o10),
        highlightColor: ColorParams.fromColor(Colors.white, opacity: ColorOpacity.o30),
      ),
    );

    // AnimationSequence 프리셋 등록 예시 (간단화)
    GaplyAnimationSequencePreset.register(
      'successConfirm',
      AnimationSequenceParams(
        effects: [
          const ScaleParams(
            begin: 1.0,
            end: 1.1,
            duration: Duration(milliseconds: 150),
            curve: Curves.easeOutBack,
            isScaled: true,
          ),
          const ShakeParams(distance: 6.0, count: 2.0, isVertical: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 테마 컬러 가져오기
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Gaply Modifier 체이닝 데모")),
      body: GaplyBox(
        params: BoxParams.preset('rainbow'),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const GaplyBox(
                    child: _CardContent(
                      title: "Glassmorphism Card",
                      desc: "블러 프리셋('apple')과 미세 테두리 조합으로 만든 고급 유리 효과 카드입니다.",
                    ),
                  )
                  .boxSize(340, 200)
                  .padding(const EdgeInsets.all(24))
                  .boxRadius(BorderRadius.circular(20))
                  .borderWidth(1)
                  .borderColor(Colors.black)
                  .colorR(ColorRole.surface, opacity: ColorOpacity.transparent)
                  .blurPreset('apple')
                  .elevation(10)
                  .colorR(ColorRole.surface, opacity: ColorOpacity.transparent),

              const SizedBox(height: 32),

              GaplyBox(
                    child: const _CardContent(
                      title: "Dynamic Feedback Card",
                      desc: "확인 버튼을 누르면 성공 애니메이션과 배경색 변경이 일어납니다.",
                    ),
                  )
                  .boxSize(340, 200)
                  .padding(const EdgeInsets.all(24))
                  .boxRadius(BorderRadius.circular(20))
                  .color(_cardColor)
                  .shadows([
                    ShadowParams(
                      blurRadius: 16.0,
                      spreadRadius: 2.0,
                      color: const ColorParams(role: ColorRole.shadow, opacity: ColorOpacity.o10),
                    ),
                  ])
                  .animation(
                    _cardColor != Colors.transparent
                        ? AnimationSequenceParams.preset('successConfirm')
                        : AnimationSequenceParams.preset('none'),
                  ),

              const SizedBox(height: 16),

              // 🛠️ 컨트롤 버튼들 (상태 변경용)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () => _onConfirmClicked(), child: const Text("확인 버튼 시연")),
                ],
              ),

              const SizedBox(height: 32),

              // 🎬 3. 스켈레톤 카드 (로딩 중일 때 시머 적용)
              _isLoading
                  ? const GaplyBox(
                          child: _CardContent(title: "Skeleton Card", desc: ''),
                        ) // 로딩 중: 빈 박스
                        .boxSize(340, 200)
                        .padding(const EdgeInsets.all(24))
                        .boxRadius(BorderRadius.circular(20))
                        .colorR(ColorRole.primaryContainer)
                        .shimmer(
                          const ShimmerParams(
                            baseColor: ColorParams(role: ColorRole.surfaceVariant, opacity: ColorOpacity.o30),
                            highlightColor: ColorParams.fromColor(Colors.white, opacity: ColorOpacity.o80),
                          ),
                        )
                  : const GaplyBox(
                          // 로딩 완료: 콘텐츠
                          child: _CardContent(
                            title: "Skeleton Card",
                            desc: "2초 로딩 후 콘텐츠가 나타납니다. 로딩 중에는 시머 효과가 적용됩니다.",
                          ),
                        )
                        .boxSize(340, 200)
                        .padding(const EdgeInsets.all(24))
                        .boxRadius(BorderRadius.circular(20))
                        .colorR(ColorRole.primaryContainer) // 로딩 완료 시 배경색
                        .elevation(160),

              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => _onLoadClicked(), child: const Text("시머 효과 시연 (2초)")),
            ],
          ),
        ),
      ),
    );
  }

  // 성공 피드백 연출 로직
  void _onConfirmClicked() {
    // 1. 카드 배경색을 성공 색상으로 변경
    setState(() {
      _cardColor = Colors.green.withValues(alpha: .2); // 초록빛
    });

    // 🎬 2. 위젯 리빌드를 통해 'success' 애니메이션 실행
    // GaplyBox(...).animation(...,) 부분이 'success' 프리셋으로 바뀌면서 애니메이션이 실행됩니다.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("성공 피드백! (팝업 & 끄덕끄덕)")));

    // 3. 연출 후 상태 원복 (0.6초 후)
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _cardColor = Colors.transparent;
      });
    });
  }

  // 로딩 시뮬레이션 로직
  void _onLoadClicked() {
    setState(() => _isLoading = true);
    // 2초 후 로딩 완료 상태로 변경
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
    });
  }
}

// 데모 카드 내부 콘텐츠 위젯 (공용)
class _CardContent extends StatelessWidget {
  final String title;
  final String desc;

  const _CardContent({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Text(desc, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
      ],
    );
  }
}
