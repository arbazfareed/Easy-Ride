// lib/screens/registration/name_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/cubits/registration/registration_cubit.dart';
import 'package:easyride/cubits/registration/registration_state.dart';
// Corrected import to use the 'as AppColors' alias
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Using Form for better validation integration

  // Added FocusNodes for better keyboard management and UI response
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
    _firstNameFocusNode.dispose(); // Dispose focus nodes
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Use AppColors prefix
      body: SafeArea(
        child: BlocListener<RegistrationCubit, RegistrationState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.errorRed, // Use AppColors prefix
                  behavior: SnackBarBehavior.floating, // Makes snackbar float above bottom
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              // Consider adding a cubit method to clear the error after display
              // For example: context.read<RegistrationCubit>().clearErrorMessage();
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
                      child: Form( // Wrap with Form widget for validation
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header with Image and Text
                            Column(
                              children: [
                                // Image
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
                                        Icons.person_outline,
                                        size: isSmallScreen ? 100 : 150,
                                        color: AppColors.primaryGreen.withOpacity(0.6),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24), // More space below image
                                Text(
                                  "What's your name?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 28 : 36,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreen, // Use AppColors prefix
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8), // Little space before subtitle
                                Text(
                                  "Tell us a bit about yourself",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 18,
                                    color: AppColors.textMedium, // Use AppColors prefix
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isSmallScreen ? 32 : 48),

                            // First Name Field with improved styling
                            _buildTextField(
                              controller: _firstNameController,
                              focusNode: _firstNameFocusNode,
                              labelText: 'First Name',
                              hintText: 'e.g., John',
                              onChanged: context.read<RegistrationCubit>().updateFirstName,
                              // Validator for immediate feedback on empty field
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              nextFocusNode: _lastNameFocusNode, // Move focus to next field
                              prefixIcon: Icon(Icons.person_outline, color: AppColors.lightGreen), // Icon
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 24),

                            // Last Name Field with improved styling
                            _buildTextField(
                              controller: _lastNameController,
                              focusNode: _lastNameFocusNode,
                              labelText: 'Last Name',
                              hintText: 'e.g., Doe',
                              onChanged: context.read<RegistrationCubit>().updateLastName,
                              // Validator for immediate feedback on empty field
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done, // Done action on last field
                              onFieldSubmitted: (_) {
                                // Trigger submit when 'Done' is pressed on keyboard
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                                  context.read<RegistrationCubit>().submitName();
                                }
                              },
                              prefixIcon: Icon(Icons.person_outline, color: AppColors.lightGreen), // Icon
                            ),
                            SizedBox(height: isSmallScreen ? 32 : 48),

                            // Improved Next Button with animation and shadow
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: isSmallScreen ? 50 : 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryGreen.withOpacity(0.3), // Use AppColors prefix
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: state.isLoading ? null : () {
                                  // Validate all fields in the Form
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus(); // Dismiss keyboard
                                    context.read<RegistrationCubit>().submitName();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryGreen, // Use AppColors prefix
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.zero, // Remove default padding as container gives space
                                  elevation: 0, // Elevation handled by BoxDecoration shadow
                                  textStyle: TextStyle(
                                    fontSize: isSmallScreen ? 18 : 20,
                                    fontWeight: FontWeight.w600,
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
                                  "Continue",
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
                  ),

                  // Improved Back Button
                  Positioned(
                    top: 16,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus(); // Dismiss keyboard
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
                          color: AppColors.primaryGreen, // Use AppColors prefix
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
  // (Moved here for easy access, but can be extracted to widgets/shared_text_field.dart)
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    String? hintText,
    required ValueChanged<String> onChanged,
    FormFieldValidator<String>? validator, // Changed to FormFieldValidator
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
    FocusNode? nextFocusNode,
    ValueChanged<String>? onFieldSubmitted,
    Widget? prefixIcon, // Added prefixIcon
  }) {
    return TextFormField( // Changed to TextFormField for validator
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator, // Apply validator
      onFieldSubmitted: onFieldSubmitted ??
              (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus(); // Dismiss keyboard if no next field
            }
          },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: AppColors.textMedium), // Use AppColors prefix
        floatingLabelStyle: const TextStyle(color: AppColors.primaryGreen, fontSize: 18), // Use AppColors prefix
        prefixIcon: prefixIcon, // Apply prefix icon
        filled: true,
        fillColor: Colors.white, // Changed from opacity 0.9 to solid white for contrast
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGreen, width: 1.5), // Slightly thinner border when not focused
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 2), // Use AppColors prefix
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.errorRed, width: 1.5), // Use AppColors prefix
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.errorRed, width: 2), // Use AppColors prefix
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Slightly adjusted padding
        errorStyle: const TextStyle(color: AppColors.errorRed, fontSize: 13), // Use AppColors prefix
      ),
      style: const TextStyle(fontSize: 16, color: AppColors.textDark), // Use AppColors prefix and slightly smaller font
    );
  }
}