// lib/screens/registration/email_password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/cubits/registration/registration_cubit.dart';
import 'package:easyride/cubits/registration/registration_state.dart';
import 'package:easyride/constants/app_colors.dart' as AppColors; // Using AppColors prefix

class EmailPasswordScreen extends StatefulWidget {
  const EmailPasswordScreen({super.key});

  @override
  State<EmailPasswordScreen> createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Consistent background color
      body: SafeArea(
        child: BlocListener<RegistrationCubit, RegistrationState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.errorRed,
                ),
              );
            }
            // IMPORTANT: ADDED SNACKBAR FOR EMAIL VERIFICATION SUCCESS
            if (state.currentStep == RegistrationStep.completed && state.errorMessage == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration successful! Please check your email for a verification link.'),
                  backgroundColor: Colors.green, // A success color
                  duration: Duration(seconds: 5), // Give user time to read
                ),
              );
              // Navigation to home is still handled by RegistrationFlowContainer after this message
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
                          SizedBox(height: isSmallScreen ? 40 : 60),
                          _buildTextField( // Reusing the helper from NameScreen
                            controller: _emailController,
                            labelText: 'Email Address',
                            hintText: 'example@gmail.com',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: context.read<RegistrationCubit>().updateEmail,
                            errorText: state.errorMessage?.toLowerCase().contains("email") == true ? state.errorMessage : null,
                            focusNode: FocusNode(), // Provide a focus node
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 24),
                          _buildTextField( // Reusing the helper from NameScreen
                            controller: _passwordController,
                            labelText: 'Password',
                            hintText: 'At least 6 characters',
                            obscureText: !_isPasswordVisible,
                            onChanged: context.read<RegistrationCubit>().updatePassword,
                            errorText: state.errorMessage?.toLowerCase().contains("password") == true || state.errorMessage?.toLowerCase().contains("weak-password") == true ? state.errorMessage : null,
                            focusNode: FocusNode(), // Provide a focus node
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
                            onFieldSubmitted: (_) => context.read<RegistrationCubit>().submitEmailAndPassword(),
                          ),
                          SizedBox(height: isSmallScreen ? 40 : 60),
                          ElevatedButton(
                            onPressed: state.isLoading ? null : () {
                              FocusScope.of(context).unfocus(); // Dismiss keyboard
                              context.read<RegistrationCubit>().submitEmailAndPassword();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, isSmallScreen ? 50 : 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontSize: isSmallScreen ? 18 : 22,
                                fontWeight: FontWeight.bold,
                              ),
                              elevation: 5,
                              shadowColor: AppColors.primaryGreen.withOpacity(0.4),
                            ),
                            child: state.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Register"),
                          ),
                          if (!isSmallScreen) SizedBox(height: size.height * 0.1),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen, size: 30),
                      onPressed: () {
                        FocusScope.of(context).unfocus(); // Dismiss keyboard
                        context.read<RegistrationCubit>().goBack();
                      },
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

  // Helper method for consistent TextField styling (extracted to a shared place if used across many screens)
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    required ValueChanged<String> onChanged,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
    FocusNode? focusNode, // Added focusNode parameter
    FocusNode? nextFocusNode,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode, // Apply focus node
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: AppColors.textMedium),
        floatingLabelStyle: const TextStyle(color: AppColors.primaryGreen, fontSize: 18),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.lightGreen, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        errorText: errorText,
        errorStyle: const TextStyle(color: AppColors.errorRed, fontSize: 13),
        suffixIcon: suffixIcon, // Apply suffix icon
      ),
      style: const TextStyle(fontSize: 18, color: AppColors.textDark),
      onChanged: onChanged,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onSubmitted: onFieldSubmitted ??
              (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
    );
  }
}