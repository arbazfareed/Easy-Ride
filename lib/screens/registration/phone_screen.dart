// lib/screens/registration/phone_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easyride/cubits/registration/registration_cubit.dart';
import 'package:easyride/cubits/registration/registration_state.dart';
import 'package:easyride/constants/app_colors.dart';
import 'package:easyride/constants/app_colors.dart'; // This is the correct way

import '../../constants/app_colors.dart' as AppColors; // Correct import

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  final RegExp _pkPhoneRegExp = RegExp(r'^(?:\+?92|0)?\d{10}$');

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
      backgroundColor: AppColors.backgroundColor, // CORRECTED: Use AppColors.backgroundColor
      body: SafeArea(
        child: BlocListener<RegistrationCubit, RegistrationState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.errorRed, // CORRECTED: Use AppColors.errorRed
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
                          Text(
                            "What's your phone number?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 32 : 42,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen, // CORRECTED: Use AppColors.primaryGreen
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 40 : 60),
                          _buildTextField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            labelText: 'Phone Number',
                            hintText: '+92XXXXXXXXXX',
                            onChanged: context.read<RegistrationCubit>().updatePhone,
                            errorText: state.errorMessage?.contains("phone number") == true ? state.errorMessage : null,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => context.read<RegistrationCubit>().submitPhone(),
                          ),
                          SizedBox(height: isSmallScreen ? 40 : 60),
                          ElevatedButton(
                            onPressed: state.isLoading ? null : () {
                              FocusScope.of(context).unfocus();
                              context.read<RegistrationCubit>().submitPhone();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, isSmallScreen ? 50 : 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: AppColors.primaryGreen, // CORRECTED: Use AppColors.primaryGreen
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontSize: isSmallScreen ? 18 : 22,
                                fontWeight: FontWeight.bold,
                              ),
                              elevation: 5,
                              shadowColor: AppColors.primaryGreen.withOpacity(0.4), // CORRECTED
                            ),
                            child: state.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Next"),
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
                      icon: Icon(Icons.arrow_back, color: AppColors.primaryGreen, size: 30), // CORRECTED
                      onPressed: () {
                        FocusScope.of(context).unfocus();
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
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: AppColors.textMedium), // CORRECTED
        floatingLabelStyle: const TextStyle(color: AppColors.primaryGreen, fontSize: 18), // CORRECTED
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.lightGreen, width: 2), // CORRECTED
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2), // CORRECTED
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2), // CORRECTED
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2), // CORRECTED
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        errorText: errorText,
        errorStyle: const TextStyle(color: AppColors.errorRed, fontSize: 13), // CORRECTED
      ),
      style: TextStyle(fontSize: 18, color: AppColors.textDark), //  error line
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