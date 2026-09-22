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
import '../screens/your_orders_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/zepto_cash_screen.dart';
import '../screens/review_and_earn_screen.dart';
import '../screens/your_refunds_screen.dart';
import '../screens/e_gift_cards_screen.dart';
import '../screens/add_address_details_screen.dart';
import '../screens/manage_payments_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/search_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/order_tracking_screen.dart';
import '../screens/saved_addresses_screen.dart';
import '../screens/zepto_pass_screen.dart';
import '../screens/live_chat_support_screen.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify-email';
  static const String phoneAuth = '/phone-auth';
  static const String otp = '/otp';
  static const String select = '/select';
  static const String superMall = '/super-mall';
  static const String cafe = '/cafe';
  static const String cafeCategory = '/cafe-category';
  static const String profile = '/profile';
  static const String yourOrders = '/your-orders';
  static const String helpSupport = '/help-support';
  static const String zeptoCash = '/zepto-cash';
  static const String reviewAndEarn = '/review-and-earn';
  static const String yourRefunds = '/your-refunds';
  static const String eGiftCards = '/e-gift-cards';
  static const String addAddressDetails = '/add-address-details';
  static const String managePayments = '/manage-payments';
  static const String notifications = '/notifications';
  static const String search = '/search';
  static const String productDetails = '/product-details';
  static const String orderTracking = '/order-tracking';
  static const String savedAddresses = '/saved-addresses';
  static const String zeptoPass = '/zepto-pass';
  static const String liveChat = '/live-chat';
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
    GetPage(
      name: Routes.yourOrders,
      page: () => const YourOrdersScreen(),
    ),
    GetPage(
      name: Routes.helpSupport,
      page: () => const HelpSupportScreen(),
    ),
    GetPage(
      name: Routes.zeptoCash,
      page: () => const ZeptoCashScreen(),
    ),
    GetPage(
      name: Routes.reviewAndEarn,
      page: () => const ReviewAndEarnScreen(),
    ),
    GetPage(
      name: Routes.yourRefunds,
      page: () => const YourRefundsScreen(),
    ),
    GetPage(
      name: Routes.eGiftCards,
      page: () => const EGiftCardsScreen(),
    ),
    GetPage(
      name: Routes.addAddressDetails,
      page: () => const AddAddressDetailsScreen(),
    ),
    GetPage(
      name: Routes.managePayments,
      page: () => const ManagePaymentsScreen(),
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: Routes.productDetails,
      page: () => const ProductDetailsScreen(),
    ),
    GetPage(
      name: Routes.orderTracking,
      page: () => const OrderTrackingScreen(),
    ),
    GetPage(
      name: Routes.savedAddresses,
      page: () => const SavedAddressesScreen(),
    ),
    GetPage(
      name: Routes.zeptoPass,
      page: () => const ZeptoPassScreen(),
    ),
    GetPage(
      name: Routes.liveChat,
      page: () => const LiveChatSupportScreen(),
    ),
  ];
}
