import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:study/actors/water_enemy.dart';

import '../ember_quest.dart';
import '../objects/ground_block.dart';
import '../objects/platform_block.dart';
import '../objects/star.dart';

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
    with KeyboardHandler, CollisionCallbacks, HasGameRef<EmberQuestGame> {
  EmberPlayer({required super.position})
      : super(
          size: Vector2.all(64),
          anchor: Anchor.center,
        );

  int horizontalDirection = 0;

  /// 이는 기본 속도를 0으로 설정하고 moveSpeed 를 저장하므로 게임 플레이 방식에 맞게 필요에 따라 조정할 수 있습니다.
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;
  /// 이제 기본 충돌이 생성되었으므로 중력을 추가하여 Ember 가 매우 기본적인 물리학을 사용하여 게임 세계에 존재하도록 할 수 있습니다.
  final double gravity = 15;
  final double jumpSpeed = 600;
  final double terminalVelocity = 150;

  bool hasJumped = false;

  bool hitByEnemy = false;

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.12,
        textureSize: Vector2.all(16),
      ),
    );

    // Ember 에 대해 충돌을 활성화하려면 CircleHitbox 를 추가해야 합니다.
    add(
      CircleHitbox(),
    );
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    position += velocity * dt;
    velocity.y += gravity;

    // Ember 가 점프했는지 확인
    if (hasJumped) {
      if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }
      hasJumped = false;
    }

    // 불씨가 미친 듯이 빠르게 점프하거나 너무 빨리 하강하는 것을 방지합니다.
    // 지면이나 플랫폼을 뚫고 충돌합니다.
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);

    // 왼쪽으로 갈 때 Ember 가 뒤를 돌아보게 하려면 아래 코드를 추가하세요.
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    game.objectSpeed = 0;
    // 불씨가 화면 가장자리에서 뒤로 돌아가는 것을 방지합니다.
    if (position.x - 36 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }
    // Ember 가 화면 절반을 넘어가는 것을 방지합니다.
    if (position.x + 64 >= game.size.x / 2 && horizontalDirection > 0) {
      velocity.x = 0;
      game.objectSpeed = -moveSpeed;
    }

    // Ember 가 구덩이에 떨어지면 게임이 종료됩니다.
    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }

    if (game.health <= 0) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    /// Ember 의 움직임을 제어하려면 이동 방향을 정규화된 벡터처럼 생각하는 변수를 설정하는 것이 가장 쉽습니다.
    /// 즉, 값은 -1, 0 또는 1로 제한됩니다.
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // 충돌 법선과 분리 거리를 계산합니다.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // 충돌 법선이 거의 위쪽에 있는 경우
        // 불씨는 땅에 있어야 합니다.
        if (fromAbove.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        }

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }

    if (other is Star) {
      other.removeFromParent();
      game.starsCollected++;
    }

    if (other is WaterEnemy) {
      hit();
    }

    super.onCollision(intersectionPoints, other);
  }

  // 이 메소드는 불씨에 불투명도 효과를 실행합니다.
  // 깜박이게 만듭니다.
  void hit() {
    if (!hitByEnemy) {
      game.health--;
      hitByEnemy = true;
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 6,
        ),
      )..onComplete = () {
        hitByEnemy = false;
      },
    );
  }
}
