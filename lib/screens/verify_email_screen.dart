import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.mark_email_unread_outlined,
              size: 90,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 25),
            const Text(
              'Verify Your Email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Check your email and click the verification link before logging in.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Obx(
              () => ElevatedButton(
                onPressed:
                    controller.isLoading.value
                        ? null
                        : controller
                            .sendVerificationEmail,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text(
                        'RESEND VERIFICATION EMAIL',
                      ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed:
                  controller.checkEmailVerification,
              child: const Text(
                'I HAVE VERIFIED MY EMAIL',
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Get.offAllNamed(Routes.login);
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
