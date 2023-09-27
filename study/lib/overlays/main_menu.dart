import 'package:flutter/material.dart';

import '../ember_quest.dart';

/// 이것은 정보를 표시하고 재생 버튼을 제공하기 위해 표준 Flutter 위젯을 사용하는 매우 자명한 파일입니다.
/// Flame 과 관련된 유일한 라인은 game.overlays.remove('MainMenu'); 사용자가 게임을 플레이할 수 있도록 오버레이를 제거하기만 하면 됩니다.
/// 사용자는 Ember 가 표시되는 동안 기술적으로 Ember 를 이동할 수 있지만 입력을 트래핑하는 방법은 여러 가지가 있으므로 이 튜토리얼의 범위를 벗어납니다.
class MainMenu extends StatelessWidget {
  // Reference to parent game.
  final EmberQuestGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 250,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ember Quest',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('MainMenu');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '''Use WASD or Arrow Keys for movement.
Space bar to jump.
Collect as many stars as you can and avoid enemies!''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
