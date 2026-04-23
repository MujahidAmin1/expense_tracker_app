import 'package:flutter/material.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';

class ExpandableFab extends StatefulWidget {
  final VoidCallback? onManualEntry;
  final VoidCallback? onScanReceipt;
  final VoidCallback? onAttachFile;

  const ExpandableFab({
    super.key,
    this.onManualEntry,
    this.onScanReceipt,
    this.onAttachFile,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFAB() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop overlay
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleFAB,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),

        // FAB row — bottom right
        Positioned(
          right: 16,
          bottom: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Mini action buttons (appear to the left of the main FAB)
              if (_isExpanded) ...[
                _buildMiniActionButton(
                  icon: Icons.edit_outlined,
                  index: 0,
                  onTap: () {
                    _toggleFAB();
                    widget.onManualEntry?.call();
                  },
                ),
                const SizedBox(width: 10),
                _buildMiniActionButton(
                  icon: Icons.document_scanner_outlined,
                  index: 1,
                  onTap: () {
                    _toggleFAB();
                    widget.onScanReceipt?.call();
                  },
                ),
                const SizedBox(width: 10),
                _buildMiniActionButton(
                  icon: Icons.attach_file_outlined,
                  index: 2,
                  onTap: () {
                    _toggleFAB();
                    widget.onAttachFile?.call();
                  },
                ),
                const SizedBox(width: 10),
              ],

              // Main FAB
              FloatingActionButton(
                onPressed: _toggleFAB,
                backgroundColor: AppColors.primaryBlue,
                elevation: 4,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.add,
                    key: ValueKey(_isExpanded),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniActionButton({
    required IconData icon,
    required int index,
    required VoidCallback onTap,
  }) {
    // Stagger each button's animation slightly
    final staggeredAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        index * 0.1,
        0.6 + index * 0.1,
        curve: Curves.easeOutBack,
      ),
    );

    return ScaleTransition(
      scale: staggeredAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            elevation: 3,
            shadowColor: Colors.black26,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14),
              child: Icon(
                icon,
                color: AppColors.primaryBlue,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}