import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:mandir_effects_demo/screens/animation_screen.dart';

void main() {
  runApp(FlowerAnimationApp());
}

class FlowerAnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlowersPaint(),
    );
  }
}

// class FlowerAnimationScreen extends StatefulWidget {
//   @override
//   _FlowerAnimationScreenState createState() => _FlowerAnimationScreenState();
// }

// class _FlowerAnimationScreenState extends State<FlowerAnimationScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   List<FlowerAnimation> _flowers = [];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 5),
//       vsync: this,
//     )..repeat();

//     _controller.addListener(() {
//       setState(() {
//         _flowers.removeWhere((flower) => flower.isOffScreen);
//       });
//     });

//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _controller.repeat();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomPaint(
//         painter: FlowerPainter(_flowers),
//         child: Container(
//           child: Image.asset('assets/flower_1.png'),
//         ),
//       ),
//     );
//   }
// }

// class FlowerAnimation {
//   double x;
//   double y;
//   double size;
//   double rotation;
//   double speed;

//   bool get isOffScreen => y > 1.2;

//   FlowerAnimation({
//     this.x = 0.0,
//     required this.y,
//     required this.size,
//     required this.rotation,
//     required this.speed,
//   });
// }

// class FlowerPainter extends CustomPainter {
//   final List<FlowerAnimation> flowers;
//   final List<ImageProvider> flowerImages;

//   FlowerPainter(this.flowers)
//       : flowerImages = List.generate(
//           5,
//           (index) => AssetImage('assets/flower_$index.png'),
//         );

//   @override
//   void paint(Canvas canvas, Size size) async {
//     for (var flower in flowers) {
//       canvas.save();
//       canvas.translate(flower.x * size.width, flower.y * size.height);
//       canvas.rotate(flower.rotation * pi / 180.0);
//       canvas.scale(flower.size);
//       var flowerImageProvider =
//           flowerImages[Random().nextInt(flowerImages.length)];
//       final completer = Completer<ImageInfo>();
//       final imageStream = flowerImageProvider.resolve(ImageConfiguration.empty);
//       final listener = ImageStreamListener((info, _) {
//         completer.complete(info);
//       });
//       imageStream.addListener(listener);
//       final info = await completer.future;
//       final image = info.image;
//       final imageWidth = image.width.toDouble();
//       final imageHeight = image.height.toDouble();
//       final rect = Rect.fromCenter(
//         center: Offset.zero,
//         width: imageWidth,
//         height: imageHeight,
//       );
//       canvas.drawImageRect(
//         image,
//         rect,
//         rect,
//         Paint(),
//       );
//       canvas.restore();
//     }
//   }

//   @override
//   bool shouldRepaint(FlowerPainter oldDelegate) => true;
// }
