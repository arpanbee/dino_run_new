import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '/game/friend.dart';
import '/game/dino_run.dart';
import '/models/friend_data.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class FriendManager extends Component with HasGameReference<DinoRun> {
  // A list to hold data for all the enemies.
  final List<FriendData> _data = [];

  // Random generator required for randomly selecting enemy type.
  final Random _random = Random();

  // Timer to decide when to spawn next enemy.
  final Timer _timer = Timer(2, repeat: true);

  FriendManager() {
    _timer.onTick = spawnRandomFriend;
  }

  // This method is responsible for spawning a random enemy.
  void spawnRandomFriend() {
    /// Generate a random index within [_data] and get an [EnemyData].
    final randomIndex = _random.nextInt(_data.length);
    final friendData = _data.elementAt(randomIndex);
    final friend = Friend(friendData);

    // Help in setting all enemies on ground.
    friend.anchor = Anchor.bottomLeft;
    friend.position = Vector2(
      game.virtualSize.x + 32,
      game.virtualSize.y - 24,
    );

    friend.paint.color.brighten(0.9);

    // If this enemy can fly, set its y position randomly.
    if (friendData.canFly) {
      final newHeight = _random.nextDouble() * 2 * friendData.textureSize.y;
      friend.position.y -= newHeight;
    }

    // Due to the size of our viewport, we can
    // use textureSize as size for the components.
    friend.size = friendData.textureSize;
    game.world.add(friend);
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    // Don't fill list again and again on every mount.
    if (_data.isEmpty) {
      // As soon as this component is mounted, initilize all the data.
      _data.addAll([
        // FriendData(
        //   image: game.images.fromCache('AngryPig/Walk (36x30).png'),
        //   nFrames: 16,
        //   stepTime: 0.1,
        //   textureSize: Vector2(36, 30),
        //   speedX: 80,
        //   canFly: false,
        // ),
        FriendData(
          image: game.images.fromCache('Bird/Flying (32x32).png'),
          nFrames: 9,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
          speedX: 80,
          canFly: true,
        ),
        // FriendData(
        //   image: game.images.fromCache('Bat/Flying (46x30).png'),
        //   nFrames: 7,
        //   stepTime: 0.1,
        //   textureSize: Vector2(46, 30),
        //   speedX: 80,
        //   canFly: true,
        // ),
        FriendData(
          image: game.images.fromCache('Ghost/Idle (44x30).png'),
          nFrames: 10,
          stepTime: 0.1,
          textureSize: Vector2(44, 30),
          speedX: 80,
          canFly: false,
        ),
        FriendData(
          image: game.images.fromCache('Snail/Idle (38x24).png'),
          nFrames: 15,
          stepTime: 0.1,
          textureSize: Vector2(38, 24),
          speedX: 80,
          canFly: false
        // FriendData(
        //   image: game.images.fromCache('Rino/Run (52x34).png'),
        //   nFrames: 6,
        //   stepTime: 0.09,
        //   textureSize: Vector2(52, 34),
        //   speedX: 80,
        //   canFly: false,
        ),
      ]);
    }
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllFriends() {
    final friends = game.world.children.whereType<Friend>();
    for (var friend in friends) {
      friend.removeFromParent();
    }
  }
}
