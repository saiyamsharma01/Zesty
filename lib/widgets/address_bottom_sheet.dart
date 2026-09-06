import 'package:flutter/material.dart';

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
                      onTap: () {},
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildAddressItem(
                          context,
                          icon: Icons.location_on_outlined,
                          title: 'Other',
                          distance: 0.4,
                          address: '1288, Platinum hostel, 1288, Phase 5, Sector 59, Sahibzada Ajit Singh Nagar, Punjab 160059, India',
                        ),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                        _buildAddressItem(
                          context,
                          icon: Icons.location_on_outlined,
                          title: 'Other (2)',
                          distance: 0.6,
                          address: '1895, 1895, Phase 5, Sector 59, Sahibzada Ajit Singh Nagar, Punjab 160059, India',
                        ),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                        _buildAddressItem(
                          context,
                          icon: Icons.home_outlined,
                          title: 'Home',
                          distance: 0.2,
                          address: '1567, 1566, Phase 5, sector:59, Sahibzada Ajit Singh Nagar, Punjab 160059, India',
                        ),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                        _buildAddressItem(
                          context,
                          icon: Icons.business_outlined,
                          title: 'Work',
                          distance: 202.8,
                          address: 'khalsa college, computer science department, 17, Near Bhandari Bridge, Katra Jaimal Singh, Kt. Jaim...',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
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
