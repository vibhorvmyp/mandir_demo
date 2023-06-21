// import 'package:flutter/material.dart';

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
