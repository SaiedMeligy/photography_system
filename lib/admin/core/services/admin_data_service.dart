import 'package:hive_flutter/hive_flutter.dart';
import '../models/site_settings.dart';
import '../models/portfolio_category.dart';
import '../models/package_model.dart';
import '../models/testimonial_model.dart';
import '../models/booking_calendar_model.dart';

/// Central Hive service — all admin data access goes through here.
/// Boxes are plain dynamic boxes; data is serialized as Maps.
///
/// To swap to a backend later, replace these methods with API calls.
class AdminDataService {
  static const _settingsBox = 'settings';
  static const _portfolioBox = 'portfolio';
  static const _packagesBox = 'packages';
  static const _testimonialsBox = 'testimonials';
  static const _bookingBox = 'booking';

  /// Must be called once at app startup.
  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(_settingsBox),
      Hive.openBox(_portfolioBox),
      Hive.openBox(_packagesBox),
      Hive.openBox(_testimonialsBox),
      Hive.openBox(_bookingBox),
    ]);
    await _seedDefaultsIfEmpty();
  }

  // ─── Seeding ──────────────────────────────────────────────────
  static Future<void> _seedDefaultsIfEmpty() async {
    if (getSiteSettings() == null) {
      await saveSiteSettings(const SiteSettings());
    }
    if (getPackages().isEmpty) {
      for (final pkg in PackageModel.defaults) {
        await savePackage(pkg);
      }
    }
    if (getTestimonials().isEmpty) {
      for (final t in TestimonialModel.defaults) {
        await saveTestimonial(t);
      }
    }
  }

  // ─── Site Settings ────────────────────────────────────────────
  static SiteSettings? getSiteSettings() {
    final box = Hive.box(_settingsBox);
    final raw = box.get('site');
    if (raw == null) return null;
    return SiteSettings.fromMap(raw as Map);
  }

  static Future<void> saveSiteSettings(SiteSettings s) async {
    await Hive.box(_settingsBox).put('site', s.toMap());
  }

  // ─── Portfolio ────────────────────────────────────────────────
  static List<PortfolioCategory> getCategories() {
    final box = Hive.box(_portfolioBox);
    return box.values
        .map((e) => PortfolioCategory.fromMap(e as Map))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  static Future<void> saveCategory(PortfolioCategory cat) async {
    await Hive.box(_portfolioBox).put(cat.id, cat.toMap());
  }

  static Future<void> deleteCategory(String id) async {
    await Hive.box(_portfolioBox).delete(id);
  }

  // ─── Packages ─────────────────────────────────────────────────
  static List<PackageModel> getPackages() {
    final box = Hive.box(_packagesBox);
    return box.values.map((e) => PackageModel.fromMap(e as Map)).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  static Future<void> savePackage(PackageModel pkg) async {
    await Hive.box(_packagesBox).put(pkg.id, pkg.toMap());
  }

  static Future<void> deletePackage(String id) async {
    await Hive.box(_packagesBox).delete(id);
  }

  // ─── Testimonials ─────────────────────────────────────────────
  static List<TestimonialModel> getTestimonials() {
    final box = Hive.box(_testimonialsBox);
    return box.values.map((e) => TestimonialModel.fromMap(e as Map)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> saveTestimonial(TestimonialModel t) async {
    await Hive.box(_testimonialsBox).put(t.id, t.toMap());
  }

  static Future<void> deleteTestimonial(String id) async {
    await Hive.box(_testimonialsBox).delete(id);
  }

  // ─── Booking Calendar ─────────────────────────────────────────
  static BookingCalendarModel getBookingCalendar() {
    final box = Hive.box(_bookingBox);
    final raw = box.get('calendar');
    if (raw == null) return BookingCalendarModel();
    return BookingCalendarModel.fromMap(raw as Map);
  }

  static Future<void> saveBookingCalendar(BookingCalendarModel cal) async {
    await Hive.box(_bookingBox).put('calendar', cal.toMap());
  }
}
