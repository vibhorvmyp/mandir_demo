import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;

class FlowersPaint extends StatefulWidget {
  const FlowersPaint({super.key});

  @override
  State<FlowersPaint> createState() => _FlowersPaintState();
}

class _FlowersPaintState extends State<FlowersPaint>
    with TickerProviderStateMixin {
  late Ticker ticker;
  final notifier = ValueNotifier(Duration.zero);
  ui.Image? flower;

  Offset draggablePosition = Offset(0, 0);
  Offset initialPosition = Offset(0, 0);

  // final player = AudioPlayer();

  final audioPlayer = AudioPlayer();

  bool isPlaying = false;

  final String audioUrl =
      'https://dl.sndup.net/m28g/Hanuman%20Ji%20Ki%20Aarti.mp3';

  // void playBgMusic() async {
  // await audioPlayer.play(UrlSource(audioUrl));
  // }

  void playPauseAudio() async {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(audioUrl));
    }
  }

  @override
  void initState() {
    super.initState();
    ticker = Ticker(_tick);
    rootBundle
        .load('assets/flower_2.png')
        .then((data) => decodeImageFromList(data.buffer.asUint8List()))
        .then(_setSprite);

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        // setState(() {
        isPlaying = true;
        // });
      } else if (state == PlayerState.paused || state == PlayerState.stopped) {
        // setState(() {
        isPlaying = false;
        // });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  _tick(Duration d) => notifier.value = d;

  _setSprite(ui.Image image) {
    setState(() {
      // print('image: $image');
      flower = image;
      // ticker.start();
    });
  }

  void resetDraggablePosition() {
    // setState(() {
    //   draggablePosition = initialPosition;
    // });
  }

  // void playBellSound() async {
  //   await player.play(UrlSource(
  //       'https://2u039f-a.akamaihd.net/downloads/ringtones/files/mp3/temple-bell-543.mp3'));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/hanuman_1.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: CustomPaint(
                foregroundPainter: FallingFlowersPainter(flower, notifier),
                // child: Center(
                //   child: TextButton(
                //     onPressed: () =>
                //         ticker.isTicking ? ticker.stop() : ticker.start(),
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 10, vertical: 3),
                //       decoration: BoxDecoration(
                //           color: Colors.blue,
                //           borderRadius: BorderRadius.circular(10)),
                //       child: const Text(
                //         'click to stop / start',
                //         textScaleFactor: 1.5,
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
              ),
            ),
          ),

          //Draggable object
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Draggable(
              child: Container(
                width: 180,
                height: 180,
                child: Image.asset('assets/pooja_thaali.png'),
                // color: Colors.red,
              ),
              feedback: Container(
                width: 180,
                height: 180,
                child: Image.asset('assets/pooja_thaali.png'),
                // color: Colors.red.withOpacity(0.7),
              ),
              onDragStarted: () {
                // setState(() {
                initialPosition = Offset(
                  MediaQuery.of(context).size.width / 2 - 50,
                  MediaQuery.of(context).size.height - 100,
                );
                // });
              },
              onDragEnd: (_) {
                resetDraggablePosition();
              },
              onDraggableCanceled: (_, __) {
                resetDraggablePosition();
              },
              childWhenDragging: Container(),
              onDragCompleted: () {
                resetDraggablePosition();
              },
              // onDraggableCanceled: (_, __) {
              //   resetDraggablePosition();
              // },
            ),
          ),

          Positioned(
            bottom: 120,
            left: 16,
            child: GestureDetector(
              onTap: () => ticker.isTicking ? ticker.stop() : ticker.start(),
              child: Container(
                  width: 52,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.brown.shade400.withOpacity(0.9),
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.brown)
                      // color: Colors.amber,
                      ),
                  child: Image.asset('assets/flower_2.png')),
              // icon: Icon(, color: Colors.white),
            ),
          ),

          Positioned(
            bottom: 120,
            right: 16,
            child: GestureDetector(
              onTap: () {
                playPauseAudio();
              },
              child: Container(
                width: 55,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color(0xFFEB0C2E),
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.brown)
                    // color: Colors.amber,
                    ),
                child: Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              // icon: Icon(, color: Colors.white),
            ),
          ),

          // // Swinging bell
          Positioned(
            top: 100,
            left: 250,
            child: SwingingBellAnimation(),
          ),
          Positioned(
            top: 100,
            right: 250,
            child: SwingingBellAnimation(),
          ),

          // Positioned(
          //   top: 500,
          //   right: 250,
          //   child: GestureDetector(
          //       onTap: () {
          //         print('Play audio');
          //         playBellSound();
          //       },
          //       child: Container(color: Colors.pink, child: Text('Hello'))),
          // ),
        ],
      ),
    );
  }
}

