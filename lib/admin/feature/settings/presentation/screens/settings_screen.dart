import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photgraphy_system/admin/core/models/site_settings.dart';
import 'package:photgraphy_system/admin/core/theme/admin_theme.dart';
import 'package:photgraphy_system/admin/feature/settings/cubit/settings_state.dart';
import 'package:image_picker/image_picker.dart';
import '../../cubit/settings_cubit.dart';
import '../widgets/admin_section_card.dart';
import '../widgets/admin_form_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ─── Identity ─────────────────────────────────────────────
  late final TextEditingController _nameCtrl;
  late final TextEditingController _whatsappCtrl;
  late final TextEditingController _igHandleCtrl;
  late final TextEditingController _igUrlCtrl;
  late final TextEditingController _fbUrlCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _mapsCtrl;

  // ─── Theming & Logo ───────────────────────────────────────
  late final TextEditingController _primaryColorCtrl;
  late final TextEditingController _logoTextCtrl;

  // ─── Hero ─────────────────────────────────────────────────
  late final TextEditingController _eyebrowCtrl;
  late final TextEditingController _heroT1Ctrl;
  late final TextEditingController _heroT2Ctrl;
  late final TextEditingController _heroT3Ctrl;
  late final TextEditingController _heroDescCtrl;
  late final TextEditingController _heroImageCtrl;

  // ─── About ────────────────────────────────────────────────
  late final TextEditingController _aboutT1Ctrl;
  late final TextEditingController _aboutT2Ctrl;
  late final TextEditingController _aboutP1Ctrl;
  late final TextEditingController _aboutP2Ctrl;
  late final TextEditingController _aboutImageCtrl;

  // ─── Stats ────────────────────────────────────────────────
  late final TextEditingController _statWeddingsCtrl;
  late final TextEditingController _statYearsCtrl;
  late final TextEditingController _statHappyCtrl;
  late final TextEditingController _statPhotosCtrl;

  // ─── Footer ───────────────────────────────────────────────
  late final TextEditingController _footerCtrl;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().load();
  }

  void _initControllers(SiteSettings s) {
    if (_initialized) return;
    _initialized = true;

    _nameCtrl = TextEditingController(text: s.photographerName);
    _whatsappCtrl = TextEditingController(text: s.whatsappNumber);
    _igHandleCtrl = TextEditingController(text: s.instagramHandle);
    _igUrlCtrl = TextEditingController(text: s.instagramUrl);
    _fbUrlCtrl = TextEditingController(text: s.facebookUrl);
    _locationCtrl = TextEditingController(text: s.locationAddress);
    _mapsCtrl = TextEditingController(text: s.locationMapsUrl);
    _primaryColorCtrl = TextEditingController(text: s.primaryColorHex);
    _logoTextCtrl = TextEditingController(text: s.logoText);
    _eyebrowCtrl = TextEditingController(text: s.heroEyebrow);
    _heroT1Ctrl = TextEditingController(text: s.heroTitle1);
    _heroT2Ctrl = TextEditingController(text: s.heroTitle2);
    _heroT3Ctrl = TextEditingController(text: s.heroTitle3);
    _heroDescCtrl = TextEditingController(text: s.heroDescription);
    _heroImageCtrl = TextEditingController(text: s.heroImage);
    _aboutT1Ctrl = TextEditingController(text: s.aboutTitle1);
    _aboutT2Ctrl = TextEditingController(text: s.aboutTitle2);
    _aboutP1Ctrl = TextEditingController(text: s.aboutParagraph1);
    _aboutP2Ctrl = TextEditingController(text: s.aboutParagraph2);
    _aboutImageCtrl = TextEditingController(text: s.aboutImage);
    _statWeddingsCtrl = TextEditingController(text: s.statWeddingsValue);
    _statYearsCtrl = TextEditingController(text: s.statYearsValue);
    _statHappyCtrl = TextEditingController(text: s.statHappyValue);
    _statPhotosCtrl = TextEditingController(text: s.statPhotosValue);
    _footerCtrl = TextEditingController(text: s.footerTagline);
  }

  @override
  void dispose() {
    for (final c in _allControllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> get _allControllers {
    if (!_initialized) return [];
    return [
      _nameCtrl, _whatsappCtrl, _igHandleCtrl, _igUrlCtrl, _fbUrlCtrl,
      _locationCtrl, _mapsCtrl, _primaryColorCtrl, _logoTextCtrl, _eyebrowCtrl, _heroT1Ctrl, _heroT2Ctrl,
      _heroT3Ctrl, _heroDescCtrl, _heroImageCtrl, _aboutT1Ctrl, _aboutT2Ctrl,
      _aboutP1Ctrl, _aboutP2Ctrl, _aboutImageCtrl, _statWeddingsCtrl, _statYearsCtrl,
      _statHappyCtrl, _statPhotosCtrl, _footerCtrl,
    ];
  }

  void _save(SiteSettings current) {
    final updated = current.copyWith(
      photographerName: _nameCtrl.text.trim(),
      whatsappNumber: _whatsappCtrl.text.trim(),
      instagramHandle: _igHandleCtrl.text.trim(),
      instagramUrl: _igUrlCtrl.text.trim(),
      facebookUrl: _fbUrlCtrl.text.trim(),
      locationAddress: _locationCtrl.text.trim(),
      locationMapsUrl: _mapsCtrl.text.trim(),
      primaryColorHex: _primaryColorCtrl.text.trim(),
      logoText: _logoTextCtrl.text.trim(),
      heroEyebrow: _eyebrowCtrl.text.trim(),
      heroTitle1: _heroT1Ctrl.text.trim(),
      heroTitle2: _heroT2Ctrl.text.trim(),
      heroTitle3: _heroT3Ctrl.text.trim(),
      heroDescription: _heroDescCtrl.text.trim(),
      heroImage: _heroImageCtrl.text.trim(),
      aboutTitle1: _aboutT1Ctrl.text.trim(),
      aboutTitle2: _aboutT2Ctrl.text.trim(),
      aboutParagraph1: _aboutP1Ctrl.text.trim(),
      aboutParagraph2: _aboutP2Ctrl.text.trim(),
      aboutImage: _aboutImageCtrl.text.trim(),
      statWeddingsValue: _statWeddingsCtrl.text.trim(),
      statYearsValue: _statYearsCtrl.text.trim(),
      statHappyValue: _statHappyCtrl.text.trim(),
      statPhotosValue: _statPhotosCtrl.text.trim(),
      footerTagline: _footerCtrl.text.trim(),
    );
    context.read<SettingsCubit>().save(updated);
  }

  Future<void> _pickImage(TextEditingController controller) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        controller.text = xFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Trigger rebuild on locale change
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.saveStatus == SaveStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr('admin_save_success')),
              backgroundColor: AdminTheme.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading || state.settings == null) {
          return const Center(
              child: CircularProgressIndicator(color: AdminTheme.gold));
        }

        final s = state.settings!;
        _initControllers(s);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Page Header ──────────────────────────────
              Row(
                children: [
                  Text(tr('admin_nav_settings'),
                      style: AdminTheme.headline(22)),
                  const Spacer(),
                  _SaveButton(
                    status: state.saveStatus,
                    onSave: () => _save(s),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ─── Sections ─────────────────────────────────
              AdminSectionCard(
                title: tr('admin_sec_identity'),
                icon: Icons.person_outline_rounded,
                children: [
                  _Row2(
                    left: AdminFormField(
                        label: tr('admin_field_name'), controller: _nameCtrl),
                    right: AdminFormField(
                        label: tr('admin_field_whatsapp'),
                        controller: _whatsappCtrl),
                  ),
                  const SizedBox(height: 16),
                  _Row2(
                    left: AdminFormField(
                        label: tr('admin_field_instagram_handle'),
                        controller: _igHandleCtrl),
                    right: AdminFormField(
                        label: tr('admin_field_instagram_url'),
                        controller: _igUrlCtrl),
                  ),
                  const SizedBox(height: 16),
                  _Row2(
                    left: AdminFormField(
                        label: tr('admin_field_facebook'),
                        controller: _fbUrlCtrl),
                    right: AdminFormField(
                        label: tr('admin_field_location'),
                        controller: _locationCtrl),
                  ),
                  const SizedBox(height: 16),
                  AdminFormField(
                      label: tr('admin_field_maps'), controller: _mapsCtrl),
                ],
              ),
              const SizedBox(height: 20),

              AdminSectionCard(
                title: tr('admin_sec_theming') ?? 'Theming',
                icon: Icons.color_lens_outlined,
                children: [
                  _Row2(
                    left: AdminFormField(
                        label: tr('admin_field_primary_color'),
                        controller: _primaryColorCtrl),
                    right: AdminFormField(
                        label: tr('admin_field_logo_text'),
                        controller: _logoTextCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              AdminSectionCard(
                title: tr('admin_sec_hero'),
                icon: Icons.web_rounded,
                children: [
                  _Row2(
                    left: AdminFormField(
                        label: tr('admin_field_hero_eyebrow'),
                        controller: _eyebrowCtrl),
                    right: AdminFormField(
                        label: tr('admin_field_hero_t2'),
                        controller: _heroT2Ctrl),
                  ),
                  const SizedBox(height: 16),
                  _Row3(
                    c1: AdminFormField(
                        label: tr('admin_field_hero_t1'),
                        controller: _heroT1Ctrl),
                    c2: AdminFormField(
                        label: tr('admin_field_hero_t3'),
                        controller: _heroT3Ctrl),
                    c3: const SizedBox(),
                  ),
                  const SizedBox(height: 16),
                  AdminFormField(
                    label: tr('admin_field_hero_desc'),
                    controller: _heroDescCtrl,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  AdminFormField(
                    label: tr('admin_field_hero_image'),
                    controller: _heroImageCtrl,
                    suffix: IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: () => _pickImage(_heroImageCtrl),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              AdminSectionCard(
                title: tr('admin_sec_about'),
                icon: Icons.info_outline_rounded,
                children: [
                  _Row2(
                    left: AdminFormField(
                        label: tr('admin_field_about_t1'),
                        controller: _aboutT1Ctrl),
                    right: AdminFormField(
                        label: tr('admin_field_about_t2'),
                        controller: _aboutT2Ctrl),
                  ),
                  const SizedBox(height: 16),
                  AdminFormField(
                      label: tr('admin_field_about_p1'),
                      controller: _aboutP1Ctrl,
                      maxLines: 4),
                  const SizedBox(height: 16),
                  AdminFormField(
                      label: tr('admin_field_about_p2'),
                      controller: _aboutP2Ctrl,
                      maxLines: 4),
                  const SizedBox(height: 16),
                  AdminFormField(
                    label: tr('admin_field_about_image'),
                    controller: _aboutImageCtrl,
                    suffix: IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: () => _pickImage(_aboutImageCtrl),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              AdminSectionCard(
                title: tr('admin_sec_stats'),
                icon: Icons.bar_chart_rounded,
                children: [
                  _Row2(
                    left: AdminFormField(
                        label: tr('admin_field_stat_weddings'),
                        controller: _statWeddingsCtrl),
                    right: AdminFormField(
                        label: tr('admin_field_stat_years'),
                        controller: _statYearsCtrl),
                  ),
                  const SizedBox(height: 16),
                  _Row2(
                    left: AdminFormField(
                        label: tr('admin_field_stat_happy'),
                        controller: _statHappyCtrl),
                    right: AdminFormField(
                        label: tr('admin_field_stat_photos'),
                        controller: _statPhotosCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              AdminSectionCard(
                title: tr('admin_sec_footer'),
                icon: Icons.view_headline_rounded,
                children: [
                  AdminFormField(
                    label: tr('admin_field_footer_tagline'),
                    controller: _footerCtrl,
                    maxLines: 2,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ─── Save button (bottom) ──────────────────────
              SizedBox(
                width: double.infinity,
                child: _SaveButton(
                  status: state.saveStatus,
                  onSave: () => _save(s),
                  large: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Save Button ──────────────────────────────────────────────
class _SaveButton extends StatelessWidget {
  final SaveStatus status;
  final VoidCallback onSave;
  final bool large;

  const _SaveButton({
    required this.status,
    required this.onSave,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSaving = status == SaveStatus.saving;
    final label = isSaving ? tr('admin_saving') : tr('admin_save');

    if (large) {
      return ElevatedButton.icon(
        onPressed: isSaving ? null : onSave,
        icon: isSaving
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.save_rounded, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18)),
      );
    }
    return ElevatedButton.icon(
      onPressed: isSaving ? null : onSave,
      icon: isSaving
          ? const SizedBox(
              width: 14,
              height: 14,
              child:
                  CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.save_rounded, size: 18),
      label: Text(label),
    );
  }
}

// ─── Layout Helpers ───────────────────────────────────────────
class _Row2 extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _Row2({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      if (c.maxWidth < 500) {
        return Column(children: [left, const SizedBox(height: 16), right]);
      }
      return Row(children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ]);
    });
  }
}

class _Row3 extends StatelessWidget {
  final Widget c1, c2, c3;
  const _Row3({required this.c1, required this.c2, required this.c3});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      if (c.maxWidth < 500) {
        return Column(children: [c1, const SizedBox(height: 16), c2]);
      }
      return Row(children: [
        Expanded(child: c1),
        const SizedBox(width: 16),
        Expanded(child: c2),
        const SizedBox(width: 16),
        Expanded(child: c3),
      ]);
    });
  }
}
