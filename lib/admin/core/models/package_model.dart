import 'package:uuid/uuid.dart';

/// A photography package offered by the photographer.
class PackageModel {
  final String id;
  String tier;       // e.g. "Package 1"
  String tierAr;
  String name;       // e.g. "Basic"
  String nameAr;
  String duration;
  String durationAr;
  double price;
  String currency;
  List<String> features;     // EN features
  List<String> featuresAr;   // AR features
  bool isPopular;
  int sortOrder;

  PackageModel({
    String? id,
    required this.tier,
    required this.tierAr,
    required this.name,
    required this.nameAr,
    required this.duration,
    required this.durationAr,
    required this.price,
    this.currency = 'LE',
    List<String>? features,
    List<String>? featuresAr,
    this.isPopular = false,
    this.sortOrder = 0,
  })  : id = id ?? const Uuid().v4(),
        features = features ?? [],
        featuresAr = featuresAr ?? [];

  Map<String, dynamic> toMap() => {
        'id': id,
        'tier': tier,
        'tierAr': tierAr,
        'name': name,
        'nameAr': nameAr,
        'duration': duration,
        'durationAr': durationAr,
        'price': price,
        'currency': currency,
        'features': features,
        'featuresAr': featuresAr,
        'isPopular': isPopular,
        'sortOrder': sortOrder,
      };

  factory PackageModel.fromMap(Map<dynamic, dynamic> map) => PackageModel(
        id: map['id'],
        tier: map['tier'] ?? '',
        tierAr: map['tierAr'] ?? '',
        name: map['name'] ?? '',
        nameAr: map['nameAr'] ?? '',
        duration: map['duration'] ?? '',
        durationAr: map['durationAr'] ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0,
        currency: map['currency'] ?? 'LE',
        features: List<String>.from(map['features'] ?? []),
        featuresAr: List<String>.from(map['featuresAr'] ?? []),
        isPopular: map['isPopular'] ?? false,
        sortOrder: map['sortOrder'] ?? 0,
      );

  /// Default packages to pre-populate on first run.
  static List<PackageModel> get defaults => [
        PackageModel(
          tier: 'Package 1',
          tierAr: 'الباكدج الأول',
          name: 'Basic',
          nameAr: 'أساسي',
          duration: '1 Hour',
          durationAr: 'ساعة واحدة',
          price: 2500,
          features: ['Photography Session', 'Flash Drive'],
          featuresAr: ['تصوير السيشن', 'فلاشة'],
          sortOrder: 0,
        ),
        PackageModel(
          tier: 'Package 2',
          tierAr: 'الباكدج الثاني',
          name: 'Half Day',
          nameAr: 'نصف يوم',
          duration: '6 Hours',
          durationAr: '6 ساعات',
          price: 3500,
          features: [
            'Photography Session + Preparations',
            'Album 30×45',
            'Tableau 30×40',
            'Flash Drive'
          ],
          featuresAr: [
            'تصوير السيشن + التجهيزات',
            'اللبوم 30×45',
            'تابلوه 30×40',
            'فلاشة'
          ],
          isPopular: true,
          sortOrder: 1,
        ),
        PackageModel(
          tier: 'Package 3',
          tierAr: 'الباكدج الثالث',
          name: 'Full Day',
          nameAr: 'يوم كامل',
          duration: '12 Hours',
          durationAr: '12 ساعة',
          price: 4000,
          features: [
            'Photography Session + Preparations',
            'Hall Photography',
            'Album 30×45',
            'Tableau 70×50',
            'Flash Drive'
          ],
          featuresAr: [
            'تصوير السيشن + التجهيزات',
            'تصوير القاعة',
            'اللبوم 30×45',
            'تابلوه 70×50',
            'فلاشة'
          ],
          sortOrder: 2,
        ),
      ];
}