class Flower {
  Flower(int ms, this.rect, List<double> r, Size size)
      : startTimeMs = ms,
        scale = lerpDouble(1, 0.5, r[0])!,
        rotation = pi * lerpDouble(-2, 2, r[2])!,
        xSimulation = FrictionSimulation(0.9, r[2] * size.width,
            ui.lerpDouble(size.width / 2, -size.width / 2, r[1])!),
        // ySimulation = GravitySimulation(ui.lerpDouble(10, 1000, r[0])!,
        //     -rect.height / 2, size.height + rect.height / 2, 100);
        ySimulation = GravitySimulation(
            40, -rect.height / 2, size.height + rect.height / 2, 100);

  final int startTimeMs;
  final Rect rect;
  final Simulation xSimulation;
  final Simulation ySimulation;
  final double scale;
  final double rotation;

  double x(int ms) => xSimulation.x(_normalizeTime(ms));

  double y(int ms) => ySimulation.x(_normalizeTime(ms));

  bool isDead(int ms) => ySimulation.isDone(_normalizeTime(ms));

  double _normalizeTime(int ms) =>
      (ms - startTimeMs) / Duration.millisecondsPerSecond;

  RSTransform transform(int ms, Size size) {
    final translateY = y(ms);
    return RSTransform.fromComponents(
      translateX: x(ms),
      translateY: translateY,
      anchorX: rect.width / 2,
      anchorY: rect.height / 2,
      rotation: rotation * translateY / size.height,
      scale: scale,
    );
  }
}

class FallingFlowersPainter extends CustomPainter {
  final ui.Image? flower;
  final ValueNotifier<Duration> notifier;
  final imagePaint = Paint();
  final backgroundPaint = Paint()..color = Colors.transparent;
  final random = Random();
  final flowers = <Flower>[];
  int nextReport = 0;

  static const flowerRects = [
    Rect.fromLTRB(000, 0, 103, 140),
    Rect.fromLTRB(103, 0, 217, 140),
    Rect.fromLTRB(217, 0, 312, 140),
    Rect.fromLTRB(312, 0, 410, 140),
  ];

  FallingFlowersPainter(this.flower, this.notifier) : super(repaint: notifier);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawPaint(backgroundPaint);
    if (flower != null) {
      final ms = DateTime.now().millisecondsSinceEpoch;
      if (random.nextDouble() < 1) {
        // drop new bird
        flowers.add(Flower(ms, flowerRects[random.nextInt(4)],
            List.generate(3, (i) => random.nextDouble()), size));
      }

      final transforms =
          flowers.map((flower) => flower.transform(ms, size)).toList();
      final rects = flowers.map((flower) => flower.rect).toList();
      canvas.drawAtlas(
          flower!, transforms, rects, null, null, null, imagePaint);

      // dead birds cleanup
      flowers.removeWhere((flower) => flower.isDead(ms));

      if (ms >= nextReport) {
        nextReport = ms + 2000;
        print('flowers population: ${flowers.length}');
      }
    }
  }

  @override
  bool shouldRepaint(FallingFlowersPainter oldDelegate) => false;
}

class SwingingBellAnimation extends StatefulWidget {
  const SwingingBellAnimation({super.key});

  @override
  SwingingBellAnimationState createState() => SwingingBellAnimationState();
}

