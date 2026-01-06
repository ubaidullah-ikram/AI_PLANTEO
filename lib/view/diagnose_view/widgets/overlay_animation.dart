import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Improved Scanning Animation Widget
class ScanningAnimation extends StatefulWidget {
  const ScanningAnimation({Key? key}) : super(key: key);

  @override
  State<ScanningAnimation> createState() => _ScanningAnimationState();
}

class _ScanningAnimationState extends State<ScanningAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(
            reverse: true,
          ); // Reverse animation - opr se nechy, phir nechy se opr
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Corner brackets - Top Left
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   child: Container(
        //     width: 50,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       border: Border(
        //         top: BorderSide(color: Colors.white, width: 3),
        //         left: BorderSide(color: Colors.white, width: 3),
        //       ),
        //     ),
        //   ),
        // ),
        // // Corner brackets - Top Right
        // Positioned(
        //   top: 0,
        //   right: 0,
        //   child: Container(
        //     width: 50,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       border: Border(
        //         top: BorderSide(color: Colors.white, width: 3),
        //         right: BorderSide(color: Colors.white, width: 3),
        //       ),
        //     ),
        //   ),
        // ),
        // // Corner brackets - Bottom Left
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   child: Container(
        //     width: 50,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       border: Border(
        //         bottom: BorderSide(color: Colors.white, width: 3),
        //         left: BorderSide(color: Colors.white, width: 3),
        //       ),
        //     ),
        //   ),
        // ),
        // // Corner brackets - Bottom Right
        // Positioned(
        //   bottom: 0,
        //   right: 0,
        //   child: Container(
        //     width: 50,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       border: Border(
        //         bottom: BorderSide(color: Colors.white, width: 3),
        //         right: BorderSide(color: Colors.white, width: 3),
        //       ),
        //     ),
        //   ),
        // ),

        // Scanning line animation (top to bottom, phir bottom to top)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // 0 to 1 -> -100 to 100 (top to bottom)
            // 1 to 0 -> 100 to -100 (bottom to top) - reverse animation
            double offset = (_controller.value * 220) - 100;

            return Transform.translate(
              offset: Offset(0, offset),
              child: Container(
                width: Get.width * 0.8,
                height: 1,
                decoration: BoxDecoration(
                  color: Color(0xff3AB57C),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [
                  //     Color(0xff3AB57C).withOpacity(0),
                  //     Color(0xff2A8259).withOpacity(.7),
                  //     Color(0xff3AB57C).withOpacity(0),
                  //   ],
                  // ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      color: Color(0xff3AB57C),
                      blurRadius: 15,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Glow effect behind scanning line
        // AnimatedBuilder(
        //   animation: _controller,
        //   builder: (context, child) {
        //     double offset = (_controller.value * 400) - 200;

        //     return Transform.translate(
        //       offset: Offset(0, 0),
        //       child: Container(
        //         // width: 250,
        //         // height: 80,
        //         // decoration: BoxDecoration(
        //         //   gradient: RadialGradient(
        //         //     colors: [
        //         //       Colors.greenAccent.withOpacity(0.3),
        //         //       Colors.greenAccent.withOpacity(0.1),
        //         //       Colors.greenAccent.withOpacity(0),
        //         //     ],
        //         //   ),
        //         // ),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
