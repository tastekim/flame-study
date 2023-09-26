import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:study/ember_quest.dart';

/// The Platform Block
/// 시작하기 가장 쉬운 블록 중 하나는 플랫폼 블록입니다. 스프라이트를 표시하는 것 외에 개발해야 할 두 가지 사항이 있습니다.
/// 즉, 올바른 위치에 배치해야 하며 Ember 가 화면을 가로질러 이동할 때 블록이 화면 밖으로 나오면 블록을 제거해야 합니다.
/// Ember Quest 에서는 플레이어가 앞으로만 이동할 수 있으므로 무한 레벨이므로 게임이 가벼워집니다.

/// Flame SpriteComponent 를 확장할 예정이며 이전과 마찬가지로 게임 클래스에 액세스하려면 HasGameRef 믹스인이 필요합니다.
/// 빈 onLoad 및 update 메소드로 시작하고 게임에 필요한 기능을 생성하기 위한 코드를 추가하기 시작할 것입니다.
/// 모든 게임 엔진의 비밀은 게임 루프입니다. 이는 업데이트를 제공할 수 있도록 게임의 모든 개체를 호출하는 무한 루프입니다.
/// 업데이트 메소드는 이에 대한 후크이며 이중 dt를 사용하여 마지막 호출 이후의 시간(초)을 메소드에 전달합니다.
/// 이 dt 변수를 사용하면 구성 요소가 화면에서 얼마나 멀리 이동해야 하는지 계산할 수 있습니다.
class PlatformBlock extends SpriteComponent with HasGameRef<EmberQuestGame> {
  final Vector2 gridPosition;
  double xOffset;

  PlatformBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  final Vector2 velocity = Vector2.zero();

  /// 2) 다음으로 Flame 엔진 구성요소에 내장된 특수 변수인 position 을 업데이트합니다. 속도 벡터에 dt를 곱하면 구성 요소를 필요한 양만큼 이동할 수 있습니다.
  /// 마지막으로 position 의 x 값이 -size.x(이미지 너비만큼 화면 왼쪽에서 벗어남을 의미)인 경우 게임에서 이 플랫폼 블록을 완전히 제거합니다.
  @override
  void onLoad() {
    /// 3) 먼저 이전처럼 캐시에서 이미지를 검색합니다. 이는 SpriteComponent 이므로 내장 스프라이트 변수를 사용하여 이미지를 구성 요소에 할당할 수 있습니다.
    /// 다음으로 시작 위치를 계산해야 합니다. 여기가 모든 마법이 일어나는 곳이므로 이를 분석해 보겠습니다.
    /// 업데이트 방법과 마찬가지로 위치 변수를 Vector2로 설정합니다. 어디에 있어야 하는지 결정하려면 x 및 y 위치를 계산해야 합니다.
    /// 먼저 x에 초점을 맞추면 이미지 너비의 GridPosition.x 배를 취한 다음 이를 전달하는 xOffset 에 추가하는 것을 볼 수 있습니다.
    /// y축을 사용하여 게임의 높이를 취합니다. 그리고 우리는 이미지 높이에 GridPosition.y를 곱한 값을 뺍니다.
    /// 마지막으로 Ember 가 플랫폼과 상호 작용할 수 있도록 하기 위해 수동 CollisionType 이 있는 RectangleHitbox 를 추가합니다. 충돌에 대해서는 이후 장에서 더 자세히 설명하겠습니다.

    final platformImage = game.images.fromCache('block.png');
    sprite = Sprite(platformImage);
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );

    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  /// 1) 일어나는 모든 일은 두 축의 0에서 인스턴스화되는 기본 속도를 정의한 다음 x축에 대한 전역 objectSpeed 변수를 사용하여 속도를 업데이트하는 것입니다.
  /// 이것은 플랫폼 블록이므로 왼쪽과 오른쪽으로만 스크롤하므로 블록이 점프하는 것을 원하지 않으므로 속도의 y축은 항상 0이 됩니다.
  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x) removeFromParent();
    super.update(dt);
  }
}
