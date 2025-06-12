// lib/widgets/app_option_card.dart

import 'package:flutter/material.dart';
import 'package:easyride/constants/app_colors.dart' as AppColors;

class AppOptionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap; // The callback from HomeScreen
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

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Expanded(
      child: Material( // Wrap with Material to ensure InkWell behaves correctly
        color: Colors.transparent, // Make Material transparent
        child: InkWell( // <--- InkWell is now the primary tap handler
          onTap: () {
            // This is the main tap action. The animation should run first.
            _controller.reverse().then((_) { // Scale down
              _controller.forward(); // Scale back up
              widget.onTap(); // Execute the original onTap from HomeScreen
            });
          },
          onTapDown: (_) {
            _controller.reverse(); // Immediate scale down on tap
          },
          onTapCancel: () {
            _controller.forward(); // Scale back up if tap is cancelled
          },
          onTapUp: (_) {
            // Animation and onTap are handled by the main onTap callback,
            // so we don't need to do anything extra here.
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.primaryGreen.withOpacity(0.3),
          highlightColor: Colors.transparent, // Let animation handle highlight
          child: ScaleTransition( // Apply scale animation
            scale: _scaleAnimation,
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
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
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
                        color: Colors.black.withOpacity(0.15),
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