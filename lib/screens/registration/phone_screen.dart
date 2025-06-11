// lib/screens/registration/phone_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/cubits/registration/registration_cubit.dart';
import 'package:easyride/cubits/registration/registration_state.dart';
import 'package:easyride/constants/app_colors.dart' as AppColors;

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneController.text = context.read<RegistrationCubit>().state.phone;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
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
                              // REPLACED: CircleAvatar with Image.asset for s1.jpeg
                              ClipRRect( // Rounded corners for the image
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/images/s1.jpeg',
                                  height: isSmallScreen ? 120 : 180, // Adjust height
                                  width: isSmallScreen ? 120 : 180,  // Keep it square or adjust
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback for image loading errors
                                    return Icon(
                                      Icons.phone_android_outlined, // Fallback icon
                                      size: isSmallScreen ? 100 : 150,
                                      color: AppColors.primaryGreen.withOpacity(0.6),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24), // Space between image and icon/text

                              Icon(
                                Icons.phone_android_outlined, // Kept for thematic relevance to phone
                                size: isSmallScreen ? 60 : 80,
                                color: AppColors.primaryGreen,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "What's your phone number?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 32 : 42,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                  letterSpacing: 1.5,
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: isSmallScreen ? 40 : 60), // Adjusted spacing after removed text

                          // --- Phone Number Text Field ---
                          _buildTextField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            labelText: 'Phone Number',
                            hintText: '+92XXXXXXXXXX',
                            onChanged: context.read<RegistrationCubit>().updatePhone,
                            errorText: state.errorMessage?.toLowerCase().contains("phone") == true ? state.errorMessage : null,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                              context.read<RegistrationCubit>().submitPhone();
                            },
                            prefixIcon: Icon(Icons.dialpad, color: AppColors.lightGreen),
                          ),
                          SizedBox(height: isSmallScreen ? 40 : 60),

                          // --- Next Button with consistent styling ---
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
                                context.read<RegistrationCubit>().submitPhone();
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
                                "Next",
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          if (!isSmallScreen) SizedBox(height: size.height * 0.1),
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

  // Helper method for consistent TextField styling
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    String? hintText,
    required ValueChanged<String> onChanged,
    String? errorText,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType keyboardType = TextInputType.text,
    FocusNode? nextFocusNode,
    ValueChanged<String>? onFieldSubmitted,
    Widget? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
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
      ),
      style: const TextStyle(fontSize: 18, color: AppColors.textDark),
    );
  }
}