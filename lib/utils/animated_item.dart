import 'package:flutter/material.dart';

/// Wraps a child in a staggered Fade + Slide-up entrance animation.
/// The animation re-fires whenever the widget's [key] changes, making it
/// suitable for use inside [AnimatedSwitcher] for cross-tab transitions.
class AnimatedItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;

  const AnimatedItem({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelay = const Duration(milliseconds: 80),
  });

  @override
  State<AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<AnimatedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _play();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0.0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  void _play() {
    final stagger = widget.baseDelay * widget.index;
    Future.delayed(stagger, () {
      if (mounted) _controller.forward(from: 0.0);
    });
  }

  /// Re-play when the parent rebuilds with a new key (e.g. tab switch).
  @override
  void didUpdateWidget(AnimatedItem old) {
    super.didUpdateWidget(old);
    if (old.key != widget.key || old.index != widget.index) {
      _controller.reset();
      _play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
