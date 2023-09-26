import 'package:flame/components.dart';

import '../ember_quest.dart';


/// HasGameRef 는 게임 클래스에 정의된 변수나 메서드에 접근하여 활용할 수 있게 해주는 믹스인이다.
/// game.images.fromCache('ember.png') 라인과 함께 사용되는 것을 볼 수 있습니다.
/// 이전에는 모든 파일을 캐시에 로드했으므로 지금 해당 파일을 사용하려면 SpriteAnimation 에서 활용할 수 있도록 fromCache 를 호출합니다.
/// EmberPlayer 클래스는 애니메이션을 정의하고 게임 세계에 적절하게 배치할 수 있는 SpriteAnimationComponent 를 확장합니다.
/// 이 클래스를 구성할 때 Vector2.all(64)의 기본 크기는 게임 세계에서 Ember 의 크기가 64x64여야 하므로 정의됩니다.
/// 애니메이션 SpriteAnimationData 에서 텍스처 크기가 Vector2.all(16) 또는 16x16으로 정의되어 있음을 알 수 있습니다.
/// 이는 ember.png 의 개별 프레임이 16x16이고 총 4개의 프레임이 있기 때문입니다.
/// 애니메이션 속도를 정의하기 위해 stepTime 이 사용되며 프레임당 0.12초로 설정됩니다.
/// 애니메이션이 게임 비전에 맞게 보이도록 stepTime 을 원하는 길이로 변경할 수 있습니다.

class EmberPlayer extends SpriteAnimationComponent
    with HasGameRef<EmberQuestGame> {
  EmberPlayer({required super.position})
      : super(
          size: Vector2.all(64),
          anchor: Anchor.center,
        );

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.12,
        textureSize:Vector2.all(16),
      ),
    );
  }
}
