/// All configurable text and settings for the website.
/// Stored in Hive as a single Map under key 'site_settings'.
class SiteSettings {
  // ─── Photographer Identity ──────────────────────────────────
  final String photographerName;
  final String photographerTagline;
  final String whatsappNumber;
  final String instagramHandle;
  final String instagramUrl;
  final String facebookUrl;
  final String locationAddress;
  final String locationMapsUrl;

  // ─── Theming & Logo ─────────────────────────────────────────
  final String primaryColorHex;
  final String logoText;

  // ─── Hero Section ───────────────────────────────────────────
  final String heroEyebrow;
  final String heroTitle1;
  final String heroTitle2;
  final String heroTitle3;
  final String heroDescription;
  final String heroImage;

  // ─── About Section ──────────────────────────────────────────
  final String aboutTitle1;
  final String aboutTitle2;
  final String aboutParagraph1;
  final String aboutParagraph2;
  final String aboutImage;

  // ─── Stats ──────────────────────────────────────────────────
  final String statWeddingsValue;
  final String statYearsValue;
  final String statHappyValue;
  final String statPhotosValue;

  // ─── Footer ─────────────────────────────────────────────────
  final String footerTagline;

  const SiteSettings({
    this.photographerName = 'iBrahiim Photography',
    this.photographerTagline = 'PHOTOGRAPHY',
    this.whatsappNumber = '201155699971',
    this.instagramHandle = '@HEEMA.GAMAL_PH',
    this.instagramUrl = 'https://www.instagram.com/heema.gamal_ph',
    this.facebookUrl = '',
    this.locationAddress = '25 شارع الشركات - الزاوية الحمراء - القاهرة',
    this.locationMapsUrl = 'https://maps.google.com',
    this.primaryColorHex = 'D4AF37', // Default gold
    this.logoText = 'iBrahiim',
    this.heroEyebrow = 'تصوير الأفراح',
    this.heroTitle1 = 'بنحكي',
    this.heroTitle2 = 'حكايتك',
    this.heroTitle3 = 'للأبد.',
    this.heroDescription = 'احنا مش بس بنصور — احنا بنحكي حكايتك.',
    this.heroImage = '',
    this.aboutTitle1 = 'الفنان',
    this.aboutTitle2 = 'خلف العدسة',
    this.aboutParagraph1 = 'ببساطة، أنا مؤمن إن كل فرح له روح خاصة.',
    this.aboutParagraph2 = 'صورت أكثر من 200 فرح، وكل صورة كانت من قلبي.',
    this.aboutImage = '',
    this.statWeddingsValue = '200+',
    this.statYearsValue = '5+',
    this.statHappyValue = '98%',
    this.statPhotosValue = '50K+',
    this.footerTagline = 'نصور اللحظات مش بس الصور — احنا بنحكي حكايتك للأبد.',
  });

  SiteSettings copyWith({
    String? photographerName,
    String? photographerTagline,
    String? whatsappNumber,
    String? instagramHandle,
    String? instagramUrl,
    String? facebookUrl,
    String? locationAddress,
    String? locationMapsUrl,
    String? primaryColorHex,
    String? logoText,
    String? heroEyebrow,
    String? heroTitle1,
    String? heroTitle2,
    String? heroTitle3,
    String? heroDescription,
    String? heroImage,
    String? aboutTitle1,
    String? aboutTitle2,
    String? aboutParagraph1,
    String? aboutParagraph2,
    String? aboutImage,
    String? statWeddingsValue,
    String? statYearsValue,
    String? statHappyValue,
    String? statPhotosValue,
    String? footerTagline,
  }) {
    return SiteSettings(
      photographerName: photographerName ?? this.photographerName,
      photographerTagline: photographerTagline ?? this.photographerTagline,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      locationAddress: locationAddress ?? this.locationAddress,
      locationMapsUrl: locationMapsUrl ?? this.locationMapsUrl,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      logoText: logoText ?? this.logoText,
      heroEyebrow: heroEyebrow ?? this.heroEyebrow,
      heroTitle1: heroTitle1 ?? this.heroTitle1,
      heroTitle2: heroTitle2 ?? this.heroTitle2,
      heroTitle3: heroTitle3 ?? this.heroTitle3,
      heroDescription: heroDescription ?? this.heroDescription,
      heroImage: heroImage ?? this.heroImage,
      aboutTitle1: aboutTitle1 ?? this.aboutTitle1,
      aboutTitle2: aboutTitle2 ?? this.aboutTitle2,
      aboutParagraph1: aboutParagraph1 ?? this.aboutParagraph1,
      aboutParagraph2: aboutParagraph2 ?? this.aboutParagraph2,
      aboutImage: aboutImage ?? this.aboutImage,
      statWeddingsValue: statWeddingsValue ?? this.statWeddingsValue,
      statYearsValue: statYearsValue ?? this.statYearsValue,
      statHappyValue: statHappyValue ?? this.statHappyValue,
      statPhotosValue: statPhotosValue ?? this.statPhotosValue,
      footerTagline: footerTagline ?? this.footerTagline,
    );
  }

