import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewAndEarnScreen extends StatefulWidget {
  const ReviewAndEarnScreen({super.key});

  @override
  State<ReviewAndEarnScreen> createState() => _ReviewAndEarnScreenState();
}

class _ReviewAndEarnScreenState extends State<ReviewAndEarnScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _guidelinesKey = GlobalKey();

  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'General Guidelines',
    'Makeup & Beauty',
    'Apparel',
    'Electronics',
    'Food & Snacks',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToGuidelines() {
    final context = _guidelinesKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar (Back Button + Coin Rate Badge)
              _buildTopBar(),
              const SizedBox(height: 12),

              // 2. Hero Banner (Review & Earn + 3D Coin Medallion)
              _buildHeroBanner(),
              const SizedBox(height: 16),

              // 3. View Review Guidelines Card
              _buildReviewGuidelinesCard(),
              const SizedBox(height: 24),

              // 4. Stats Row (Eligible Review | Write a Review to Earn)
              _buildStatsRow(),
              const SizedBox(height: 24),

              // 5. Eligible Items Empty State Card
              _buildEligibleItemsCard(),
              const SizedBox(height: 28),

              // 6. Section: HOW DOES IT WORK?
              _buildSectionHeader('HOW DOES IT WORK?'),
              const SizedBox(height: 12),
              _buildHowItWorksCard(),
              const SizedBox(height: 28),

              // 7. Section: WHAT MAKES A REVIEW GOOD?
              Container(key: _guidelinesKey),
              _buildSectionHeader('WHAT MAKES A REVIEW GOOD?'),
              const SizedBox(height: 12),
              _buildWhatMakesReviewGoodCard(),
              const SizedBox(height: 28),

              // 8. Section: OTHERS (FAQs & T&C)
              _buildSectionHeader('OTHERS'),
              const SizedBox(height: 12),
              _buildOthersCard(),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 1. TOP BAR
  // ============================================================
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
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

        // Coin = ₹1 Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 1.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMiniCoin(size: 18),
              const SizedBox(width: 5),
              const Text(
                '= ₹1',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 2. HERO BANNER
  // ============================================================
  Widget _buildHeroBanner() {
    return Stack(
      alignment: Alignment.centerRight,
      clipBehavior: Clip.none,
      children: [
        // Left text column
        Padding(
          padding: const EdgeInsets.only(right: 120.0, top: 8.0, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Review & ',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextSpan(
                      text: 'Earn',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFC78328),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: 'Write helpful reviews and\nearn '),
                    TextSpan(
                      text: 'Z-Coins',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC78328),
                      ),
                    ),
                    TextSpan(text: ' on every photo/text'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Right 3D Coin Medallion with concentric ripple rings
        Positioned(
          right: -10,
          top: -20,
          child: _buildHeroCoinMedallion(),
        ),
      ],
    );
  }

  Widget _buildHeroCoinMedallion() {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ripple ring 3
          Container(
            width: 138,
            height: 138,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE2C89A).withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
          ),
          // Ripple ring 2
          Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE2C89A).withValues(alpha: 0.55),
                width: 1.2,
              ),
            ),
          ),
          // Ripple ring 1
          Container(
            width: 98,
            height: 98,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE2C89A).withValues(alpha: 0.8),
                width: 1.4,
              ),
            ),
          ),
          // 3D Metallic Gold Medallion
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8D601A),
                  Color(0xFFE8B658),
                  Color(0xFFFFF1BD),
                  Color(0xFFDCA13D),
                  Color(0xFF6B430B),
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7A4E0F).withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(2, 6),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    center: Alignment(-0.2, -0.3),
                    radius: 0.8,
                    colors: [
                      Color(0xFFF3D48B),
                      Color(0xFFBF882C),
                      Color(0xFF73460A),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFFFF3C4).withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFBE8),
                        Color(0xFFFFD466),
                        Color(0xFF804F09),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Z',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color(0xFF382000),
                            offset: Offset(2, 3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 3. VIEW REVIEW GUIDELINES CARD
  // ============================================================
  Widget _buildReviewGuidelinesCard() {
    return GestureDetector(
      onTap: _scrollToGuidelines,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Mini Visual Graphic
            _buildGuidelinesMiniIllustration(),
            const SizedBox(width: 14),

            // Middle Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'View review guidelines',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Get the most out of your reviews',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Right Chevron Arrow
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFFF2B66),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelinesMiniIllustration() {
    return SizedBox(
      width: 58,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background bad card (tilted left with red cross)
          Positioned(
            left: 0,
            top: 4,
            child: Transform.rotate(
              angle: -0.12,
              child: Container(
                width: 34,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 8,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Foreground good card (man photo with green check)
          Positioned(
            left: 14,
            top: 0,
            child: Container(
              width: 36,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white, width: 1.5),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 4. STATS ROW
  // ============================================================
  Widget _buildStatsRow() {
    return Row(
      children: [
        // Left: Eligible Review
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '00',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _build3DStar(size: 24),
                ],
              ),
              const SizedBox(height: 8),
              _buildDashedUnderlineText('ELIGIBLE REVIEW'),
            ],
          ),
        ),

        // Vertical Divider
        Container(
          height: 48,
          width: 1,
          color: Colors.grey.shade300,
        ),

        // Right: Write a Review to Earn
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '00',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildMiniCoin(size: 24),
                ],
              ),
              const SizedBox(height: 8),
              _buildDashedUnderlineText('WRITE A REVIEW TO EARN'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashedUnderlineText(String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 130,
          child: CustomPaint(
            painter: _DashedLinePainter(color: const Color(0xFF9CA3AF)),
          ),
        ),
      ],
    );
  }

  Widget _build3DStar({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFFFF275), Color(0xFFF59E0B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.star_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildMiniCoin({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF6D365),
            Color(0xFFD49320),
            Color(0xFF8F5605),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB47510).withValues(alpha: 0.3),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.8,
          height: size * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFC78328),
            border: Border.all(color: const Color(0xFFFFEB99), width: 0.8),
          ),
          child: Center(
            child: Text(
              'Z',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: size * 0.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 5. ELIGIBLE ITEMS EMPTY STATE CARD
  // ============================================================
  Widget _buildEligibleItemsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Shopping bag in circle outline
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 32,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Title
          const Text(
            'No eligible items to review',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle
          const Text(
            'Shop an eligible item, then review to earn rewards.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),

          // View T&Cs link
          GestureDetector(
            onTap: _showTermsAndConditionsModal,
            child: const Text(
              'View T&Cs',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFFFF2B66),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 6. SECTION HEADER & HOW DOES IT WORK
  // ============================================================
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksCard() {
    final steps = [
      {'step': 'STEP 1', 'title': 'Write a review following the guide'},
      {'step': 'STEP 2', 'title': 'Submit it for verification'},
      {'step': 'STEP 3', 'title': 'We verify if it’s helpful for other shoppers'},
      {'step': 'STEP 4', 'title': 'Earn Z coins to spend on future orders'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(steps.length, (index) {
          final isLast = index == steps.length - 1;
          final item = steps[index];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Dot & Line
              Column(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.only(top: 3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 1.5,
                      height: 44,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: CustomPaint(
                        painter: _DashedLinePainter(
                          color: const Color(0xFFD1D5DB),
                          isVertical: true,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Step Text Info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['step']!,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ============================================================
  // 7. WHAT MAKES A REVIEW GOOD CARD
  // ============================================================
  Widget _buildWhatMakesReviewGoodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFF0F4) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF2B66) : const Color(0xFFD1D5DB),
                        width: isSelected ? 1.4 : 1.0,
                      ),
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? const Color(0xFFFF2B66) : const Color(0xFF374151),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Guideline subtext
          const Text(
            'Be specific about quality, fit, performance, material, results, usage etc.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),

          // Comparison Cards Horizontal Scroll / Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // Card 1: Clear & Real Photos
                _buildComparisonCard(
                  goodImage: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=300&q=80',
                  badImage: 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=300&q=80',
                  caption: 'Use clear & real\nproduct photos',
                ),
                const SizedBox(width: 14),

                // Card 2: Review product, not delivery
                _buildProductVsDeliveryCard(),
                const SizedBox(width: 14),

                // Card 3: Authentic usage details
                _buildComparisonCard(
                  goodImage: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=300&q=80',
                  badImage: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80',
                  caption: 'Show actual texture\nand proper usage',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Dotted Divider
          SizedBox(
            width: double.infinity,
            child: CustomPaint(
              painter: _DashedLinePainter(color: const Color(0xFFE5E7EB)),
            ),
          ),
          const SizedBox(height: 14),

          // Disclaimer Text
          const Text(
            'DISCLAIMER',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF9CA3AF),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'These guidelines are directional, not mandatory. Following them can improve your chances of approval, but does not guarantee that your review will earn Z Coins',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF6B7280),
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard({
    required String goodImage,
    required String badImage,
    required String caption,
  }) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Split Image Container
          SizedBox(
            height: 130,
            child: Row(
              children: [
                // Good photo
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(13)),
                          child: Image.network(
                            goodImage,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: _buildCheckBadge(),
                      ),
                    ],
                  ),
                ),
                Container(width: 1.5, color: Colors.white),
                // Bad photo
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(13)),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withValues(alpha: 0.35),
                              BlendMode.darken,
                            ),
                            child: Image.network(
                              badImage,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: _buildCrossBadge(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              caption,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductVsDeliveryCard() {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Split Image Container
          SizedBox(
            height: 130,
            child: Row(
              children: [
                // Good product (Gentle Cleanser)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(13)),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 28,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC084FC),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Serum\n100ml',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 6.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: _buildCheckBadge(),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 1.5, color: Colors.white),
                // Bad delivery bag
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(13)),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 42,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7E22CE),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Text(
                                    'zesty\nbag',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 7.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: _buildCrossBadge(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Caption
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              'Review product,\nnot delivery',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBadge() {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF10B981), width: 1.2),
      ),
      child: const Icon(
        Icons.check,
        color: Color(0xFF10B981),
        size: 11,
      ),
    );
  }

  Widget _buildCrossBadge() {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFEF4444), width: 1.2),
      ),
      child: const Icon(
        Icons.close,
        color: Color(0xFFEF4444),
        size: 11,
      ),
    );
  }

  // ============================================================
  // 8. OTHERS CARD (FAQs & T&C)
  // ============================================================
  Widget _buildOthersCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildOthersListTile(
            title: 'Frequently Asked Questions',
            onTap: _showFaqModal,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 1,
              color: Colors.grey.shade100,
            ),
          ),
          _buildOthersListTile(
            title: 'Terms & Conditions',
            onTap: _showTermsAndConditionsModal,
          ),
        ],
      ),
    );
  }

  Widget _buildOthersListTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF6B7280),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MODALS: FAQ & T&C
  // ============================================================
  void _showFaqModal() {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: const [
                  _FaqTile(
                    question: 'What are Z-Coins?',
                    answer: 'Z-Coins are reward points you earn by submitting genuine, high-quality reviews with real product photos. 1 Z-Coin = ₹1 and can be used on future orders.',
                  ),
                  _FaqTile(
                    question: 'How do I earn Z-Coins for a review?',
                    answer: 'Once you receive your order, head to the Review & Earn section. Select an eligible product, write a helpful review detailing your experience, upload clear photos, and submit.',
                  ),
                  _FaqTile(
                    question: 'How long does verification take?',
                    answer: 'Our moderation team verifies submitted reviews within 24 to 48 hours. Once approved, Z-Coins are automatically credited to your wallet.',
                  ),
                  _FaqTile(
                    question: 'Can I review cancelled or refunded items?',
                    answer: 'No, only delivered and non-returned products are eligible for earning rewards.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showTermsAndConditionsModal() {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: const [
                  Text(
                    '1. Eligibility:\nOnly verified buyers of delivered items on Zesty are eligible to write reviews and earn Z-Coins.',
                    style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF374151)),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '2. Review Quality Standards:\nReviews must be truthful, authentic, and focused on product attributes. Reviews focused exclusively on delivery delay or containing promotional content will be rejected.',
                    style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF374151)),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '3. Z-Coin Value & Redemption:\n1 Z-Coin equals ₹1 Zepto Cash credit. Z-Coins cannot be transferred or withdrawn to bank accounts directly and are non-negotiable.',
                    style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF374151)),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '4. Modification & Revocation:\nZesty reserves the right to withhold or revoke reward coins if reviews violate community guidelines or involve fraudulent activity.',
                    style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF374151)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// ============================================================
// DASHED LINE PAINTER
// ============================================================
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final bool isVertical;

  _DashedLinePainter({
    required this.color,
    this.isVertical = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;

    if (isVertical) {
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(0, startY),
          Offset(0, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    } else {
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
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isVertical != isVertical;
}

// ============================================================
// FAQ TILE WIDGET
// ============================================================
class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFFFF2B66),
          collapsedIconColor: const Color(0xFF6B7280),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
