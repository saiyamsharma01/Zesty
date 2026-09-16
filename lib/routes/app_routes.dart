import 'package:get/get.dart';

import '../screens/forgot_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/phone_auth_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/verify_email_screen.dart';
import '../screens/select_screen.dart';
import '../screens/super_mall_screen.dart';
import '../screens/cafe_screen.dart';
import '../screens/zepto_cafe_category_screen.dart';
import '../screens/profile_screen.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String forgotPassword =
      '/forgot-password';
  static const String verifyEmail =
      '/verify-email';
  static const String phoneAuth = '/phone-auth';
  static const String otp = '/otp';
  static const String select = '/select';
  static const String superMall = '/super-mall';
  static const String cafe = '/cafe';
  static const String cafeCategory = '/cafe-category';
  static const String profile = '/profile';
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: Routes.verifyEmail,
      page: () => const VerifyEmailScreen(),
    ),
    GetPage(
      name: Routes.phoneAuth,
      page: () => const PhoneAuthScreen(),
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpScreen(),
    ),
    GetPage(
      name: Routes.select,
      page: () => const SelectScreen(),
    ),
    GetPage(
      name: Routes.superMall,
      page: () => const SuperMallScreen(),
    ),
    GetPage(
      name: Routes.cafe,
      page: () => const CafeScreen(),
    ),
    GetPage(
      name: Routes.cafeCategory,
      page: () => const ZeptoCafeCategoryScreen(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
    ),
  ];
}
