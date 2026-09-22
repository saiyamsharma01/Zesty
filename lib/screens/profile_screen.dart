import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/location_controller.dart';
import '../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthController authController;
  late final LocationController locationController;

  @override
  void initState() {
    super.initState();
    authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    locationController = Get.isRegistered<LocationController>()
        ? Get.find<LocationController>()
        : Get.put(LocationController(), permanent: true);

    // Refresh fresh profile data
    authController.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top App Bar with back button
              _buildTopBar(),
              const SizedBox(height: 24),

              // 2. User Info Header
              _buildUserProfileHeader(),
              const SizedBox(height: 24),

              // 3. Quick Action Cards (Your Orders, Help & Support, Zepto Cash)
              _buildQuickActionCards(),
              const SizedBox(height: 28),

              // 4. Money Center Section
              _buildSectionTitle('Money Center'),
              const SizedBox(height: 12),
              _buildMoneyCenterCard(),
              const SizedBox(height: 28),

              // 5. Your Information Section
              _buildSectionTitle('Your Information'),
              const SizedBox(height: 12),
              _buildYourInformationCard(),
              const SizedBox(height: 28),

              // 6. Other Information Section
              _buildSectionTitle('Other Information'),
              const SizedBox(height: 12),
              _buildOtherInformationCard(),
              const SizedBox(height: 24),

              // 7. Log Out Button
              _buildLogOutButton(),
              const SizedBox(height: 16),

              // 8. App Version Footer
              Center(
                child: Text(
                  'App version 26.9.2',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TOP APP BAR
  // ============================================================
  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.black87,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // USER PROFILE HEADER (DYNAMIC)
  // ============================================================
  Widget _buildUserProfileHeader() {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: Color(0xFF9852F9),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final name = authController.userName.value.trim();
                return Text(
                  name.isNotEmpty ? name : 'User',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }),
              const SizedBox(height: 3),
              Obx(() {
                final phone = authController.userPhone.value.trim();
                final email = authController.userEmail.value.trim();
                if (phone.isNotEmpty) {
                  return Text(
                    phone,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else if (email.isNotEmpty) {
                  return Text(
                    email,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: _showEditProfileSheet,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Phone Number',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.edit_outlined,
                          size: 13,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 3 QUICK ACTION CARDS
  // ============================================================
  Widget _buildQuickActionCards() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.shopping_bag_outlined,
            title: 'Your\nOrders',
            onTap: () => Get.toNamed(Routes.yourOrders),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Help &\nSupport',
            onTap: () => Get.toNamed(Routes.helpSupport),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.receipt_long_outlined,
            title: 'Zepto\nCash',
            onTap: () => Get.toNamed(Routes.zeptoCash),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 104,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 26, color: Colors.black87),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: -0.2,
      ),
    );
  }

  // ============================================================
  // MONEY CENTER CARD (DYNAMIC ZEPTO CASH)
  // ============================================================
  Widget _buildMoneyCenterCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(Routes.zeptoCash),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.folder_open_outlined,
                  size: 24,
                  color: Colors.black87,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Zepto Cash & Gift Card',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Obx(() {
                  final cash = authController.zeptoCash.value.toInt();
                  return Text(
                    '₹$cash',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  );
                }),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black54,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // YOUR INFORMATION CARD (DYNAMIC SAVED ADDRESSES & EDIT PROFILE)
  // ============================================================
  Widget _buildYourInformationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      child: Column(
        children: [
          _buildListTileItem(
            icon: Icons.rate_review_outlined,
            title: 'Review & Earn',
            onTap: () => Get.toNamed(Routes.reviewAndEarn),
          ),
          _buildDivider(),
          _buildListTileItem(
            icon: Icons.currency_rupee_rounded,
            title: 'Your Refunds',
            onTap: () => Get.toNamed(Routes.yourRefunds),
          ),
          _buildDivider(),
          _buildListTileItem(
            icon: Icons.credit_card_outlined,
            title: 'E-Gift Cards',
            onTap: () => Get.toNamed(Routes.eGiftCards),
          ),
          _buildDivider(),
          _buildListTileItem(
            icon: Icons.workspace_premium_outlined,
            title: 'Zepto Pass VIP',
            subtitle: 'Unlimited Free Deliveries & 20% off on Cafe',
            onTap: () => Get.toNamed(Routes.zeptoPass),
          ),
          _buildDivider(),
          // Dynamic Saved Addresses
          Obx(() {
            final count = locationController.savedAddresses.length;
            final subtitle = count > 0
                ? '$count ${count == 1 ? 'Address' : 'Addresses'}'
                : null;
            return _buildListTileItem(
              icon: Icons.location_on_outlined,
              title: 'Saved Addresses',
              subtitle: subtitle,
              onTap: () => Get.toNamed(Routes.savedAddresses),
            );
          }),
          _buildDivider(),
          _buildListTileItem(
            icon: Icons.person_outline_rounded,
            title: 'Edit Profile',
            onTap: _showEditProfileSheet,
          ),
          _buildDivider(),
          _buildListTileItem(
            icon: Icons.card_giftcard_outlined,
            title: 'Rewards',
            onTap: _showRewardsSheet,
          ),
          _buildDivider(),
          _buildListTileItem(
            icon: Icons.payment_outlined,
            title: 'Payment Management',
            onTap: () => Get.toNamed(Routes.managePayments),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OTHER INFORMATION CARD
  // ============================================================
  Widget _buildOtherInformationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      child: Column(
        children: [
          _buildListTileItem(
            icon: Icons.star_border_rounded,
            title: 'Suggest Products',
            onTap: _showSuggestProductsSheet,
          ),
          _buildDivider(),
          _buildListTileItem(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            onTap: () => Get.toNamed(Routes.notifications),
          ),
          _buildDivider(),
          _buildListTileItem(
            icon: Icons.info_outline_rounded,
            title: 'General Info',
            onTap: _showGeneralInfoSheet,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REUSABLE LIST TILE ITEM
  // ============================================================
  Widget _buildListTileItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 23, color: Colors.black87),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black54,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.8,
      color: Colors.grey.shade200,
      indent: 52,
      endIndent: 16,
    );
  }

  // ============================================================
  // LOG OUT BUTTON
  // ============================================================
  Widget _buildLogOutButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _showLogoutConfirmDialog,
          child: const Center(
            child: Text(
              'Log Out',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to log out of Zesty?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              authController.logout();
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EDIT PROFILE SHEET (DYNAMIC)
  // ============================================================
  void _showEditProfileSheet() {
    final nameCtrl = TextEditingController(text: authController.userName.value);
    final phoneCtrl = TextEditingController(text: authController.userPhone.value);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9852F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final newName = nameCtrl.text.trim();
                  final newPhone = phoneCtrl.text.trim();
                  if (newName.isNotEmpty) {
                    await authController.updateUserProfile(
                      name: newName,
                      phone: newPhone,
                    );
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                    }
                  }
                },
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SAVED ADDRESSES MANAGEMENT SHEET (DYNAMIC)
  // ============================================================
  void _showSavedAddressesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFFF7F8FA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
                    'Saved Addresses',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: const Icon(Icons.close, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add New Address Card
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
                          Navigator.of(ctx).pop();
                          Get.toNamed(Routes.addAddressDetails);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Addresses',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
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
                              'No saved addresses yet.\nTap "Add New Address" above.',
                              textAlign: TextAlign.center,
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
                            final title = item['title'] ?? 'Address';
                            final address = item['address'] ?? '';
                            final distance = item['distance'] ?? 0.5;

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: const Icon(Icons.location_on_outlined, color: Colors.black87),
                              title: Row(
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '• $distance km',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  address,
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                onPressed: () {
                                  locationController.deleteAddress(index);
                                },
                              ),
                              onTap: () {
                                locationController.updateAddress(address);
                                Navigator.of(ctx).pop();
                                Get.snackbar('Address Selected', '$title is set as current address');
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNewAddressDialog() {
    final titleCtrl = TextEditingController(text: 'Home');
    final addressCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Address', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Address Tag (e.g. Home, Work, Other)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Full Address',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9852F9)),
            onPressed: () {
              if (addressCtrl.text.trim().isNotEmpty) {
                locationController.addAddress(
                  title: titleCtrl.text.trim().isNotEmpty ? titleCtrl.text.trim() : 'Other',
                  address: addressCtrl.text.trim(),
                  distance: 0.8,
                );
                Navigator.of(ctx).pop();
                Get.snackbar('Success', 'Address added successfully!');
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ZEPTO CASH & GIFT CARD SHEET (DYNAMIC)
  // ============================================================
  void _showZeptoCashSheet() {
    final voucherCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Zepto Cash & Gift Card',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Balance Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9852F9), Color(0xFF6C28D9)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Obx(() => Text(
                            '₹${authController.zeptoCash.value.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Quick Add Cash',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [100, 250, 500, 1000].map((amount) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.purple.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        authController.addZeptoCash(amount.toDouble());
                      },
                      child: Text('+₹$amount', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Redeem Gift Card Voucher',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: voucherCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter Voucher (e.g. ZEPTO500)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9852F9),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    authController.redeemGiftCard(voucherCtrl.text);
                    voucherCtrl.clear();
                  },
                  child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ORDERS SHEET
  // ============================================================
  void _showOrdersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Your Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildOrderItem(
                    orderId: 'ORD-98421',
                    date: 'Today, 4:25 PM',
                    items: 'Amul Butter 100g, Britannia Bread, Milk 1L',
                    amount: '₹245',
                    status: 'Delivered in 8 mins',
                  ),
                  _buildOrderItem(
                    orderId: 'ORD-98104',
                    date: 'Yesterday, 11:15 AM',
                    items: 'Cappuccino Cold Coffee, Hazelnut Cold Coffee',
                    amount: '₹218',
                    status: 'Delivered in 9 mins',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem({
    required String orderId,
    required String date,
    required String items,
    required String amount,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepPurple)),
            ],
          ),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 6),
          Text(items, style: const TextStyle(fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(status, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: const Size(0, 30),
                ),
                onPressed: () => Get.snackbar('Reordered', 'Items added to cart!'),
                child: const Text('Reorder', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELP & SUPPORT SHEET
  // ============================================================
  void _showHelpSupportSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('24x7 Help & Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.support_agent_rounded, color: Colors.deepPurple),
              title: const Text('Chat with Support'),
              subtitle: const Text('Instant answers to your queries'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                Get.snackbar('Support Chat', 'Connecting with a Zesty representative...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_in_talk_outlined, color: Colors.green),
              title: const Text('Call Helpline'),
              subtitle: const Text('+91 1800-202-9999'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                Get.snackbar('Call Support', 'Dialing Zesty Helpline...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded, color: Colors.orange),
              title: const Text('FAQs & Safety Guidelines'),
              subtitle: const Text('Learn about delivery & refunds'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // OTHER SUB-SHEETS
  // ============================================================
  void _showReviewEarnSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.rate_review, color: Colors.amber, size: 44),
            const SizedBox(height: 12),
            const Text('Review & Earn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Review your recently purchased items to earn ₹10 Zepto Cash on every review!', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9852F9)),
              onPressed: () => Get.back(),
              child: const Text('Rate Recent Items', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showRefundsSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.currency_rupee, color: Colors.green, size: 44),
            const SizedBox(height: 12),
            const Text('Your Refunds', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('All refunds are credited to original payment method or Zepto Cash instantly within 2 hours.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            const Text('No pending refunds at this time.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showRewardsSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.card_giftcard, color: Colors.pink, size: 44),
            const SizedBox(height: 12),
            const Text('Your Rewards & Scratch Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('You have 2 new scratch cards available from your latest orders!', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () {
                Get.back();
                authController.addZeptoCash(25.0);
                Get.snackbar('Scratch Card Won!', 'You won ₹25 Zepto Cash!');
              },
              child: const Text('Scratch & Win', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentManagementSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            ListTile(
              leading: const Icon(Icons.account_balance, color: Colors.indigo),
              title: const Text('Saved UPI IDs'),
              subtitle: const Text('Google Pay, PhonePe, Paytm'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blue),
              title: const Text('Saved Cards'),
              subtitle: const Text('Visa, MasterCard, RuPay'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuggestProductsSheet() {
    final suggestCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Suggest Products', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: suggestCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'What item or brand would you like to see on Zesty?',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9852F9)),
            onPressed: () {
              if (suggestCtrl.text.trim().isNotEmpty) {
                Get.back();
                Get.snackbar('Thank You!', 'We noted your request and will stock it soon!');
              }
            },
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showNotificationsSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notification Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            SwitchListTile(
              value: true,
              activeColor: Colors.deepPurple,
              title: const Text('Order & Delivery Updates'),
              subtitle: const Text('Live rider tracking and delivery alerts'),
              onChanged: (val) {},
            ),
            SwitchListTile(
              value: true,
              activeColor: Colors.deepPurple,
              title: const Text('Discounts & Offers'),
              subtitle: const Text('Exclusive Steal Deals & Cafe discounts'),
              onChanged: (val) {},
            ),
          ],
        ),
      ),
    );
  }

  void _showGeneralInfoSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('General Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of Service'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.business_outlined),
              title: const Text('About Zesty Grocery & Cafe'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
