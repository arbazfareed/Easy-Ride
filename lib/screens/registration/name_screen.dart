// lib/screens/registration/name_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/cubits/registration/registration_cubit.dart';
import 'package:easyride/cubits/registration/registration_state.dart';
import 'package:easyride/constants/app_colors.dart' as AppColors;
import '../../cubits/navigation_cubit.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final registrationState = context.read<RegistrationCubit>().state;
    _firstNameController.text = registrationState.firstName;
    _lastNameController.text = registrationState.lastName;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    // Adjusted thresholds for 'smallScreen' to make elements smaller more often
    final isVerySmallScreen = size.height < 600; // Even smaller phones
    final isSmallScreen = size.height < 720;    // Standard small phone screen
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
                        horizontal: isTablet ? size.width * 0.1 : 20, // Slightly reduced horizontal padding
                        vertical: isVerySmallScreen ? 12 : (isSmallScreen ? 16 : 24), // More aggressive vertical padding reduction
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header with Image and Text
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12), // Slightly smaller border radius
                                  child: Image.asset(
                                    'assets/images/s1.jpeg',
                                    height: isVerySmallScreen ? 100 : (isSmallScreen ? 140 : 180), // More granular image sizing
                                    width: isVerySmallScreen ? 100 : (isSmallScreen ? 140 : 180),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person_outline,
                                        size: isVerySmallScreen ? 80 : (isSmallScreen ? 120 : 150),
                                        color: AppColors.primaryGreen.withOpacity(0.6),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: isVerySmallScreen ? 16 : 20), // Smaller space below image
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "What's your name?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: (isVerySmallScreen ? 24 : (isSmallScreen ? 30 : 36)) * textScaleFactor, // More granular font sizing
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGreen,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                SizedBox(height: isVerySmallScreen ? 6 : 8), // Smaller space before subtitle
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Tell us a bit about yourself",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: (isVerySmallScreen ? 14 : (isSmallScreen ? 16 : 18)) * textScaleFactor, // More granular font sizing
                                      color: AppColors.textMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isVerySmallScreen ? 24 : (isSmallScreen ? 36 : 48)), // More granular vertical spacing

                            // First Name Field
                            _buildTextField(
                              context: context,
                              controller: _firstNameController,
                              focusNode: _firstNameFocusNode,
                              labelText: 'First Name',
                              hintText: 'e.g., John',
                              onChanged: context.read<RegistrationCubit>().updateFirstName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              nextFocusNode: _lastNameFocusNode,
                              prefixIcon: Icon(Icons.person_outline, color: AppColors.lightGreen),
                            ),
                            SizedBox(height: isVerySmallScreen ? 12 : (isSmallScreen ? 18 : 24)), // Smaller space between fields

                            // Last Name Field
                            _buildTextField(
                              context: context,
                              controller: _lastNameController,
                              focusNode: _lastNameFocusNode,
                              labelText: 'Last Name',
                              hintText: 'e.g., Doe',
                              onChanged: context.read<RegistrationCubit>().updateLastName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  context.read<RegistrationCubit>().submitName();
                                }
                              },
                              prefixIcon: Icon(Icons.person_outline, color: AppColors.lightGreen),
                            ),
                            SizedBox(height: isVerySmallScreen ? 24 : (isSmallScreen ? 36 : 48)),

                            // Continue Button
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: isVerySmallScreen ? 45 : (isSmallScreen ? 50 : 60), // Smaller button height
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
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    context.read<RegistrationCubit>().submitName();
                                  }
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
                                    fontSize: (isVerySmallScreen ? 16 : (isSmallScreen ? 18 : 20)) * textScaleFactor, // Smaller button text
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: state.isLoading
                                    ? SizedBox(
                                  width: isVerySmallScreen ? 20 : (isSmallScreen ? 24 : 28), // Smaller indicator
                                  height: isVerySmallScreen ? 20 : (isSmallScreen ? 24 : 28),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Text(
                                  "Continue",
                                  style: TextStyle(
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),

                            if (!isVerySmallScreen) SizedBox(height: size.height * 0.05), // Adjusted bottom spacing
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Back Button
                  Positioned(
                    top: 12, // Slightly higher position
                    left: 16, // Slightly more left
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        context.read<NavigationCubit>().navigateToOnboarding();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7), // Slightly smaller padding
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10), // Slightly smaller border radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5, // Smaller blur
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.primaryGreen,
                          size: 26, // Slightly smaller icon
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
  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    String? hintText,
    required ValueChanged<String> onChanged,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
    FocusNode? nextFocusNode,
    ValueChanged<String>? onFieldSubmitted,
    Widget? prefixIcon,
  }) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
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
        floatingLabelStyle: TextStyle(color: AppColors.primaryGreen,
            fontSize: 16 * textScaleFactor), // Slightly smaller floating label
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGreen, width: 1.5),
          borderRadius: BorderRadius.circular(10), // Slightly smaller border radius
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.errorRed, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Slightly smaller padding
        errorStyle: TextStyle(color: AppColors.errorRed, fontSize: 12 * textScaleFactor), // Slightly smaller error text
      ),
      style: TextStyle(fontSize: 15 * textScaleFactor, color: AppColors.textDark), // Slightly smaller input text
    );
  }
}