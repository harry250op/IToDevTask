import 'dart:async';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<Widget> items;
  final bool autoPlay;
  final Duration interval;
  final bool loop;
  final double viewportFraction;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showIndicators;
  final Color activeDotColor;
  final Color inactiveDotColor;
  final bool enableScaleEffect;
  final bool enableParallax;
  final double scaleFactor;
  final double parallaxOffset;
  final Function(int)? onPageChanged;

  const Carousel({
    super.key,
    required this.items,
    this.autoPlay = false,
    this.interval = const Duration(seconds: 3),
    this.loop = true,
    this.viewportFraction = 0.9,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeInOut,
    this.showIndicators = true,
    this.activeDotColor = Colors.blueAccent,
    this.inactiveDotColor = Colors.grey,
    this.enableScaleEffect = true,
    this.enableParallax = true,
    this.scaleFactor = 0.2,
    this.parallaxOffset = 50,
    this.onPageChanged,
  });

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late final PageController _controller;
  int _currentIndex = 0;
  Timer? _timer;
  final List<GlobalKey> _itemKeys = [];
  double _currentHeight = 200;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: widget.viewportFraction);
    _itemKeys.addAll(List.generate(widget.items.length, (_) => GlobalKey()));
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeight());
    if (widget.autoPlay) _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.interval, (_) {
      if (_controller.hasClients) {
        int next = _currentIndex + 1;
        if (next >= widget.items.length) {
          if (!widget.loop) return;
          next = 0;
        }
        _controller.animateToPage(
          next,
          duration: widget.animationDuration,
          curve: widget.animationCurve,
        );
      }
    });
  }

  void _updateHeight() {
    final context = _itemKeys[_currentIndex].currentContext;
    if (context == null) return;
    final newHeight = context.size?.height ?? _currentHeight;
    if (newHeight != _currentHeight) {
      setState(() => _currentHeight = newHeight);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _currentHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              widget.onPageChanged?.call(index);
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _updateHeight(),
              );
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double value = 0.0;
                  double offset = 0.0;
                  if (_controller.position.haveDimensions) {
                    value = (_controller.page! - index);
                    offset = value * widget.parallaxOffset;
                  }

                  double scale = widget.enableScaleEffect
                      ? (1 - (value.abs() * widget.scaleFactor)).clamp(0.8, 1.0)
                      : 1.0;

                  double translation = widget.enableParallax ? -offset : 0.0;

                  return Transform.translate(
                    offset: Offset(translation, 0),
                    child: Transform.scale(
                      scale: scale,
                      child: Container(key: _itemKeys[index], child: child),
                    ),
                  );
                },
                child: Semantics(
                  label: 'Carousel ${index + 1} element',
                  child: widget.items[index],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        if (widget.showIndicators)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.items.length, (index) {
              bool isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? widget.activeDotColor
                      : widget.inactiveDotColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
      ],
    );
  }
}
