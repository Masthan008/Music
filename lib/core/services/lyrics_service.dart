import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LyricLine {
  final Duration timestamp;
  final String text;

  LyricLine({required this.timestamp, required this.text});
}

class LyricsData {
  final List<LyricLine> lines;
  final String plainText;
  final bool isSynced;

  LyricsData({
    required this.lines,
    required this.plainText,
    required this.isSynced,
  });

  factory LyricsData.empty() => LyricsData(lines: [], plainText: '', isSynced: false);
}

class LyricsService {
  static final Map<String, LyricsData> _cache = {};

  static Future<LyricsData> fetchLyrics({
    required String trackName,
    required String artistName,
    int? durationInSeconds,
  }) async {
    final cacheKey = '$trackName-$artistName'.toLowerCase().trim();
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final queryParams = {
        'track_name': trackName,
        'artist_name': artistName,
      };
      if (durationInSeconds != null && durationInSeconds > 0) {
        queryParams['duration'] = durationInSeconds.toString();
      }

      final uri = Uri.https('lrclib.net', '/api/get', queryParams);
      final response = await http.get(uri).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final String? synced = data['syncedLyrics'] as String?;
        final String? plain = data['plainLyrics'] as String?;

        if (synced != null && synced.trim().isNotEmpty) {
          final lines = _parseLrc(synced);
          final result = LyricsData(
            lines: lines,
            plainText: plain ?? '',
            isSynced: true,
          );
          _cache[cacheKey] = result;
          return result;
        } else if (plain != null && plain.trim().isNotEmpty) {
          final result = LyricsData(
            lines: [],
            plainText: plain,
            isSynced: false,
          );
          _cache[cacheKey] = result;
          return result;
        }
      }
    } catch (e) {
      debugPrint('Lyrics fetch failed: $e');
    }

    return LyricsData.empty();
  }

  static List<LyricLine> _parseLrc(String lrc) {
    final List<LyricLine> list = [];
    final regExp = RegExp(r'\[(\d{2}):(\d{2})\.?(\d{2,3})?\](.*)');

    for (final line in lrc.split('\n')) {
      final match = regExp.firstMatch(line.trim());
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final seconds = int.parse(match.group(2)!);
        final millisStr = match.group(3) ?? '0';
        final millis = int.parse(millisStr.padRight(3, '0').substring(0, 3));

        final timestamp = Duration(
          minutes: minutes,
          seconds: seconds,
          milliseconds: millis,
        );
        final text = match.group(4)?.trim() ?? '';
        if (text.isNotEmpty) {
          list.add(LyricLine(timestamp: timestamp, text: text));
        }
      }
    }
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }
}
