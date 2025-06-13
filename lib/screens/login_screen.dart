// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/constants/app_colors.dart' as AppColors;
import 'package:easyride/cubits/navigation_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      print('Attempting to sign in with: ${_emailController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sign in successful!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        context.read<NavigationCubit>().navigateToHome();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final isSmallScreen = size.height < 700;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? size.width * 0.1 : 24,
                  vertical: isSmallScreen ? 16 : 32,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Image, Header Icon and Subtitle ---
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/s1.jpeg',
                              height: isSmallScreen ? 120 : 180,
                              width: isSmallScreen ? 120 : 180,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported_outlined,
                                  size: isSmallScreen ? 100 : 150,
                                  color: AppColors.primaryGreen.withOpacity(0.6),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          Icon(
                            Icons.login_outlined,
                            size: isSmallScreen ? 60 : 80,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(height: 16),
                          // Enhanced responsiveness for "Welcome Back!" text
                          FittedBox( // Ensures text fits horizontally, scaling if needed
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Welcome Back!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: (isSmallScreen ? 32 : 42) * textScaleFactor,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Enhanced responsiveness for subtitle text
                          FittedBox( // Ensures text fits horizontally, scaling if needed
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Sign in to continue your journey.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: (isSmallScreen ? 16 : 18) * textScaleFactor,
                                color: AppColors.textMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 40 : 60),

                      // --- Email Address Field ---
                      _buildTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        labelText: 'Email Address',
                        hintText: 'example@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.lightGreen),
                        nextFocusNode: _passwordFocusNode,
                      ),
                      SizedBox(height: isSmallScreen ? 16 : 24),

                      // --- Password Field ---
                      _buildTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        labelText: 'Password',
                        hintText: 'Your password',
                        obscureText: !_isPasswordVisible,
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.lightGreen),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.textMedium,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                      SizedBox(height: isSmallScreen ? 40 : 60),

                      // --- Sign In Button ---
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: isSmallScreen ? 50 : 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _handleLogin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            textStyle: TextStyle(
                              fontSize: (isSmallScreen ? 18 : 22) * textScaleFactor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 30),

                      // --- "Don't have an account?" link ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: (isSmallScreen ? 14 : 16) * textScaleFactor,
                              color: AppColors.textMedium,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              context.read<NavigationCubit>().navigateToRegistration();
                            },
                            child: Text(
                              "Register Here",
                              style: TextStyle(
                                fontSize: (isSmallScreen ? 14 : 16) * textScaleFactor,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (!isSmallScreen) SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),

            // --- Back Button ---
            Positioned(
              top: 16,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  context.read<NavigationCubit>().navigateToOnboarding();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.primaryGreen,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper method for consistent TextField styling ---
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    String? hintText,
    required ValueChanged<String> onChanged,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
    FocusNode? nextFocusNode,
    ValueChanged<String>? onFieldSubmitted,
    Widget? prefixIcon,
  }) {
    // You might also want to apply textScaleFactor to the text style within the InputDecoration
    // and the TextFormField itself for ultimate consistency, though the current 18px is fairly standard.
    final textStyle = TextStyle(fontSize: 18 * MediaQuery.of(context).textScaleFactor, color: AppColors.textDark);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted ??
              (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: AppColors.textMedium),
        floatingLabelStyle: const TextStyle(color: AppColors.primaryGreen, fontSize: 18),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGreen, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.errorRed, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        errorStyle: const TextStyle(color: AppColors.errorRed, fontSize: 13),
        suffixIcon: suffixIcon,
      ),
      style: textStyle, // Apply the scaled text style
    );
  }
}