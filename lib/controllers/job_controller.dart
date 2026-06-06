import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_model.dart';
import '../services/job_service.dart';

enum FeedStatus { idle, loading, success, error }

enum FeedFilter { all, bookmarked }

const _kBookmarksKey = 'hirehub_bookmarks';

class JobController extends GetxController {
  final JobService _service = JobService();

  final _status = FeedStatus.idle.obs;
  final _allJobs = <JobModel>[].obs;
  final _filteredJobs = <JobModel>[].obs;
  final _bookmarkedUrls = <String>{}.obs;
  final _searchQuery = ''.obs;
  final _activeFilter = FeedFilter.all.obs;
  String _errorMessage = '';

  FeedStatus get status => _status.value;
  List<JobModel> get jobs => _filteredJobs;
  String get errorMessage => _errorMessage;
  FeedFilter get activeFilter => _activeFilter.value;
  int get bookmarkCount => _bookmarkedUrls.length;
  int get allJobCount => _allJobs.length;

  @override
  void onInit() {
    super.onInit();
    _loadBookmarks().then((_) => fetchJobs());
    ever(_searchQuery, (_) => _applyFilter());
    ever(_activeFilter, (_) => _applyFilter());
    ever(_bookmarkedUrls, (_) {
      _applyFilter();
      _saveBookmarks();
    });
  }

  // ── Persistence ────────────────────────────────────────────────────────────

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_kBookmarksKey) ?? [];
    _bookmarkedUrls.addAll(saved.toSet());
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kBookmarksKey, _bookmarkedUrls.toList());
  }

  // ── Network ────────────────────────────────────────────────────────────────

  Future<void> fetchJobs() async {
    _status.value = FeedStatus.loading;
    _errorMessage = '';
    try {
      final jobs = await _service.fetchJobs();
      _allJobs.assignAll(jobs);
      _applyFilter();
      _status.value = FeedStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status.value = FeedStatus.error;
    }
  }

  // ── Filters ────────────────────────────────────────────────────────────────

  void search(String query) => _searchQuery.value = query.trim().toLowerCase();

  void setFilter(FeedFilter filter) => _activeFilter.value = filter;

  void _applyFilter() {
    Iterable<JobModel> base = _allJobs;
    if (_activeFilter.value == FeedFilter.bookmarked) {
      base = base.where((j) => _bookmarkedUrls.contains(j.url));
    }
    final q = _searchQuery.value;
    if (q.isNotEmpty) {
      base = base.where(
        (j) =>
            j.title.toLowerCase().contains(q) ||
            j.companyName.toLowerCase().contains(q),
      );
    }
    _filteredJobs.assignAll(base);
  }

  // ── Bookmarks ──────────────────────────────────────────────────────────────

  void toggleBookmark(String url) {
    if (_bookmarkedUrls.contains(url)) {
      _bookmarkedUrls.remove(url);
    } else {
      _bookmarkedUrls.add(url);
    }
  }

  bool isBookmarked(String url) => _bookmarkedUrls.contains(url);
}
