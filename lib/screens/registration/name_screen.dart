import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/cubits/registration/registration_cubit.dart';
import 'package:easyride/cubits/registration/registration_state.dart';
import 'package:easyride/constants/app_colors.dart';
import '../../cubits/navigation_cubit.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocListener<RegistrationCubit, RegistrationState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: errorRed,
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Improved header with icon
                            Column(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: isSmallScreen ? 48 : 60,
                                  color: primaryGreen,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "What's your name?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 28 : 36,
                                    fontWeight: FontWeight.bold,
                                    color: primaryGreen,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isSmallScreen ? 32 : 48),

                            // First Name Field with improved styling
                            TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(color: textMedium),
                                hintText: 'Enter your first name',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Icon(Icons.person, color: lightGreen),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightGreen, width: 1.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreen, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: isSmallScreen ? 14 : 18,
                                ),
                                errorStyle: TextStyle(color: errorRed),
                              ),
                              style: TextStyle(fontSize: 16),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              onChanged: context.read<RegistrationCubit>().updateFirstName,
                              textCapitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 24),

                            // Last Name Field with improved styling
                            TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(color: textMedium),
                                hintText: 'Enter your last name',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Icon(Icons.person, color: lightGreen),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightGreen, width: 1.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreen, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: isSmallScreen ? 14 : 18,
                                ),
                                errorStyle: TextStyle(color: errorRed),
                              ),
                              style: TextStyle(fontSize: 16),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              onChanged: context.read<RegistrationCubit>().updateLastName,
                              textCapitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: isSmallScreen ? 32 : 48),

                            // Improved Next Button with animation
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: isSmallScreen ? 50 : 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryGreen.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: state.isLoading ? null : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<RegistrationCubit>().submitName();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
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
                                    : Text(
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
                          color: primaryGreen,
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
}