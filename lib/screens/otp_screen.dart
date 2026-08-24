import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 45),
            const Icon(
              Icons.sms_outlined,
              size: 85,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 25),
            const Text(
              'Enter OTP',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                'Enter the 6-digit code sent to\n${controller.phoneNumber.value}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller:
                  controller.otpController,
              keyboardType:
                  TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 22),
            Obx(
              () => SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed:
                      controller.isOtpLoading.value
                          ? null
                          : () {
                              controller
                                  .verifyPhoneOtp(
                                controller
                                    .otpController
                                    .text,
                              );
                            },
                  child:
                      controller.isOtpLoading.value
                          ? const CircularProgressIndicator()
                          : const Text(
                              'VERIFY OTP',
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
