import 'dart:isolate';
import 'package:podcast_search/podcast_search.dart';
import 'package:sound_center/database/shared_preferences/app_setting_storage.dart';
import 'package:sound_center/features/settings/domain/settings_repository.dart';

class _FeedLoadParams {
  final String url;
  final String userAgent;

  const _FeedLoadParams({
    required this.url,
    required this.userAgent,
  });
}

Future<Podcast> _loadFeedInIsolate(_FeedLoadParams params) async {
  const timeout = Duration(seconds: 15);
  try {
    return await Feed.loadFeed(
      url: params.url,
      userAgent: params.userAgent,
      timeout: timeout,
    );
  } catch (_) {
    return await Feed.loadFeed(
      url: params.url,
      timeout: timeout,
    );
  }
}

class PodcastSource {
  static final Map<String, Podcast> _podcastCache = {};
  static final Map<String, DateTime> _cachedTime = {};

  static const String _userAgent =
      'Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

  static Future<SearchResult> search(String searchText) async {
    Search search = Search();
    PodcastProvider provider = AppSettingStorage.getSavedProvider();
    if (provider == PodcastProvider.podcatIndex) {
      Map<String, String>? podcastIndexInfo =
          AppSettingStorage.getPodcastIndexKeys();
      if (podcastIndexInfo != null) {
        search = Search(
          searchProvider: PodcastIndexProvider(
            key: podcastIndexInfo['key']!,
            secret: podcastIndexInfo['secret']!,
          ),
        );
      }
    }
    SearchResult results = await search.search(searchText, limit: 50);
    return results;
  }

  static Future<Podcast> loadPodcastInfo(
    String feedUrl, {
    Duration ttl = const Duration(hours: 1),
  }) async {
    final cleanUrl = feedUrl.trim();
    final cached = _podcastCache[cleanUrl];
    if (cached != null) {
      final cachedTime = _cachedTime[cleanUrl]!;
      if (DateTime.now().difference(cachedTime) < ttl) {
        return cached;
      }
    }

    // Run feed download & XML parsing completely off the UI isolate
    final podcast = await Isolate.run(() => _loadFeedInIsolate(
          _FeedLoadParams(url: cleanUrl, userAgent: _userAgent),
        ));

    _podcastCache[cleanUrl] = podcast;
    _cachedTime[cleanUrl] = DateTime.now();
    return podcast;
  }

  static void setCache(Map<String, Podcast> podcasts) {
    podcasts.forEach((feed, podcast) {
      _podcastCache[feed] = podcast;
      _cachedTime[feed] = DateTime.now();
    });
  }
}
