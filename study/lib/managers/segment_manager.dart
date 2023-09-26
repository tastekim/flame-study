import 'package:flame/components.dart';

import '../actors/water_enemy.dart';
import '../objects/ground_block.dart';
import '../objects/platform_block.dart';
import '../objects/star.dart';

class Block {
  // GridPosition 위치는 항상 X,Y 세그먼트 기반입니다.
  // 0,0은 왼쪽 하단 모서리입니다.
  // 10,10은 오른쪽 상단입니다.
  final Vector2 gridPosition;
  final Type blockType;

  Block(this.gridPosition, this.blockType);
}

/// 이것이 하는 일은 세그먼트 목록에 추가되는 목록 형식으로 세그먼트(segment0, 세그먼트1 등)를 생성할 수 있게 하는 것입니다.
/// 개별 세그먼트는 Block 클래스의 여러 항목으로 구성됩니다. 이 정보를 통해 블록 위치를 10x10 그리드에서 게임 세계의 실제 픽셀 위치로 변환할 수 있습니다.
/// 세그먼트를 생성하려면 스케치에서 렌더링하려는 각 블록에 대한 항목을 생성해야 합니다.
final segments = [
  segment0,
  segment1,
  segment2,
  segment3,
  segment4,
];

// final segment0 = [];

/// 각 세그먼트를 이해하기 위해 스케치의 그리드 왼쪽 하단에서 시작하면 Vector2(0,0)의 첫 번째 매개변수인 GridPosition 을 사용하여
/// segment0 목록에 Block()을 배치해야 한다는 것을 알 수 있습니다. 이전에 생성한 GroundBlock 클래스의 blockType 입니다.
/// 맨 왼쪽 맨 아래 셀은 x=0이고 y=0이므로 Vector2(x,y)는 Vector2(0,0)입니다.

final segment0 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(2, 0), GroundBlock),
  Block(Vector2(3, 0), GroundBlock),
  Block(Vector2(4, 0), GroundBlock),
  Block(Vector2(5, 0), GroundBlock),
  Block(Vector2(5, 1), WaterEnemy),
  Block(Vector2(5, 3), PlatformBlock),
  Block(Vector2(6, 0), GroundBlock),
  Block(Vector2(6, 3), PlatformBlock),
  Block(Vector2(7, 0), GroundBlock),
  Block(Vector2(7, 3), PlatformBlock),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(8, 3), PlatformBlock),
  Block(Vector2(9, 0), GroundBlock),
];

final segment1 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(1, 1), PlatformBlock),
  Block(Vector2(1, 2), PlatformBlock),
  Block(Vector2(1, 3), PlatformBlock),
  Block(Vector2(2, 6), PlatformBlock),
  Block(Vector2(3, 6), PlatformBlock),
  Block(Vector2(6, 5), PlatformBlock),
  Block(Vector2(7, 5), PlatformBlock),
  Block(Vector2(7, 7), Star),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(8, 1), PlatformBlock),
  Block(Vector2(8, 5), PlatformBlock),
  Block(Vector2(8, 6), WaterEnemy),
  Block(Vector2(9, 0), GroundBlock),
];

final segment2 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(2, 0), GroundBlock),
  Block(Vector2(3, 0), GroundBlock),
  Block(Vector2(3, 3), PlatformBlock),
  Block(Vector2(4, 0), GroundBlock),
  Block(Vector2(4, 3), PlatformBlock),
  Block(Vector2(5, 0), GroundBlock),
  Block(Vector2(5, 3), PlatformBlock),
  Block(Vector2(5, 4), WaterEnemy),
  Block(Vector2(6, 0), GroundBlock),
  Block(Vector2(6, 3), PlatformBlock),
  Block(Vector2(6, 4), PlatformBlock),
  Block(Vector2(6, 5), PlatformBlock),
  Block(Vector2(6, 7), Star),
  Block(Vector2(7, 0), GroundBlock),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(9, 0), GroundBlock),
];

final segment3 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(1, 1), WaterEnemy),
  Block(Vector2(2, 0), GroundBlock),
  Block(Vector2(2, 1), PlatformBlock),
  Block(Vector2(2, 2), PlatformBlock),
  Block(Vector2(4, 4), PlatformBlock),
  Block(Vector2(6, 6), PlatformBlock),
  Block(Vector2(7, 0), GroundBlock),
  Block(Vector2(7, 1), PlatformBlock),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(8, 8), Star),
  Block(Vector2(9, 0), GroundBlock),
];

final segment4 = [
  Block(Vector2(0, 0), GroundBlock),
  Block(Vector2(1, 0), GroundBlock),
  Block(Vector2(2, 0), GroundBlock),
  Block(Vector2(2, 3), PlatformBlock),
  Block(Vector2(3, 0), GroundBlock),
  Block(Vector2(3, 1), WaterEnemy),
  Block(Vector2(3, 3), PlatformBlock),
  Block(Vector2(4, 0), GroundBlock),
  Block(Vector2(5, 0), GroundBlock),
  Block(Vector2(5, 5), PlatformBlock),
  Block(Vector2(6, 0), GroundBlock),
  Block(Vector2(6, 5), PlatformBlock),
  Block(Vector2(6, 7), Star),
  Block(Vector2(7, 0), GroundBlock),
  Block(Vector2(8, 0), GroundBlock),
  Block(Vector2(8, 3), PlatformBlock),
  Block(Vector2(9, 0), GroundBlock),
  Block(Vector2(9, 1), WaterEnemy),
  Block(Vector2(9, 3), PlatformBlock),
];