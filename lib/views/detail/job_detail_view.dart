import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/job_controller.dart';
import '../../models/job_model.dart';

class JobDetailView extends StatelessWidget {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final JobModel job = Get.arguments as JobModel;
    final controller = Get.find<JobController>();

    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                _DetailAppBar(job: job, controller: controller),
                SliverToBoxAdapter(child: _DetailBody(job: job)),
              ],
            ),
          ),
          _ApplyBar(url: job.url),
        ],
      ),
    );
  }
}

// ─── App Bar ─────────────────────────────────────────────────────────────────

class _DetailAppBar extends StatelessWidget {
  final JobModel job;
  final JobController controller;
  const _DetailAppBar({required this.job, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: AppTheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: Get.back,
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            color: AppTheme.textPrimary, size: 18),
      ),
      title: const Text(
        'Job Details',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Obx(() {
          final bookmarked = controller.isBookmarked(job.url);
          return GestureDetector(
            onTap: () => controller.toggleBookmark(job.url),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                bookmarked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: bookmarked ? AppTheme.amber : AppTheme.textSecondary,
                size: 22,
              ),
            ),
          );
        }),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
            height: 1, thickness: 1, color: AppTheme.border),
      ),
    );
  }
}

// ─── Detail Body ─────────────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  final JobModel job;
  const _DetailBody({required this.job});

  @override
  Widget build(BuildContext context) {
    final bool isRemote = job.location.isEmpty ||
        job.location.toLowerCase().contains('remote');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company badge + info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LargeCompanyBadge(name: job.companyName),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      job.companyName,
                      style: const TextStyle(
                        color: AppTheme.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Meta tags row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaTag(
                icon: Icons.location_on_outlined,
                label: job.location.isNotEmpty ? job.location : 'Not specified',
              ),
              _MetaTag(
                icon: isRemote
                    ? Icons.laptop_mac_outlined
                    : Icons.business_outlined,
                label: isRemote ? 'Remote' : 'On-site',
                color: isRemote ? AppTheme.success : AppTheme.accent,
              ),
            ],
          ),
          const SizedBox(height: 28),

          const Divider(height: 1, thickness: 1, color: AppTheme.border),
          const SizedBox(height: 28),

          // Description section
          _SectionHeader(title: 'About this role'),
          const SizedBox(height: 12),
          _HtmlDescription(html: job.description),
          const SizedBox(height: 28),

          const Divider(height: 1, thickness: 1, color: AppTheme.border),
          const SizedBox(height: 28),

          // Quick info section
          _SectionHeader(title: 'Quick Info'),
          const SizedBox(height: 16),
          _InfoRow(label: 'Company', value: job.companyName),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Location',
            value: job.location.isNotEmpty ? job.location : 'Not specified',
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Work type', value: isRemote ? 'Remote' : 'On-site'),
        ],
      ),
    );
  }
}

class _LargeCompanyBadge extends StatelessWidget {
  final String name;
  const _LargeCompanyBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.avatarColor(name);
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaTag({
    required this.icon,
    required this.label,
    this.color = AppTheme.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.tagBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HtmlDescription extends StatelessWidget {
  final String html;
  const _HtmlDescription({required this.html});

  @override
  Widget build(BuildContext context) {
    if (html.isEmpty) {
      return const Text(
        'No description provided for this role.',
        style: TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
          height: 1.75,
        ),
      );
    }

    return Html(
      data: html,
      onLinkTap: (url, _, __) async {
        if (url == null) return;
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(14),
          lineHeight: const LineHeight(1.75),
          color: AppTheme.textSecondary,
        ),
        'p': Style(
          margin: Margins.only(bottom: 12),
          padding: HtmlPaddings.zero,
          color: AppTheme.textSecondary,
        ),
        'h1, h2, h3, h4': Style(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 16, bottom: 8),
        ),
        'h1': Style(fontSize: FontSize(18)),
        'h2': Style(fontSize: FontSize(16)),
        'h3': Style(fontSize: FontSize(15)),
        'ul': Style(
          margin: Margins.only(bottom: 12),
          padding: HtmlPaddings.only(left: 16),
        ),
        'ol': Style(
          margin: Margins.only(bottom: 12),
          padding: HtmlPaddings.only(left: 16),
        ),
        'li': Style(
          margin: Margins.only(bottom: 6),
          color: AppTheme.textSecondary,
          fontSize: FontSize(14),
          lineHeight: const LineHeight(1.65),
        ),
        'strong, b': Style(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        'em, i': Style(
          color: AppTheme.textSecondary,
          fontStyle: FontStyle.italic,
        ),
        'a': Style(
          color: AppTheme.accent,
          textDecoration: TextDecoration.none,
        ),
        'br': Style(
          margin: Margins.only(bottom: 4),
        ),
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Apply Bar ───────────────────────────────────────────────────────────────

class _ApplyBar extends StatelessWidget {
  final String url;
  const _ApplyBar({required this.url});

  Future<void> _launch() async {
    if (url.isEmpty) {
      Get.snackbar(
        'Unavailable',
        'Application URL is not available.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open the application link.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottom + 12),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _launch,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ).copyWith(
            // Only the CTA gets a glow
            shadowColor: WidgetStatePropertyAll(
              AppTheme.accent.withValues(alpha: 0.35),
            ),
            elevation: const WidgetStatePropertyAll(8),
          ),
          child: const Text(
            'Apply Now',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