class SwingingBellAnimationState extends State<SwingingBellAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _swingAnimation;

  final double _swingAngle = pi / 6;

  @override
  void initState() {
    super.initState();

    playBellSound();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _swingAnimation = Tween<double>(
      begin: -_swingAngle,
      end: _swingAngle,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  final player = AudioPlayer();

  void playBellSound() async {
    await player.play(UrlSource(
        'https://2u039f-a.akamaihd.net/downloads/ringtones/files/mp3/temple-bell-543.mp3'));
  }

  @override
  void dispose() {
    _animationController.dispose();
    player.dispose();
    super.dispose();
  }

  void _handleTap() {
    playBellSound();
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _swingAnimation.value * sin(_animationController.value * pi),
            child: child,
          );
        },
        child: Image.asset(
          'assets/bell.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}




// class SwingingBellAnimation extends StatefulWidget {
//   @override
//   _SwingingBellAnimationState createState() => _SwingingBellAnimationState();
// }

// class _SwingingBellAnimationState extends State<SwingingBellAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _swingAnimation;
//   bool _isAnimating = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 6),
//     );
//     _swingAnimation = Tween<double>(begin: -0.0, end: 0.1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOutBack, // Use a custom easing curve
//       ),
//     )..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _controller.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           setState(() {
//             _isAnimating = false;
//           });
//         }
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void startAnimation() {
//     setState(() {
//       _isAnimating = true;
//     });
//     _controller.reset();
//     _controller.forward();
//   }

//   void stopAnimation() {
//     _controller.stop();
//     setState(() {
//       _isAnimating = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (_isAnimating) {
//           stopAnimation();
//         } else {
//           startAnimation();
//         }
//       },
//       child: AnimatedBuilder(
//         animation: _swingAnimation,
//         builder: (context, child) {
//           return Transform.rotate(
//             angle: _swingAnimation.value,
//             child: child,
//           );
//         },
//         child: Container(
//           width: 180,
//           height: 180,
//           child: Image.asset('assets/bell.png'),
//         ),
//       ),
//     );
//   }
// }




// class SwingingBellAnimation extends StatefulWidget {
//   @override
//   _SwingingBellAnimationState createState() => _SwingingBellAnimationState();
// }

// class _SwingingBellAnimationState extends State<SwingingBellAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _swingAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     )..repeat(reverse: true);
//     _swingAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _swingAnimation,
//       builder: (context, child) {
//         return Transform.rotate(
//           angle: _swingAnimation.value,
//           child: child,
//         );
//       },
//       child: Container(
//         width: 100,
//         height: 100,
//         child: Image.asset('assets/bell.png'),
//       ),
//     );
//   }
// }






// class SwingingBellAnimation extends StatefulWidget {
//   @override
//   _SwingingBellAnimationState createState() => _SwingingBellAnimationState();
// }

// class _SwingingBellAnimationState extends State<SwingingBellAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );

//     _animation = Tween<double>(
//       begin: 0,
//       end: 0.2,
//     ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _controller.reverse();
//       } else if (status == AnimationStatus.dismissed) {
//         _controller.forward();
//       }
//     });

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Transform.rotate(
//           angle: _animation.value,
//           child: child,
//         );
//       },
//       child: GestureDetector(
//         onTap: () {
//           if (_controller.isAnimating) {
//             _controller.stop();
//           } else {
//             _controller.forward();
//           }
//         },
//         child: Container(
//           width: 100,
//           height: 100,
//           child: Image.asset('assets/bell.png'),
//         ),
//       ),
//     );
//   }
// }




// class SpritePainter extends CustomPainter {
//   final ui.Image? sprite;
//   final ValueNotifier<Duration> notifier;
//   final p = Paint();

//   SpritePainter(this.sprite, this.notifier) : super(repaint: notifier);

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.clipRect(Offset.zero & size);
//     if (sprite != null) {
//       final ms = notifier.value.inMilliseconds;
//       final frame = ms ~/ 80;
//       // print(frame);
//       final frames = [frame, frame + 2, frame + 4].map((f) => f % 6).toList();
//       final spritePhases = [
//         phase(size.width, ms * 0.066),
//         phase(size.width, ms * 0.075 + 40),
//         phase(size.width, ms * 0.075 + 80),
//       ];
//       final transforms = [
//         for (int i = 0; i < spritePhases.length; i++)
//           ui.RSTransform(1, 0, spritePhases[i][0], size.height / 2 - 45),
//       ];
//       final rects = [
//         for (int i = 0; i < spritePhases.length; i++)
//           Rect.fromLTWH(frames[i] * 100, spritePhases[i][1] * 100, 100, 100),
//       ];
//       canvas.drawAtlas(sprite!, transforms, rects, null, null, null, p);
//     }
//   }

//   List<double> phase(double width, double x) {
//     final w = width + 100;
//     x = x % (2 * w);
//     return x < w ? [x - 100, 0] : [2 * w - x - 100, 1];
//   }

//   @override
//   bool shouldRepaint(SpritePainter oldDelegate) => false;
// }
