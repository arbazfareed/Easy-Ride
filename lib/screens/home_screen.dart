// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
// Remove unused imports if you're not using them:
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easyride/cubits/navigation_cubit.dart';
import 'package:easyride/constants/app_colors.dart' as AppColors;
import 'package:easyride/widgets/app_option_card.dart';

// import 'package:lottie/lottie.dart'; // Uncomment if using Lottie

class HomeScreen extends StatefulWidget { // Changed to StatefulWidget for header animation
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late Animation<double> _headerOpacityAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Longer duration for header fade/slide
    );

    _headerOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeIn,
      ),
    );

    _headerSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _headerAnimationController.forward(); // Start animation when screen loads
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final bool isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- Upper Part: Car Moving on Road UI with Animation ---
                      FadeTransition( // Fade animation for header content
                        opacity: _headerOpacityAnimation,
                        child: SlideTransition( // Slide animation for header content
                          position: _headerSlideAnimation,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primaryGreen.withOpacity(0.95), AppColors.lightGreen.withOpacity(1.0)], // Slightly richer gradient
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(25), // Slightly more rounded header bottom
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15), // Slightly more prominent shadow
                                  blurRadius: 20, // Increased blur for softer look
                                  spreadRadius: 5,
                                  offset: const Offset(0, 10), // More offset for depth
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 28 : 48), // Increased padding for more breathing room
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "EasyRide",
                                  style: TextStyle(
                                    fontSize: (isSmallScreen ? 34 : 68) * textScaleFactor, // Slightly larger font
                                    fontWeight: FontWeight.w900, // Even bolder
                                    color: Colors.white,
                                    letterSpacing: 1.5, // Increased letter spacing
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3, // Stronger shadow
                                        color: Colors.black.withOpacity(0.3), // Darker shadow
                                        offset: const Offset(1.5, 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 10 : 16), // Adjusted spacing
                                Text(
                                  "Your Journey Starts Here",
                                  style: TextStyle(
                                    fontSize: (isSmallScreen ? 15 : 24) * textScaleFactor, // Slightly larger font
                                    color: Colors.white.withOpacity(0.95),
                                    fontStyle: FontStyle.italic,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2.5,
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(1.2, 1.2),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 20 : 32), // Adjusted spacing
                                /*
                                // Lottie Animation Placeholder - Uncomment if you have the asset
                                Lottie.asset(
                                  'assets/animations/car_driving.json',
                                  height: isSmallScreen ? 65 : 200, // Adjusted Lottie height
                                  fit: BoxFit.contain,
                                  repeat: true,
                                  animate: true,
                                ),
                                */
                                Icon(
                                  Icons.drive_eta_rounded,
                                  size: isSmallScreen ? 65 : 150, // Slightly larger icon
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 6, // Stronger icon shadow
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isSmallScreen ? 10 : 16), // Adjusted spacing
                                Text(
                                  "Connecting Passengers & Drivers",
                                  style: TextStyle(
                                    fontSize: (isSmallScreen ? 12 : 18) * textScaleFactor, // Slightly larger font
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // --- Spacer between sections ---
                      SizedBox(height: isSmallScreen ? 32 : 56), // More generous spacing

                      // --- Lower Part: Customer and Driver Options ---
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08), // Increased horizontal padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "I want to...",
                              style: TextStyle(
                                fontSize: (isSmallScreen ? 26 : 38) * textScaleFactor, // Slightly larger font
                                fontWeight: FontWeight.w900, // Even bolder
                                color: AppColors.textDark,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isSmallScreen ? 24 : 40), // Adjusted spacing
                            Row(
                              children: [
                                AppOptionCard(
                                  icon: Icons.person_outline,
                                  label: "Be a Customer",
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Customer option selected!"))
                                    );
                                  },
                                  isSmallScreen: isSmallScreen,
                                ),
                                const SizedBox(width: 24), // Increased horizontal spacing between cards
                                AppOptionCard(
                                  icon: Icons.drive_eta,
                                  label: "Be a Driver",
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Driver option selected!"))
                                    );
                                  },
                                  isSmallScreen: isSmallScreen,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // --- Bottom Spacer ---
                      SizedBox(height: isSmallScreen ? 24 : 40), // More generous bottom spacing
                      Expanded(
                        child: Container(), // Fills remaining space
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}