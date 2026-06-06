import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../controllers/job_controller.dart';
import '../../../models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCard({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppTheme.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CompanyBadge(name: job.companyName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job title
                    Text(
                      job.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Company name
                    Text(
                      job.companyName,
                      style: const TextStyle(
                        color: AppTheme.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    // Location row
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            job.location.isNotEmpty ? job.location : 'Remote',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Right column — bookmark + chevron
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() {
                    final bookmarked = controller.isBookmarked(job.url);
                    return GestureDetector(
                      onTap: () => controller.toggleBookmark(job.url),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          bookmarked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: bookmarked
                              ? AppTheme.amber
                              : AppTheme.textMuted,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.textMuted,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyBadge extends StatelessWidget {
  final String name;
  const _CompanyBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.avatarColor(name);
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: color,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
