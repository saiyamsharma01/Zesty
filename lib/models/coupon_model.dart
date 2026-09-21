class CouponModel {
  final String code;
  final String title;
  final String shortTitle;
  final String subtitle;
  final double discountAmount;
  final double minOrderValue;
  final String description;
  final List<String> termsAndConditions;
  final bool isBankOffer;
  final String? bankName;
  final String? bankSubtitle;

  const CouponModel({
    required this.code,
    required this.title,
    required this.shortTitle,
    required this.subtitle,
    required this.discountAmount,
    required this.minOrderValue,
    this.description = '',
    this.termsAndConditions = const [
      'Offer applicable only in cities where Zepto is operational',
      'Offer not applicable on products that are restricted or regulated by law.',
      'Zepto has the right to amend the terms and conditions, end the Offer, or call back any or all of its Offers without any prior notice.',
    ],
    this.isBankOffer = false,
    this.bankName,
    this.bankSubtitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'title': title,
      'shortTitle': shortTitle,
      'subtitle': subtitle,
      'discountAmount': discountAmount,
      'minOrderValue': minOrderValue,
      'description': description,
      'termsAndConditions': termsAndConditions,
      'isBankOffer': isBankOffer,
      'bankName': bankName,
      'bankSubtitle': bankSubtitle,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      shortTitle: map['shortTitle'] ?? '',
      subtitle: map['subtitle'] ?? '',
      discountAmount: (map['discountAmount'] as num?)?.toDouble() ?? 0.0,
      minOrderValue: (map['minOrderValue'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      termsAndConditions: (map['termsAndConditions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [
            'Offer applicable only in cities where Zepto is operational',
            'Offer not applicable on products that are restricted or regulated by law.',
            'Zepto has the right to amend the terms and conditions, end the Offer, or call back any or all of its Offers without any prior notice.',
          ],
      isBankOffer: map['isBankOffer'] ?? false,
      bankName: map['bankName'],
      bankSubtitle: map['bankSubtitle'],
    );
  }
}

class CouponData {
  static const List<CouponModel> defaultCoupons = [
    CouponModel(
      code: 'DISCOUNT50',
      title: 'Flat ₹50 Off',
      shortTitle: 'FLAT\n₹50 OFF',
      subtitle: 'above ₹699',
      discountAmount: 50.0,
      minOrderValue: 699.0,
      description: 'Get Flat ₹50 discount on orders above ₹699',
    ),
    CouponModel(
      code: 'BIGSAVE100',
      title: 'Flat ₹100 Off',
      shortTitle: 'FLAT\n₹100 OFF',
      subtitle: 'above ₹1299',
      discountAmount: 100.0,
      minOrderValue: 1299.0,
      description: 'Get Flat ₹100 discount on orders above ₹1299',
    ),
    CouponModel(
      code: 'ULTRAPERK150',
      title: 'Flat ₹150 Off',
      shortTitle: 'FLAT\n₹150 OFF',
      subtitle: 'above ₹1899',
      discountAmount: 150.0,
      minOrderValue: 1899.0,
      description: 'Get Flat ₹150 discount on orders above ₹1899',
    ),
    CouponModel(
      code: 'PLUSREWARD200',
      title: 'Flat ₹200 Off',
      shortTitle: 'FLAT\n₹200 OFF',
      subtitle: 'above ₹2499',
      discountAmount: 200.0,
      minOrderValue: 2499.0,
      description: 'Get Flat ₹200 discount on orders above ₹2499',
    ),
  ];

  static const List<CouponModel> bankOffers = [
    CouponModel(
      code: 'BHIM50',
      title: 'Get upto ₹50 instant cashback with BHIM App',
      shortTitle: 'BHIM\n₹50 CB',
      subtitle: 'above ₹99',
      discountAmount: 50.0,
      minOrderValue: 99.0,
      isBankOffer: true,
      bankName: 'BHIM UPI',
      bankSubtitle: 'Valid on orders above ₹99',
      description: 'Pay using BHIM UPI and get instant ₹50 cashback',
    ),
    CouponModel(
      code: 'AMAZON50',
      title: 'Get Upto ₹50 Cashback on using Amazon Pay',
      shortTitle: 'AMAZON\n₹50 CB',
      subtitle: 'above ₹199',
      discountAmount: 50.0,
      minOrderValue: 199.0,
      isBankOffer: true,
      bankName: 'Amazon Pay',
      bankSubtitle: 'Valid on orders above ₹199',
      description: 'Use Amazon Pay Wallet/UPI to get up to ₹50 cashback',
    ),
    CouponModel(
      code: 'CRED75',
      title: 'Get Flat ₹75 Cashback using CRED UPI',
      shortTitle: 'CRED\n₹75 CB',
      subtitle: 'above ₹299',
      discountAmount: 75.0,
      minOrderValue: 299.0,
      isBankOffer: true,
      bankName: 'CRED UPI',
      bankSubtitle: 'Valid on orders above ₹299',
      description: 'Get assured ₹75 cashback with CRED UPI payments',
    ),
    CouponModel(
      code: 'PAYTM50',
      title: 'Get upto ₹50 Cashback with Paytm UPI',
      shortTitle: 'PAYTM\n₹50 CB',
      subtitle: 'above ₹149',
      discountAmount: 50.0,
      minOrderValue: 149.0,
      isBankOffer: true,
      bankName: 'Paytm UPI',
      bankSubtitle: 'Valid on orders above ₹149',
      description: 'Instant ₹50 savings on Paytm UPI transaction',
    ),
  ];

  static List<CouponModel> get allCoupons => [...defaultCoupons, ...bankOffers];

  static CouponModel? getCouponByCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    try {
      return allCoupons.firstWhere((c) => c.code.toUpperCase() == cleanCode);
    } catch (_) {
      // Dynamic fallback for custom coupons like DISCOUNT50, BIGSAVE100, etc.
      if (cleanCode.contains('50')) {
        return CouponModel(
          code: cleanCode,
          title: 'Flat ₹50 Off',
          shortTitle: 'FLAT\n₹50 OFF',
          subtitle: 'above ₹699',
          discountAmount: 50.0,
          minOrderValue: 699.0,
        );
      } else if (cleanCode.contains('100')) {
        return CouponModel(
          code: cleanCode,
          title: 'Flat ₹100 Off',
          shortTitle: 'FLAT\n₹100 OFF',
          subtitle: 'above ₹1299',
          discountAmount: 100.0,
          minOrderValue: 1299.0,
        );
      } else if (cleanCode.contains('150')) {
        return CouponModel(
          code: cleanCode,
          title: 'Flat ₹150 Off',
          shortTitle: 'FLAT\n₹150 OFF',
          subtitle: 'above ₹1899',
          discountAmount: 150.0,
          minOrderValue: 1899.0,
        );
      } else if (cleanCode.contains('200')) {
        return CouponModel(
          code: cleanCode,
          title: 'Flat ₹200 Off',
          shortTitle: 'FLAT\n₹200 OFF',
          subtitle: 'above ₹2499',
          discountAmount: 200.0,
          minOrderValue: 2499.0,
        );
      }
      return null;
    }
  }
}
