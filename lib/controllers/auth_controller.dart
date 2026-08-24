import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_series/routes/app_routes.dart';
import 'package:flutter_series/services/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService =
  FirebaseService();

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
  TextEditingController();
  final otpController = TextEditingController();

  // ============================================================
  // REACTIVE VARIABLES
  // ============================================================

  final isLoading = false.obs;
  final isOtpLoading = false.obs;

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final isEmailVerified = false.obs;

  final verificationId = ''.obs;
  final phoneNumber = ''.obs;

  // ============================================================
  // SESSION
  // ============================================================

  User? get currentUser =>
      _firebaseService.currentUser;

  bool get isLoggedIn =>
      _firebaseService.isLoggedIn;

  bool get isAnonymous =>
      _firebaseService.isAnonymous;

  // ============================================================
  // CONTROLLER LIFECYCLE
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    // Session-related initialization
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();

    super.onClose();
  }

  // ============================================================
  // PASSWORD VISIBILITY
  // ============================================================

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  // ============================================================
  // SIGN UP
  // ============================================================

  Future<void> signUp() async {
    try {
      isLoading.value = true;

      final String name =
      nameController.text.trim();

      final String email =
      emailController.text.trim();

      final String phone =
      phoneController.text.trim();

      final String password =
          passwordController.text;

      final String confirmPassword =
          confirmPasswordController.text;

      // -----------------------------
      // VALIDATION
      // -----------------------------

      if (name.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        _showError(
          'Please fill all fields.',
        );
        return;
      }

      if (password != confirmPassword) {
        _showError(
          'Passwords do not match.',
        );
        return;
      }

      // -----------------------------
      // FIREBASE SIGNUP
      // -----------------------------

      final User? user =
      await _firebaseService.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (user == null) {
        return;
      }

      Get.snackbar(
        'Account Created',
        'Verification email has been sent to $email.',
        snackPosition:
        SnackPosition.BOTTOM,
      );

      // Signup ke baad direct Home nahi.
      // Pehle Login page.
      clearAuthFields();

      Get.offAllNamed(
        Routes.login,
      );
    } on FirebaseAuthException catch (e) {
      _showError(
        _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      _showError(
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    try {
      isLoading.value = true;

      final String email =
      emailController.text.trim();

      final String password =
          passwordController.text;

      if (email.isEmpty ||
          password.isEmpty) {
        _showError(
          'Please enter email and password.',
        );
        return;
      }

      final User? user =
      await _firebaseService.login(
        email: email,
        password: password,
      );

      if (user == null) {
        return;
      }

      await user.reload();

      final User? refreshedUser =
          FirebaseAuth.instance.currentUser;

      if (refreshedUser == null) {
        return;
      }

      // Email/password user ke liye verification required
      if (!refreshedUser.emailVerified) {
        isEmailVerified.value = false;

        Get.snackbar(
          'Email Not Verified',
          'Please verify your email before logging in.',
          snackPosition:
          SnackPosition.BOTTOM,
        );

        Get.toNamed(
          Routes.verifyEmail,
        );

        return;
      }

      isEmailVerified.value = true;

      Get.offAllNamed(
        Routes.home,
      );
    } on FirebaseAuthException catch (e) {
      _showError(
        _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      _showError(
        'Unable to login. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // GOOGLE LOGIN
  // ============================================================

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final User? user =
      await _firebaseService
          .signInWithGoogle();

      if (user == null) {
        return;
      }

      Get.snackbar(
        'Login Successful',
        'Welcome ${user.displayName ?? 'back'}!',
        snackPosition:
        SnackPosition.BOTTOM,
      );

      Get.offAllNamed(
        Routes.home,
      );
    } on FirebaseAuthException catch (e) {
      _showError(
        _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      _showError(
        'Google Sign-In failed.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // ANONYMOUS LOGIN
  // ============================================================

  Future<void> continueAsGuest() async {
    try {
      isLoading.value = true;

      final User? user =
      await _firebaseService
          .signInAnonymously();

      if (user == null) {
        return;
      }

      Get.snackbar(
        'Guest Mode',
        'You are continuing as a guest.',
        snackPosition:
        SnackPosition.BOTTOM,
      );

      Get.offAllNamed(
        Routes.home,
      );
    } on FirebaseAuthException catch (e) {
      _showError(
        _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      _showError(
        'Unable to continue as guest.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SEND PHONE OTP
  // ============================================================

  Future<void> sendPhoneOtp(String phone) async {
    try {
      isOtpLoading.value = true;

      final String cleanPhone = phone.trim();

      if (cleanPhone.isEmpty) {
        _showError('Please enter phone number.');
        isOtpLoading.value = false;
        return;
      }

      phoneNumber.value = cleanPhone;

      debugPrint("phoneNumber.value ======>${phoneNumber.value}");

      await _firebaseService.sendPhoneOtp(
        phoneNumber: cleanPhone,

        // ==========================================
        // OTP SENT
        // ==========================================
        onCodeSent: (
            String id,
            int? resendToken,
            ) {
          verificationId.value = id;
          isOtpLoading.value = false;

          // IMPORTANT:
          // OTP page ONLY opens from codeSent.
          Get.toNamed(Routes.otp);
        },

        // ==========================================
        // VERIFICATION FAILED
        // ==========================================
        onVerificationFailed: (
            FirebaseAuthException e,
            ) {

          print("onVerificationFailed ====>${e}, ${e.message}");
          isOtpLoading.value = false;

          _showError(
            e.message ?? 'Failed to send OTP.',
          );
        },

        // ==========================================
        // AUTO VERIFICATION
        // ==========================================
        onVerificationCompleted: (
            PhoneAuthCredential credential,
            ) async {
          print("onVerificationCompleted ====>${credential.smsCode}, ${credential.toString()}");
          // IMPORTANT:
          // Do NOT navigate to Home here.
          //
          // On iOS Simulator, Firebase can trigger
          // verification callbacks while reCAPTCHA
          // / deep-link flow is running.
          //
          // We will handle login only through OTP page.

          try {
            isOtpLoading.value = false;

            // Store credential temporarily if needed.
            // Do not navigate from here.
          } catch (e,st) {
            isOtpLoading.value = false;
            print("onVerificationCompleted catch====>${e}, ${st}");
          }
        },

        // ==========================================
        // AUTO RETRIEVAL TIMEOUT
        // ==========================================
        onCodeAutoRetrievalTimeout: (
            String id,
            ) {
          verificationId.value = id;
          isOtpLoading.value = false;
        },
      );
    } catch (e,st) {
      isOtpLoading.value = false;

      _showError(
        'Unable to send OTP. Please try again.',
      );
      print("catch 11 ====>${e}, ${st}");
    }
  }

  // ============================================================
  // VERIFY PHONE OTP
  // ============================================================

  Future<void> verifyPhoneOtp(
      String otp,
      ) async {
    try {
      isOtpLoading.value = true;

      if (otp.trim().length != 6) {
        _showError(
          'Please enter a valid 6-digit OTP.',
        );
        return;
      }

      if (verificationId.value.isEmpty) {
        _showError(
          'Verification session expired.',
        );
        return;
      }

      final User? user =
      await _firebaseService
          .verifyPhoneOtp(
        verificationId:
        verificationId.value,
        otp: otp.trim(),
      );

      if (user == null) {
        return;
      }

      Get.snackbar(
        'Success',
        'Phone number verified successfully.',
        snackPosition:
        SnackPosition.BOTTOM,
      );

      Get.offAllNamed(
        Routes.home,
      );
    } on FirebaseAuthException catch (e) {
      _showError(
        _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      _showError(
        'Unable to verify OTP.',
      );
    } finally {
      isOtpLoading.value = false;
    }
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> forgotPassword() async {
    try {
      isLoading.value = true;

      final String email =
      emailController.text.trim();

      if (email.isEmpty) {
        _showError(
          'Please enter your email.',
        );
        return;
      }

      await _firebaseService
          .sendPasswordResetEmail(
        email,
      );

      Get.snackbar(
        'Reset Email Sent',
        'Check your email for the password reset link.',
        snackPosition:
        SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      _showError(
        _getAuthErrorMessage(e.code),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SEND EMAIL VERIFICATION
  // ============================================================

  Future<void> sendVerificationEmail() async {
    try {
      isLoading.value = true;

      await _firebaseService
          .sendEmailVerification();

      Get.snackbar(
        'Email Sent',
        'Verification email has been sent.',
        snackPosition:
        SnackPosition.BOTTOM,
      );
    } catch (e) {
      _showError(
        'Unable to send verification email.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CHECK EMAIL VERIFICATION
  // ============================================================

  Future<void> checkEmailVerification() async {
    try {
      isLoading.value = true;

      final bool verified =
      await _firebaseService
          .isEmailVerified();

      isEmailVerified.value =
          verified;

      if (verified) {
        Get.offAllNamed(
          Routes.home,
        );
      } else {
        _showError(
          'Email is still not verified.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SESSION MANAGEMENT
  // ============================================================

  Future<void> checkUserSession() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final User? user =
        _firebaseService.currentUser;

    if (user == null) {
      Get.offAllNamed(
        Routes.login,
      );
      return;
    }

    await user.reload();

    final User? refreshedUser =
        FirebaseAuth.instance.currentUser;

    if (refreshedUser == null) {
      Get.offAllNamed(
        Routes.login,
      );
      return;
    }

    // Anonymous / Google / Phone
    if (refreshedUser.isAnonymous ||
        refreshedUser.providerData.any(
              (provider) =>
          provider.providerId ==
              'google.com',
        ) ||
        refreshedUser.providerData.any(
              (provider) =>
          provider.providerId ==
              'phone',
        )) {
      Get.offAllNamed(
        Routes.home,
      );
      return;
    }

    // Email/password user
    if (!refreshedUser.emailVerified) {
      Get.offAllNamed(
        Routes.verifyEmail,
      );
      return;
    }

    Get.offAllNamed(
      Routes.home,
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _firebaseService.logout();

      clearAuthFields();

      Get.offAllNamed(
        Routes.login,
      );
    } catch (e) {
      _showError(
        'Unable to logout.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // DELETE ACCOUNT
  // ============================================================

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      await _firebaseService
          .deleteAccount();

      clearAuthFields();

      Get.offAllNamed(
        Routes.login,
      );
    } on FirebaseAuthException catch (e) {
      _showError(
        _getAuthErrorMessage(e.code),
      );
    } catch (e) {
      _showError(
        'Unable to delete account.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CLEAR FIELDS
  // ============================================================

  void clearAuthFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    otpController.clear();

    verificationId.value = '';
    phoneNumber.value = '';
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _getAuthErrorMessage(
      String code,
      ) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'invalid-verification-code':
        return 'Invalid OTP.';

      case 'invalid-verification-id':
        return 'OTP session has expired.';

      case 'credential-already-in-use':
        return 'This account is already linked to another user.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }

  // ============================================================
  // SHOW ERROR
  // ============================================================

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition:
      SnackPosition.BOTTOM,
    );
  }
}