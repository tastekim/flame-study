import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:study/actors/water_enemy.dart';
import 'package:study/objects/ground_block.dart';
import 'package:study/overlays/hud.dart';

import 'actors/ember.dart';
import 'managers/segment_manager.dart';
import 'objects/platform_block.dart';
import 'objects/star.dart';

class EmberQuestGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  EmberQuestGame();

  late EmberPlayer _ember;
  double objectSpeed = 0.0;

  final _world = World();

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  // FlameGame.camera 는 더 이상 사용하지 않음. (Flame v2에 내장되는 CameraComponent 사용)
  late final CameraComponent cameraComponent;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  int starsCollected = 0;
  int health = 3;

  /// 1. 먼저 assets load.
  @override
  Future<void> onLoad() async {
    debugPrint('Ember Quest load assets.');
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

    debugPrint('load finished.');
    cameraComponent = CameraComponent(world: _world);
    // 이 튜토리얼의 모든 내용은 위치가 다음과 같다고 가정합니다.
    // `CameraComponent` 뷰파인더(카메라가 보고 있는 곳)는 왼쪽 상단에 있으므로 여기에 앵커를 설정합니다.
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([cameraComponent, _world]);

    initializeGame(true);
  }

  void initializeGame(bool loadHud) {
    /// 단순히 게임 화면의 너비를 640으로 나누고(한 세그먼트의 10개 블록 x 각 블록의 너비 64픽셀) 이를 반올림합니다.
    /// 총 5개의 세그먼트만 정의했으므로 사용자가 매우 넓은 화면을 사용하는 경우를 대비하여 해당 정수를 0에서 세그먼트 목록의 길이로 제한해야 합니다.
    /// 그런 다음 SegmentToLoad 수를 반복하고 로드할 정수로 loadGameSegments 를 호출한 다음 오프셋을 계산합니다.
    debugPrint('initializeGame execute.');

    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    // _ember = EmberPlayer(
    //   position: Vector2(128, canvasSize.y - 70),
    // );

    /// 앞서 Ember 가 잔디 중앙에 있다고 언급했습니다.
    /// 이 문제를 해결하고 충돌과 중력이 Ember 에서 어떻게 작동하는지 보여주기 위해 게임을 시작할 때 약간의 드롭인을 추가하고 싶습니다.
    _ember = EmberPlayer(
      position: Vector2(128, canvasSize.y - 128),
    );

    // _world.add(_ember);
    // cameraComponent.viewport.add(Hud());
    add(_ember);
    if (loadHud) {
      add(Hud());
    }
  }

  @override
  void update(double dt) {
    if (health <= 0) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }

  /// 게임에 HUD 추가를 우회할 수 있는 매개변수를 초기화게임 메소드에 추가했음을 알 수 있습니다.
  /// 이는 다음 섹션에서 Ember 의 체력이 0으로 떨어지면 게임을 지우지만 HUD 를 제거할 필요는 없기 때문입니다.
  /// 단순히 Reset()을 사용하여 값을 재설정하면 되기 때문입니다.
  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

  /// Loading the Segments into the World
  /// 이제 세그먼트가 정의되었으므로 이러한 블록을 세계에 로드하는 방법을 만들어야 합니다.
  /// 세그먼트 목록에 대한 인덱스가 제공되면 Segment_manager 에서 해당 세그먼트를 반복하고
  /// 나중에 적절한 블록을 추가하는 loadSegments 메서드를 생성합니다. 다음과 같아야 합니다.
  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          add(
            GroundBlock(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case PlatformBlock:
          add(PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case Star:
          add(
            Star(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
        case WaterEnemy:
          add(
            WaterEnemy(
              gridPosition: block.gridPosition,
              xOffset: xPositionOffset,
            ),
          );
          break;
      }
    }
  }
}
