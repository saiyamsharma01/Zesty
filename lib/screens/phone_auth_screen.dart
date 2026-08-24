import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../controllers/auth_controller.dart';

class PhoneAuthScreen extends StatelessWidget {
  const PhoneAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 35),
              const Icon(
                Icons.phone_android,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                'Continue with Phone',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your phone number to receive an OTP.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              IntlPhoneField(
                controller:
                    controller.phoneController,
                initialCountryCode: 'IN',
                keyboardType:
                    TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                onChanged: (phone) {
                  controller.phoneNumber.value =
                      phone.completeNumber;
                },
              ),
              const SizedBox(height: 20),
              Obx(
                () => SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed:
                        controller.isOtpLoading.value
                            ? null
                            : () {
                                controller.sendPhoneOtp(
                                  controller
                                      .phoneNumber
                                      .value,
                                );
                              },
                    child:
                        controller.isOtpLoading.value
                            ? const CircularProgressIndicator()
                            : const Text('SEND OTP'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
