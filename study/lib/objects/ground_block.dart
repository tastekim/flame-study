import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../ember_quest.dart';
import '../managers/segment_manager.dart';

/// 마지막으로 표시해야 할 마지막 구성 요소는 Ground Block 입니다! 이 구성 요소는 블록의 수명 주기 동안 두 번 식별해야 하므로 다른 구성 요소보다 더 복잡합니다.
/// * 블록이 추가될 때 해당 블록이 세그먼트의 마지막 블록인 경우 해당 위치에 대한 전역 값을 업데이트해야 합니다.
/// * 블록이 제거되면 해당 블록이 세그먼트의 첫 번째 블록인 경우 로드할 다음 세그먼트를 무작위로 가져와야 합니다.
class GroundBlock extends SpriteComponent with HasGameRef<EmberQuestGame> {
  final Vector2 gridPosition;
  double xOffset;

  final Vector2 velocity = Vector2.zero();

  GroundBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  final UniqueKey _blockKey = UniqueKey();

  @override
  void onLoad() {
    final groundImage = game.images.fromCache('ground.png');
    sprite = Sprite(groundImage);
    position = Vector2(
      gridPosition.x * size.x + xOffset,
      game.size.y - gridPosition.y * size.y,
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));

    /// 일어나는 모든 일은 이 블록이 10번째 블록(세그먼트 그리드가 0 기반이므로 9)이고 이 블록의 위치가 전역 lastBlockXPosition 보다 큰 경우,
    /// 전역 블록 키를 이 블록의 키로 설정하고 전역 블록을 설정하는 것입니다.
    /// lastBlockXPosition 은 이 블록 위치에 이미지 너비를 더한 값이 됩니다(앵커는 왼쪽 하단에 있고 다음 블록이 바로 옆에 정렬되기를 원함).
    if (gridPosition.x == 9 && position.x > game.lastBlockXPosition) {
      game.lastBlockKey = _blockKey;
      game.lastBlockXPosition = position.x + size.x;
    }
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;

    /// 블록이 화면에서 벗어나고 블록이 세그먼트의 첫 번째 블록인 경우 게임 클래스에서 loadGameSegments 메서드를 호출하여 무작위 개체를 얻습니다.
    /// 0과 세그먼트 수 사이의 숫자를 지정하고 오프셋을 전달합니다.
    if (position.x < -size.x) {
      removeFromParent();
      if (gridPosition.x == 0) {
        game.loadGameSegments(
          Random().nextInt(segments.length),
          game.lastBlockXPosition,
        );
      }
    }

    /// game.lastBlockXPosition 은 블록의 현재 x축 위치와 너비(10픽셀)를 더해 업데이트됩니다.
    /// 이로 인해 약간의 겹침이 발생하지만 dt의 잠재적인 변화로 인해 플레이어가 이동하는 동안 지도가 로드될 때 지도에 틈이 생기는 것을 방지할 수 있습니다.
    if (gridPosition.x == 9) {
      if (game.lastBlockKey == _blockKey) {
        game.lastBlockXPosition = position.x + size.x - 10;
      }
    }

    super.update(dt);
  }
}