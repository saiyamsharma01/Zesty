import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import '../controllers/auth_controller.dart';

class AddAddressDetailsScreen extends StatefulWidget {
  const AddAddressDetailsScreen({super.key});

  @override
  State<AddAddressDetailsScreen> createState() => _AddAddressDetailsScreenState();
}

class _AddAddressDetailsScreenState extends State<AddAddressDetailsScreen> {
  late final LocationController locationController;
  late final AuthController authController;

  final TextEditingController houseNoController = TextEditingController();
  final TextEditingController buildingBlockController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();

  String selectedLabel = 'Home'; // 'Home', 'Work', 'Other'
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    locationController = Get.isRegistered<LocationController>()
        ? Get.find<LocationController>()
        : Get.put(LocationController());

    authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    // Pre-fill user name and phone if available
    if (authController.userName.value.isNotEmpty) {
      receiverNameController.text = authController.userName.value;
    }
    if (authController.userPhone.value.isNotEmpty) {
      final phone = authController.userPhone.value.replaceAll('+91', '').replaceAll(' ', '').trim();
      receiverPhoneController.text = phone;
    }

    // Attempt live location fetch if default
    if (locationController.currentAddress.value == 'Tap to set location...') {
      locationController.getCurrentLocation();
    }
  }

  @override
  void dispose() {
    houseNoController.dispose();
    buildingBlockController.dispose();
    landmarkController.dispose();
    receiverNameController.dispose();
    receiverPhoneController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    final houseNo = houseNoController.text.trim();
    if (houseNo.isEmpty) {
      Get.snackbar('Required Field', 'Please enter House No. & Floor',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return;
    }

    final receiverName = receiverNameController.text.trim().isNotEmpty
        ? receiverNameController.text.trim()
        : (authController.userName.value.isNotEmpty ? authController.userName.value : 'User');

    final receiverPhone = receiverPhoneController.text.trim().isNotEmpty
        ? receiverPhoneController.text.trim()
        : (authController.userPhone.value.isNotEmpty ? authController.userPhone.value : '');

    setState(() => isSaving = true);

    final area = locationController.detectedArea.value;
    final subArea = locationController.detectedSubArea.value;

    final List<String> addressParts = [
      houseNo,
      if (buildingBlockController.text.trim().isNotEmpty) buildingBlockController.text.trim(),
      if (landmarkController.text.trim().isNotEmpty) landmarkController.text.trim(),
      area,
      subArea,
    ];

    final fullAddress = addressParts.join(', ');

    await locationController.addAddress(
      title: selectedLabel,
      address: fullAddress,
      type: selectedLabel.toLowerCase(),
      houseNo: houseNo,
      buildingBlock: buildingBlockController.text.trim(),
      landmark: landmarkController.text.trim(),
      receiverName: receiverName,
      receiverPhone: receiverPhone,
      distance: 0.5,
    );

    // Set as current delivery address
    await locationController.updateAddress(fullAddress);

    setState(() => isSaving = false);

    Get.back();
    Get.snackbar(
      'Address Saved',
      '$selectedLabel address saved and selected successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFE8F8EE),
      colorText: const Color(0xFF16A34A),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Bar
            _buildTopBar(),

            // 2. Form Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Map Preview & Detected Location Box
                    _buildMapPreviewBox(),
                    const SizedBox(height: 16),

                    // Dotted Divider
                    SizedBox(
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _DottedLinePainter(color: const Color(0xFFE5E7EB)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 1: Add address
                    const Text(
                      'Add address',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: houseNoController,
                      hintText: 'House No. & Floor',
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: buildingBlockController,
                      hintText: 'Building & Block No. (Optional)',
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: landmarkController,
                      hintText: 'Landmark & Area Name (Optional)',
                    ),
                    const SizedBox(height: 24),

                    // Section 2: Add address label
                    const Text(
                      'Add address label',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildAddressLabelSelector(),
                    const SizedBox(height: 24),

                    // Section 3: Add receiver details
                    const Text(
                      'Add receiver details',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildReceiverNameField(),
                    const SizedBox(height: 12),

                    _buildReceiverPhoneField(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 3. Bottom Sticky Save Address Button
            _buildSaveAddressButton(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 1. TOP BAR
  // ============================================================
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.black87,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Add Address Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 2. MAP PREVIEW BOX (WITH LIVE PIN & CHANGE BUTTON)
  // ============================================================
  Widget _buildMapPreviewBox() {
    return Column(
      children: [
        // Map Container
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stylized map illustration
                CustomPaint(
                  size: const Size(double.infinity, 170),
                  painter: _MapGridPainter(),
                ),

                // Map Labels
                Positioned(
                  top: 20,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7E4C7).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Jurassic Park',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D6A4F),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 75,
                  right: 40,
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.circle, size: 6, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Little Bunny Day Care',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Pin in center
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E63),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.place_rounded, color: Colors.white, size: 13),
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 12,
                      color: const Color(0xFFE91E63),
                    ),
                    Container(
                      width: 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),

                // Google logo on bottom left
                Positioned(
                  bottom: 8,
                  left: 12,
                  child: Row(
                    children: [
                      Text(
                        'Google',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Detected Address text row + Change button
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF111827),
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locationController.detectedArea.value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        locationController.detectedSubArea.value,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
            ),
            const SizedBox(width: 8),
            // Change Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                side: const BorderSide(color: Color(0xFFFF2B66), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                locationController.getCurrentLocation();
              },
              child: const Text(
                'Change',
                style: TextStyle(
                  color: Color(0xFFFF2B66),
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // 3. TEXT FIELDS & LABEL SELECTOR
  // ============================================================
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14, color: Color(0xFF111827), fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13.5, fontWeight: FontWeight.w400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          filled: false,
        ),
      ),
    );
  }

  Widget _buildAddressLabelSelector() {
    final labels = [
      {'label': 'Home', 'icon': Icons.home_outlined},
      {'label': 'Work', 'icon': Icons.apartment_outlined},
      {'label': 'Other', 'icon': Icons.location_on_outlined},
    ];

    return Row(
      children: labels.map((item) {
        final label = item['label'] as String;
        final icon = item['icon'] as IconData;
        final isSelected = selectedLabel == label;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedLabel = label;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: label != 'Other' ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFF0F4) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF2B66) : const Color(0xFFE5E7EB),
                  width: isSelected ? 1.4 : 1.1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 17,
                    color: isSelected ? const Color(0xFFFF2B66) : const Color(0xFF4B5563),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? const Color(0xFFFF2B66) : const Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReceiverNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      child: TextField(
        controller: receiverNameController,
        style: const TextStyle(fontSize: 14, color: Color(0xFF111827), fontWeight: FontWeight.w500),
        decoration: const InputDecoration(
          hintText: 'Receiver’s Name',
          hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13.5, fontWeight: FontWeight.w400),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          filled: false,
          suffixIcon: Icon(
            Icons.contacts_rounded,
            color: Color(0xFF111827),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildReceiverPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14, right: 8),
            child: Text(
              '+91',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ),
          Container(
            height: 24,
            width: 1,
            color: const Color(0xFFE5E7EB),
          ),
          Expanded(
            child: TextField(
              controller: receiverPhoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 14, color: Color(0xFF111827), fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: 'Receiver’s Phone Number',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13.5, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                filled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 4. BOTTOM SAVE BUTTON
  // ============================================================
  Widget _buildSaveAddressButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 1.0)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3F007D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: isSaving ? null : _saveAddress,
          child: isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'Save Address',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

// ============================================================
// MAP GRID PAINTER
// ============================================================
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background fill (light grey map tint)
    final bgPaint = Paint()..color = const Color(0xFFE9ECEF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Green Park Area
    final parkPaint = Paint()..color = const Color(0xFFD8F3DC);
    final parkPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.35, 0)
      ..lineTo(size.width * 0.48, size.height * 0.7)
      ..lineTo(0, size.height * 0.5)
      ..close();
    canvas.drawPath(parkPath, parkPaint);

    // Roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;

    // Diagonal road
    canvas.drawLine(
      Offset(size.width * 0.1, 0),
      Offset(size.width * 0.9, size.height),
      roadPaint,
    );

    // Cross road
    canvas.drawLine(
      Offset(size.width * 0.8, 0),
      Offset(size.width * 0.2, size.height),
      roadPaint..strokeWidth = 16,
    );

    // Horizontal roads
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint..strokeWidth = 10,
    );

    // Residential Blocks (light grey tiles)
    final blockPaint = Paint()..color = const Color(0xFFCED4DA).withValues(alpha: 0.35);
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 3; j++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.55 + (i * 24), 20 + (j * 32), 18, 22),
            const Radius.circular(2),
          ),
          blockPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// DOTTED LINE PAINTER
// ============================================================
class _DottedLinePainter extends CustomPainter {
  final Color color;

  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
