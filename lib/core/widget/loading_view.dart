import 'dart:math';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:flutter/material.dart';

class LoadingViewWidget extends StatelessWidget {
  final LoadingType type;
  final Color? color;
  final double? size;
  final String? imagePath; // مسار الصورة المخصصة

  const LoadingViewWidget({
    super.key,
    this.type = LoadingType.pulseDots,
    this.color,
    this.size,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Palette.primary;
    final loadingSize = size ?? 55.0;

    switch (type) {
      case LoadingType.pulseDots:
        return _PulseDotsLoading(color: primaryColor, size: loadingSize);
      case LoadingType.imageShake:
        return _ImageShakeLoading(
          color: primaryColor,
          size: loadingSize,
          imagePath: imagePath,
        );
    }
  }
}

enum LoadingType { pulseDots, imageShake }

// أنيميشن الصورة المهتزة
class _ImageShakeLoading extends StatefulWidget {
  final Color color;
  final double size;
  final String? imagePath;

  const _ImageShakeLoading({
    required this.color,
    required this.size,
    this.imagePath,
  });

  @override
  __ImageShakeLoadingState createState() => __ImageShakeLoadingState();
}

class __ImageShakeLoadingState extends State<_ImageShakeLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // أنيميشن الاهتزاز
    _shakeAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // أنيميشن التلاشي
    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  sin(_controller.value * 2 * pi) * 10, // حركة اهتزازية
                ),
                child: Transform.rotate(
                  angle: _shakeAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Center(
                      child: widget.imagePath != null
                          ? Image.asset(
                              widget.imagePath!,
                              width: widget.size * 0.7,
                              height: widget.size * 0.7,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              Icons.shopping_cart,
                              size: widget.size * 0.5,
                              color: widget.color,
                            ),
                    ),
                  ),
                ),
              );
            },
          ),

          // نقاط التحميل التقليدية كخلفية
          _PulseDotsLoading(color: widget.color.withOpacity(0.5), size: 30),
        ],
      ),
    );
  }
}

class _PulseDotsLoading extends StatefulWidget {
  final Color color;
  final double size;

  const _PulseDotsLoading({required this.color, required this.size});

  @override
  __PulseDotsLoadingState createState() => __PulseDotsLoadingState();
}

class __PulseDotsLoadingState extends State<_PulseDotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ScaleTransition(
            scale: DelayTween(
              begin: 0.3,
              end: 1.0,
              delay: index * 0.2,
            ).animate(_controller),
            child: Container(
              width: widget.size / 4,
              height: widget.size / 4,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({required double begin, required double end, required this.delay})
    : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((sin((t - delay) * 2 * 3.14) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}





///////////////
///// استخدام الصورة الافتراضية (أيقونة التسوق)
// LoadingViewWidget(type: LoadingType.imageShake)

// // استخدام صورة مخصصة مع الاهتزاز
// LoadingViewWidget(
//   type: LoadingType.imageShake,
//   imagePath: 'assets/images/logo.png', // مسار صورتك
//   size: 120, // حجم الصورة
//   color: Colors.blue, // اللون
// )

// // استخدام النقاط النابضة فقط (كما في السابق)
// LoadingViewWidget(type: LoadingType.pulseDots)