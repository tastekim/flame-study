import '../ember_quest.dart';
import 'package:flame/components.dart';


/// HeartHealthComponent 는 초기에 생성된 하트 이미지를 사용하는 SpriteGroupComponent 입니다.
/// 수행되는 고유한 작업은 구성 요소가 생성될 때 heartNumber 가 필요하다는 것입니다.
/// 따라서 업데이트 메서드에서 game.health 가 heartNumber 보다 작은지 확인하고 그렇다면 상태를 변경합니다.
enum HeartState {
  available,
  unavailable,
}

class HeartHealthComponent extends SpriteGroupComponent<HeartState>
    with HasGameRef<EmberQuestGame> {
  final int heartNumber;

  HeartHealthComponent({
    required this.heartNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final availableSprite = await game.loadSprite(
      'heart.png',
      srcSize: Vector2.all(32),
    );

    final unavailableSprite = await game.loadSprite(
      'heart_half.png',
      srcSize: Vector2.all(32),
    );

    sprites = {
      HeartState.available: availableSprite,
      HeartState.unavailable: unavailableSprite,
    };

    current = HeartState.available;
  }

  @override
  void update(double dt) {
    if (game.health < heartNumber) {
      current = HeartState.unavailable;
    } else {
      current = HeartState.available;
    }
    super.update(dt);
  }
}