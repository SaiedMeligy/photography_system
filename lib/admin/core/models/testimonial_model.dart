import 'package:uuid/uuid.dart';

/// A client testimonial/review.
class TestimonialModel {
  final String id;
  String clientName;
  String eventDescription; // e.g. "October Wedding 2024"
  String reviewText;
  double rating;
  DateTime date;
  bool isApproved;

  TestimonialModel({
    String? id,
    required this.clientName,
    required this.eventDescription,
    required this.reviewText,
    this.rating = 5.0,
    DateTime? date,
    this.isApproved = true,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'clientName': clientName,
        'eventDescription': eventDescription,
        'reviewText': reviewText,
        'rating': rating,
        'date': date.toIso8601String(),
        'isApproved': isApproved,
      };

  factory TestimonialModel.fromMap(Map<dynamic, dynamic> map) =>
      TestimonialModel(
        id: map['id'],
        clientName: map['clientName'] ?? '',
        eventDescription: map['eventDescription'] ?? '',
        reviewText: map['reviewText'] ?? '',
        rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
        date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
        isApproved: map['isApproved'] ?? true,
      );

  /// Default sample testimonials.
  static List<TestimonialModel> get defaults => [
        TestimonialModel(
          clientName: 'محمد وفاطمة',
          eventDescription: 'فرح نوفمبر 2024',
          reviewText:
              'ابراهيم مبقاش بس مصور، ده فنان بيحس باللحظة. كل صورة حسينا فيها إحنا تاني مع بعض.',
          date: DateTime(2024, 11, 15),
        ),
        TestimonialModel(
          clientName: 'أحمد ونور',
          eventDescription: 'فرح أكتوبر 2024',
          reviewText:
              'من أول ما دخلنا الكوشة لحد ما طلعنا، كان موجود في كل حتة. الصور جميلة جداً.',
          date: DateTime(2024, 10, 20),
        ),
        TestimonialModel(
          clientName: 'كريم وياسمين',
          eventDescription: 'فرح سبتمبر 2024',
          reviewText:
              'الألبوم جه أحسن من أي حاجة تخيلتها! شكراً ابراهيم على كل لحظة حلوة.',
          date: DateTime(2024, 9, 5),
        ),
      ];
}
