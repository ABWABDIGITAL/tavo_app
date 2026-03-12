import 'package:flutter/material.dart';
import 'package:tavo/feature/onboarding/data/models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      data.image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
