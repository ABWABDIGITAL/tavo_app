import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/feature/onboarding/data/models/onboarding_model.dart';

class OnboardingData {
  static const List<OnboardingModel> pages = [
    OnboardingModel(
      image: AppAssets.onboarding1,
      title: 'احجز طاولتك بدون تعقيد',
      description: 'حدّد وقتك المناسب واحجز طاولتك في ثواني  بدون اي تعقيد',
    ),
    OnboardingModel(
      image: AppAssets.onboarding2,
      title: 'سهّل إدارة حجوزات مطعمك',
      description: 'تابع حجوزات عملائك بسهولة ومن مكان واحد و بطريقة منظمة',
    ),
    OnboardingModel(
      image: AppAssets.onboarding3,
      title: 'كل مطاعمك في مكان واحد',
      description: ' تصفّح مجموعة من أفضل المطاعم واختَر ما يناسب ذوقك واحتياجك بكل سهولة وراحة',
    ),
  ];
}
