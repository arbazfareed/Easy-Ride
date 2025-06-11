// lib/screens/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/onboarding_cubit.dart';
import '../../models/onboarding_content.dart';
import '../../cubits/navigation_cubit.dart';
// CORRECTED: Import app_colors with alias
import 'package:easyride/constants/app_colors.dart' as AppColors;

// REMOVED: Local color constants are now in app_colors.dart
// const Color primaryGreen = Color(0xFF4CAF50);
// const Color lightGreen = Color(0xFF81C784);
// const Color textMedium = Color(0xFF616161);
// const Color backgroundColor = Colors.white;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // UPDATED: This method now instructs NavigationCubit to navigate to the LOGIN screen.
  void _navigateToLoginScreen() {
    context.read<NavigationCubit>().navigateToLogin();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final isTablet = size.width > 600;

    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor, // Use AppColors prefix
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // PageView
                  Expanded(
                    flex: isSmallScreen ? 3 : 2,
                    child: BlocBuilder<OnboardingCubit, int>(
                      builder: (context, currentPage) {
                        return PageView.builder(
                          controller: _pageController,
                          itemCount: onboardingPages.length,
                          onPageChanged: (index) {
                            context.read<OnboardingCubit>().updatePage(index);
                          },
                          itemBuilder: (context, index) {
                            final content = onboardingPages[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 80 : 24,
                                vertical: isSmallScreen ? 16 : 32,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        content.title,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 32 : 42,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryGreen, // Use AppColors prefix
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      SizedBox(height: isSmallScreen ? 16 : 24),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallScreen ? 0 : 40,
                                        ),
                                        child: Text(
                                          content.subtitle,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 17 : 20,
                                            color: AppColors.textMedium, // Use AppColors prefix
                                            height: 1.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxHeight: size.height * 0.5,
                                        maxWidth: size.width * 0.9,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          content.image,
                                          fit: BoxFit.contain,
                                          semanticLabel: 'Onboarding image: ${content.title}',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Bottom Section
                  Expanded(
                    flex: isSmallScreen ? 2 : 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: isSmallScreen ? 30 : 50,
                        left: isTablet ? 80 : 30,
                        right: isTablet ? 80 : 30,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Dots indicator
                          BlocBuilder<OnboardingCubit, int>(
                            builder: (context, currentPage) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  onboardingPages.length,
                                      (index) => GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeOutCubic,
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(horizontal: 8),
                                      height: 10,
                                      width: currentPage == index ? 30 : 10,
                                      decoration: BoxDecoration(
                                        color: currentPage == index
                                            ? AppColors.primaryGreen // Use AppColors prefix
                                            : AppColors.lightGreen.withOpacity(0.7), // Use AppColors prefix
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: isSmallScreen ? 30 : 40),

                          // Continue / Get Started Button
                          BlocBuilder<OnboardingCubit, int>(
                            builder: (context, currentPage) {
                              final isLastPage = currentPage == onboardingPages.length - 1;
                              return ElevatedButton(
                                onPressed: () {
                                  if (isLastPage) {
                                    _navigateToLoginScreen(); // Use the updated method to go to Login
                                  } else {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeOutCubic,
                                    );
                                    context.read<OnboardingCubit>().nextPage();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, isSmallScreen ? 50 : 60),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor: AppColors.primaryGreen, // Use AppColors prefix
                                  foregroundColor: Colors.white,
                                  textStyle: TextStyle(
                                    fontSize: isSmallScreen ? 18 : 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  elevation: 5,
                                  shadowColor: AppColors.primaryGreen.withOpacity(0.4), // Use AppColors prefix
                                ),
                                child: Text(isLastPage ? 'Get Started' : 'Continue'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Skip button (top-right)
              Positioned(
                top: 16,
                right: 20,
                child: TextButton(
                  onPressed: _navigateToLoginScreen, // Use the updated method to go to Login
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryGreen, // Use AppColors prefix
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}