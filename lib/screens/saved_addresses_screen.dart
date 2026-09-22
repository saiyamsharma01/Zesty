import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import '../routes/app_routes.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  late final LocationController locationController;

  @override
  void initState() {
    super.initState();
    locationController = Get.isRegistered<LocationController>()
        ? Get.find<LocationController>()
        : Get.put(LocationController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Saved Addresses',
          style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w800),
        ),
      ),
      body: Obx(() {
        final addresses = locationController.savedAddresses;

        return Column(
          children: [
            // Add New Address Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF3F007D),
                  side: const BorderSide(color: Color(0xFF3F007D), width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Get.toNamed(Routes.addAddressDetails),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add New Address', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ),

            const SizedBox(height: 12),

            // Addresses List
            Expanded(
              child: addresses.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: addresses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final addr = addresses[index];
                        return _buildAddressCard(addr, index);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'No Saved Addresses Yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            'Add your home or work address for 10-minute instant delivery.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> addr, int index) {
    final title = addr['title'] ?? 'Address';
    final fullAddress = addr['address'] ?? '';
    final type = (addr['type'] ?? 'home').toString().toLowerCase();
    final receiverName = addr['receiverName'] ?? 'User';
    final receiverPhone = addr['receiverPhone'] ?? '';

    IconData icon = Icons.location_on_outlined;
    if (type.contains('home')) icon = Icons.home_outlined;
    if (type.contains('work')) icon = Icons.work_outline;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EDFD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF3F007D)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            type.toUpperCase(),
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      fullAddress,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.35),
                    ),
                    if (receiverPhone.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Receiver: $receiverName ($receiverPhone)',
                        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Delete Address',
                    middleText: 'Are you sure you want to remove "$title"?',
                    textConfirm: 'Delete',
                    textCancel: 'Cancel',
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      Get.back();
                      locationController.savedAddresses.removeAt(index);
                      Get.snackbar('Address Removed', 'Address deleted from your account.');
                    },
                  );
                },
                child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F007D),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {
                  locationController.currentAddress.value = fullAddress;
                  Get.back();
                  Get.snackbar('Active Location Updated', 'Delivering now to $title');
                },
                child: const Text('Deliver Here', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
