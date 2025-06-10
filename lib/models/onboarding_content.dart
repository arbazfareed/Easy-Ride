// lib/models/onboarding_content.dart

// No need for 'package:flutter/material.dart' unless OnboardingContent itself
// used Flutter-specific types like Color. It doesn't, so we can remove it.
// import 'package:flutter/material.dart';

class OnboardingContent {
  final String title;
  final String subtitle;
  final String image;

  const OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

const List<OnboardingContent> onboardingPages = [
  OnboardingContent(
    title: "Easy Ride",
    subtitle: "Your ride, just a tap away",
    image: "assets/images/im1.png",
  ),
  OnboardingContent(
    title: "Easy Ride",
    subtitle: "Reliable drivers for your daily commute",
    image: "assets/images/im2.png",
  ),
  OnboardingContent(
    title: "Easy Ride",
    subtitle: "Safe and comfortable journeys always",
    image: "assets/images/im3.png",
  ),
];
