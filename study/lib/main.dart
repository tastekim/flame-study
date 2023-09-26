import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:study/ember_quest.dart';

/// FlameGame 클래스는 component 기반 게임을 구현합니다.
/// FlameGame 은 component tree 의 root 입니다.
/// 확장하여 게임 로직을 추가하거나 해당 로직을 child component 에 유지할 수 있습니다.

/// Position: 상위 구성 요소를 기준으로 구성 요소의 앵커 위치를 Vector2 형식으로 나타냅니다.
/// Size: 구성 요소의 논리적 크기입니다. 주로 탭 및 충돌 감지에 사용됩니다. 따라서 크기는 렌더링된 그림의 대략적인 경계 사각형과 같아야 합니다. PositionComponent 크기를 지정하지 않으면 0이 되며 구성 요소는 탭에 응답할 수 없습니다.
/// Scale: 구성 요소의 배율입니다. 배율은 X 및 Y 치수에 따라 구분될 수 있습니다. 1보다 작은 배율은 구성 요소를 더 작게 만들고 1보다 큰 구성 요소를 더 크게 만듭니다. 스케일은 음수일 수도 있으며, 이로 인해 해당 축을 따라 거울 반사가 발생합니다.
/// Anchor: 이 지점은 구성 요소의 논리적 "중심" 또는 Flame 구성 요소를 잡는 지점으로 간주됩니다. 모든 변환은 이 지점 주변에서 발생합니다.
/// Angle: 구성 요소의 회전 각도(라디안)입니다. 각도가 양수이면 구성 요소는 기준점을 중심으로 시계 방향으로 회전하고, 각도가 음수이면 시계 반대 방향으로 회전합니다.

void main() {
  runApp(
    const GameWidget<EmberQuestGame>.controlled(
      gameFactory: EmberQuestGame.new,
    ),
  );
}