  Map<String, dynamic> toMap() => {
        'photographerName': photographerName,
        'photographerTagline': photographerTagline,
        'whatsappNumber': whatsappNumber,
        'instagramHandle': instagramHandle,
        'instagramUrl': instagramUrl,
        'facebookUrl': facebookUrl,
        'locationAddress': locationAddress,
        'locationMapsUrl': locationMapsUrl,
        'primaryColorHex': primaryColorHex,
        'logoText': logoText,
        'heroEyebrow': heroEyebrow,
        'heroTitle1': heroTitle1,
        'heroTitle2': heroTitle2,
        'heroTitle3': heroTitle3,
        'heroDescription': heroDescription,
        'heroImage': heroImage,
        'aboutTitle1': aboutTitle1,
        'aboutTitle2': aboutTitle2,
        'aboutParagraph1': aboutParagraph1,
        'aboutParagraph2': aboutParagraph2,
        'aboutImage': aboutImage,
        'statWeddingsValue': statWeddingsValue,
        'statYearsValue': statYearsValue,
        'statHappyValue': statHappyValue,
        'statPhotosValue': statPhotosValue,
        'footerTagline': footerTagline,
      };

  factory SiteSettings.fromMap(Map<dynamic, dynamic> map) => SiteSettings(
        photographerName: map['photographerName'] ?? 'iBrahiim Photography',
        photographerTagline: map['photographerTagline'] ?? 'PHOTOGRAPHY',
        whatsappNumber: map['whatsappNumber'] ?? '201155699971',
        instagramHandle: map['instagramHandle'] ?? '@HEEMA.GAMAL_PH',
        instagramUrl: map['instagramUrl'] ?? '',
        facebookUrl: map['facebookUrl'] ?? '',
        locationAddress: map['locationAddress'] ?? '',
        locationMapsUrl: map['locationMapsUrl'] ?? '',
        primaryColorHex: map['primaryColorHex'] ?? 'D4AF37',
        logoText: map['logoText'] ?? 'iBrahiim',
        heroEyebrow: map['heroEyebrow'] ?? 'تصوير الأفراح',
        heroTitle1: map['heroTitle1'] ?? 'بنحكي',
        heroTitle2: map['heroTitle2'] ?? 'حكايتك',
        heroTitle3: map['heroTitle3'] ?? 'للأبد.',
        heroDescription: map['heroDescription'] ?? '',
        heroImage: map['heroImage'] ?? '',
        aboutTitle1: map['aboutTitle1'] ?? 'الفنان',
        aboutTitle2: map['aboutTitle2'] ?? 'خلف العدسة',
        aboutParagraph1: map['aboutParagraph1'] ?? '',
        aboutParagraph2: map['aboutParagraph2'] ?? '',
        aboutImage: map['aboutImage'] ?? '',
        statWeddingsValue: map['statWeddingsValue'] ?? '200+',
        statYearsValue: map['statYearsValue'] ?? '5+',
        statHappyValue: map['statHappyValue'] ?? '98%',
        statPhotosValue: map['statPhotosValue'] ?? '50K+',
        footerTagline: map['footerTagline'] ?? '',
      );
}
