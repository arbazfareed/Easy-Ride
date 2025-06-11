// lib/screens/registration/email_password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/cubits/registration/registration_cubit.dart';
import 'package:easyride/cubits/registration/registration_state.dart';
import 'package:easyride/constants/app_colors.dart' as AppColors;
import 'package:easyride/screens/login_screen.dart'; // Assuming you have a LoginScreen

class EmailPasswordScreen extends StatefulWidget {
  const EmailPasswordScreen({super.key});

  @override
  State<EmailPasswordScreen> createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final registrationState = context.read<RegistrationCubit>().state;
    _emailController.text = registrationState.email;
    _passwordController.text = registrationState.password;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocListener<RegistrationCubit, RegistrationState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.errorRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );

              // NEW LOGIC: If email is already in use, navigate to LoginScreen
              if (state.errorMessage?.toLowerCase().contains("email is already in use") == true) {
                Future.delayed(const Duration(seconds: 3), () { // Short delay to let snackbar be seen
                  // Navigate to LoginScreen and replace the current stack
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                  // Optionally, clear the error message from the cubit after navigation
                  // context.read<RegistrationCubit>().clearErrorMessage(); // You'd need to add this method to your cubit
                });
              }
            }
            // IMPORTANT: SNACKBAR FOR EMAIL VERIFICATION SUCCESS (when *new* registration completes)
            if (state.currentStep == RegistrationStep.completed && state.errorMessage == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Registration successful! Please check your email for a verification link.'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 5),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              // The RegistrationFlowContainer should handle the final navigation to LoginScreen
              // (which we updated in the previous step). This listener only shows the snackbar.
            }
          },
          child: BlocBuilder<RegistrationCubit, RegistrationState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 80 : 24,
                        vertical: isSmallScreen ? 16 : 32,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- User Image and Header Section ---
                          Column(
                            children: [
                              ClipRRect( // Rounded corners for the image
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/images/s1.jpeg', // Assuming s1.jpeg is appropriate here too
                                  height: isSmallScreen ? 100 : 150, // Adjust height
                                  width: isSmallScreen ? 100 : 150,  // Keep it square or adjust
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person_add_alt_1_outlined, // Fallback icon
                                      size: isSmallScreen ? 80 : 120,
                                      color: AppColors.primaryGreen.withOpacity(0.6),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24), // Space between image and icon/text

                              Text(
                                "Create your Account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 32 : 42,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Sign up to start your journey with EasyRide!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  color: AppColors.textMedium,
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
                            onChanged: context.read<RegistrationCubit>().updateEmail,
                            errorText: state.errorMessage?.toLowerCase().contains("email") == true ? state.errorMessage : null,
                            prefixIcon: Icon(Icons.email_outlined, color: AppColors.lightGreen),
                            nextFocusNode: _passwordFocusNode,
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 24),

                          // --- Password Field ---
                          _buildTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            labelText: 'Password',
                            hintText: 'At least 6 characters',
                            obscureText: !_isPasswordVisible,
                            onChanged: context.read<RegistrationCubit>().updatePassword,
                            errorText: state.errorMessage?.toLowerCase().contains("password") == true || state.errorMessage?.toLowerCase().contains("weak-password") == true ? state.errorMessage : null,
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
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                              context.read<RegistrationCubit>().submitEmailAndPassword();
                            },
                          ),
                          SizedBox(height: isSmallScreen ? 40 : 60),

                          // --- Register Button with consistent styling ---
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
                              onPressed: state.isLoading ? null : () {
                                FocusScope.of(context).unfocus();
                                context.read<RegistrationCubit>().submitEmailAndPassword();
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
                                  fontSize: isSmallScreen ? 18 : 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: state.isLoading
                                  ? SizedBox(
                                width: isSmallScreen ? 24 : 28,
                                height: isSmallScreen ? 24 : 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                "Register",
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 20 : 30),

                          // --- "Already have an account?" link ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: AppColors.textMedium,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
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

                  // --- Improved Back Button ---
                  Positioned(
                    top: 16,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        context.read<RegistrationCubit>().goBack();
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
              );
            },
          ),
        ),
      ),
    );
  }

  // --- Helper method for consistent TextField styling ---
  // (You might consider moving this to a central `widgets/common_ui.dart` or similar)
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    String? hintText,
    required ValueChanged<String> onChanged,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
    FocusNode? nextFocusNode,
    ValueChanged<String>? onFieldSubmitted,
    Widget? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onFieldSubmitted ??
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
        errorText: errorText,
        errorStyle: const TextStyle(color: AppColors.errorRed, fontSize: 13),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(fontSize: 18, color: AppColors.textDark),
    );
  }
}