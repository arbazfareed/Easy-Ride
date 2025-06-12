// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <--- MAKE SURE THIS IS IMPORTED
import 'package:easyride/cubits/navigation_cubit.dart'; // <--- MAKE SURE THIS IS IMPORTED
import 'package:easyride/constants/app_colors.dart' as AppColors;
import 'package:easyride/widgets/app_option_card.dart';

// You can remove these direct screen imports as NavigationCubit handles routing:
// import 'package:easyride/screens/customer_screen.dart';
// import 'package:easyride/screens/driver_screen.dart';
// import 'package:lottie/lottie.dart'; // Uncomment if using Lottie

class HomeScreen extends StatefulWidget {
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
      duration: const Duration(milliseconds: 800),
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

    _headerAnimationController.forward();
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
                      FadeTransition(
                        opacity: _headerOpacityAnimation,
                        child: SlideTransition(
                          position: _headerSlideAnimation,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primaryGreen.withOpacity(0.95), AppColors.lightGreen.withOpacity(1.0)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 28 : 48),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "EasyRide",
                                  style: TextStyle(
                                    fontSize: (isSmallScreen ? 34 : 68) * textScaleFactor,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3,
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(1.5, 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 10 : 16),
                                Text(
                                  "Your Journey Starts Here",
                                  style: TextStyle(
                                    fontSize: (isSmallScreen ? 15 : 24) * textScaleFactor,
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
                                SizedBox(height: isSmallScreen ? 20 : 32),
                                /*
                                Lottie.asset(
                                  'assets/animations/car_driving.json',
                                  height: isSmallScreen ? 65 : 200,
                                  fit: BoxFit.contain,
                                  repeat: true,
                                  animate: true,
                                ),
                                */
                                Icon(
                                  Icons.drive_eta_rounded,
                                  size: isSmallScreen ? 65 : 150,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 6,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isSmallScreen ? 10 : 16),
                                Text(
                                  "Connecting Passengers & Drivers",
                                  style: TextStyle(
                                    fontSize: (isSmallScreen ? 12 : 18) * textScaleFactor,
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

                      SizedBox(height: isSmallScreen ? 32 : 56),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "I want to...",
                              style: TextStyle(
                                fontSize: (isSmallScreen ? 26 : 38) * textScaleFactor,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textDark,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isSmallScreen ? 24 : 40),
                            Row(
                              children: [
                                AppOptionCard(
                                  icon: Icons.person_outline,
                                  label: "Be a Customer",
                                  onTap: () {
                                    print('DEBUG: Tapped "Be a Customer" card!'); // <--- ADD THIS LINE
                                    // <--- THIS IS THE CHANGE YOU NEED TO MAKE
                                    context.read<NavigationCubit>().navigateToCustomerScreen();
                                  },
                                  isSmallScreen: isSmallScreen,
                                ),
                                const SizedBox(width: 24),
                                AppOptionCard(
                                  icon: Icons.drive_eta,
                                  label: "Be a Driver",
                                  onTap: () {
                                    print('DEBUG: Tapped "Be a Driver" card!'); // <--- ADD THIS LINE
                                    // <--- THIS IS THE CHANGE YOU NEED TO MAKE
                                    context.read<NavigationCubit>().navigateToDriverScreen();
                                  },
                                  isSmallScreen: isSmallScreen,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 24 : 40),
                      Expanded(
                        child: Container(),
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