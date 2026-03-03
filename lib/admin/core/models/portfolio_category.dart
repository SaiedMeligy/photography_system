import 'package:uuid/uuid.dart';

/// Represents a portfolio category (e.g. Wedding, Engagement, Birthday).
class PortfolioCategory {
  final String id;
  String name;
  String nameAr;
  String coverImage; // asset path or URL
  List<PortfolioImage> images;
  int sortOrder;

  PortfolioCategory({
    String? id,
    required this.name,
    required this.nameAr,
    this.coverImage = '',
    List<PortfolioImage>? images,
    this.sortOrder = 0,
  })  : id = id ?? const Uuid().v4(),
        images = images ?? [];

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'nameAr': nameAr,
        'coverImage': coverImage,
        'images': images.map((e) => e.toMap()).toList(),
        'sortOrder': sortOrder,
      };

  factory PortfolioCategory.fromMap(Map<dynamic, dynamic> map) =>
      PortfolioCategory(
        id: map['id'],
        name: map['name'] ?? '',
        nameAr: map['nameAr'] ?? '',
        coverImage: map['coverImage'] ?? '',
        images: (map['images'] as List<dynamic>? ?? [])
            .map((e) => PortfolioImage.fromMap(e as Map))
            .toList(),
        sortOrder: map['sortOrder'] ?? 0,
      );
}

/// A single image inside a portfolio category.
class PortfolioImage {
  final String id;
  String path; // asset path or network URL
  String caption;
  String captionAr;

  PortfolioImage({
    String? id,
    required this.path,
    this.caption = '',
    this.captionAr = '',
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'path': path,
        'caption': caption,
        'captionAr': captionAr,
      };

  factory PortfolioImage.fromMap(Map<dynamic, dynamic> map) => PortfolioImage(
        id: map['id'],
        path: map['path'] ?? '',
        caption: map['caption'] ?? '',
        captionAr: map['captionAr'] ?? '',
      );
}
