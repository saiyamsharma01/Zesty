import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';

void showAddressBottomSheet(BuildContext context, Function(String, double) onAddressSelected) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const _AddressBottomSheetContent();
    },
  ).then((result) {
    if (result != null && result is Map<String, dynamic>) {
      onAddressSelected(result['title'], result['distance']);
    }
  });
}

class _AddressBottomSheetContent extends StatelessWidget {
  const _AddressBottomSheetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationController = Get.isRegistered<LocationController>()
        ? Get.find<LocationController>()
        : Get.put(LocationController(), permanent: true);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F8F9), // Very light grey background like Zepto
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.black54),
                ),
              ],
            ),
          ),
          
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add New Address Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.add, color: Colors.pink),
                      title: const Text(
                        'Add New Address',
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.black54),
                      onTap: () {
                        _showAddDialog(context, locationController);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Saved Addresses',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Address List Container
                  Obx(() {
                    if (locationController.savedAddresses.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Center(
                          child: Text(
                            'No saved addresses. Add a new address above.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: locationController.savedAddresses.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: Colors.grey.shade200,
                          indent: 16,
                          endIndent: 16,
                        ),
                        itemBuilder: (context, index) {
                          final item = locationController.savedAddresses[index];
                          final title = item['title'] ?? 'Other';
                          final address = item['address'] ?? '';
                          final distance = (item['distance'] is num)
                              ? (item['distance'] as num).toDouble()
                              : 0.4;
                          final type = item['type'] ?? 'other';

                          IconData icon = Icons.location_on_outlined;
                          if (type == 'home' || title.toLowerCase().contains('home')) {
                            icon = Icons.home_outlined;
                          } else if (type == 'work' || title.toLowerCase().contains('work')) {
                            icon = Icons.business_outlined;
                          }

                          return _buildAddressItem(
                            context,
                            icon: icon,
                            title: title,
                            distance: distance,
                            address: address,
                          );
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, LocationController controller) {
    final titleCtrl = TextEditingController(text: 'Home');
    final addressCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New Address', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Address Label (Home, Work, etc.)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Full Address', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9852F9)),
            onPressed: () {
              if (addressCtrl.text.trim().isNotEmpty) {
                controller.addAddress(
                  title: titleCtrl.text.trim().isNotEmpty ? titleCtrl.text.trim() : 'Other',
                  address: addressCtrl.text.trim(),
                  distance: 0.8,
                );
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required double distance,
    required String address,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop({
          'title': title,
          'distance': distance,
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black87, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${distance} km',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
