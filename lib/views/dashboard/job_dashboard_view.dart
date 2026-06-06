import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../app/widgets/hirehub_logo.dart';
import '../../controllers/job_controller.dart';
import 'widgets/job_card.dart';

class JobDashboardView extends StatelessWidget {
  const JobDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(controller: controller),
            const SizedBox(height: 16),
            _SearchBar(controller: controller),
            const SizedBox(height: 12),
            _FilterRow(controller: controller),
            const SizedBox(height: 4),
            Expanded(child: _JobFeed(controller: controller)),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final JobController controller;
  const _Header({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HireHubLogo(size: 36),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning 👋',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Find your next role',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Jobs count pill
          Obx(() {
            if (controller.status != FeedStatus.success) {
              return const SizedBox.shrink();
            }
            final total = controller.allJobCount;
            return Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$total active jobs',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ─── Search Bar ──────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final JobController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: controller.search,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14,
          height: 1.2,
        ),
        decoration: const InputDecoration(
          hintText: 'Search jobs, companies...',
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 12, right: 8),
            child: Icon(Icons.search_rounded, size: 18, color: AppTheme.textMuted),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        ),
      ),
    );
  }
}

// ─── Filter Row ──────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final JobController controller;
  const _FilterRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = controller.activeFilter;
      final count = controller.bookmarkCount;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _Chip(
              label: 'All Jobs',
              selected: active == FeedFilter.all,
              onTap: () => controller.setFilter(FeedFilter.all),
            ),
            const SizedBox(width: 8),
            _Chip(
              label: '❤️  Saved',
              badge: count > 0 ? '$count' : null,
              selected: active == FeedFilter.bookmarked,
              onTap: () => controller.setFilter(FeedFilter.bookmarked),
              selectedColor: AppTheme.amber,
            ),
          ],
        ),
      );
    });
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
    this.selectedColor = AppTheme.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withValues(alpha: 0.14)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? selectedColor : AppTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? selectedColor : AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: selectedColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    color: selectedColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Job Feed ────────────────────────────────────────────────────────────────

class _JobFeed extends StatelessWidget {
  final JobController controller;
  const _JobFeed({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.status) {
        case FeedStatus.loading:
          return const _LoadingState();
        case FeedStatus.error:
          return _ErrorState(
            message: controller.errorMessage,
            onRetry: controller.fetchJobs,
          );
        case FeedStatus.success:
          if (controller.jobs.isEmpty) {
            return _EmptyState(
              isBookmarkFilter: controller.activeFilter == FeedFilter.bookmarked,
            );
          }
          return _JobList(controller: controller);
        default:
          return const SizedBox.shrink();
      }
    });
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppTheme.accent,
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            'Loading jobs...',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.error.withValues(alpha: 0.2), width: 1),
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  color: AppTheme.error, size: 28),
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to load jobs',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isBookmarkFilter;
  const _EmptyState({this.isBookmarkFilter = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isBookmarkFilter ? '❤️' : '🔍',
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 16),
            Text(
              isBookmarkFilter ? 'No saved jobs yet' : 'No jobs found',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isBookmarkFilter
                  ? 'Tap the heart icon on any job to save it here'
                  : 'Try a different search term',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobList extends StatelessWidget {
  final JobController controller;
  const _JobList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: controller.jobs.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          // Count label as first item
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${controller.jobs.length} results',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
        final job = controller.jobs[i - 1];
        return JobCard(
          job: job,
          onTap: () => Get.toNamed(AppRoutes.detail, arguments: job),
        );
      },
    );
  }
}
