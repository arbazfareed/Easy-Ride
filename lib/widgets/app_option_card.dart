// lib/widgets/app_option_card.dart

import 'package:flutter/material.dart';
import 'package:easyride/constants/app_colors.dart' as AppColors;

class AppOptionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSmallScreen;

  const AppOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSmallScreen = false,
  });

  @override
  State<AppOptionCard> createState() => _AppOptionCardState();
}

class _AppOptionCardState extends State<AppOptionCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Quick animation
      lowerBound: 0.98, // Scale down slightly on tap
      upperBound: 1.0, // Original size
    );
    _scaleAnimation = Tween(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse(); // Scale down
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward(); // Scale back up
    widget.onTap(); // Execute original onTap
  }

  void _onTapCancel() {
    _controller.forward(); // Scale back up if tap is cancelled
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Expanded(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition( // Apply scale animation
          scale: _scaleAnimation,
          child: InkWell(
            onTap: () {}, // InkWell's onTap is now handled by GestureDetector for animation
            borderRadius: BorderRadius.circular(20),
            splashColor: AppColors.primaryGreen.withOpacity(0.3), // Slightly more splash
            highlightColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: widget.isSmallScreen ? 12 : 28,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12), // Slightly more prominent shadow
                    blurRadius: 16, // Softer blur
                    spreadRadius: 3, // More spread
                    offset: const Offset(0, 6), // More offset
                  ),
                ],
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: widget.isSmallScreen ? 48 : 72,
                    color: AppColors.primaryGreen,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.15), // Slightly stronger icon shadow
                      ),
                    ],
                  ),
                  SizedBox(height: widget.isSmallScreen ? 8 : 12),
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (widget.isSmallScreen ? 14 : 20) * textScaleFactor,
                      fontWeight: widget.isSmallScreen ? FontWeight.w700 : FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: widget.isSmallScreen ? 5 : 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}