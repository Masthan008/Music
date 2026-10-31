import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:android_media_store/android_media_store.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sound_center/features/local_audio/domain/entities/audio.dart';

class LocalStorageSource {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final _androidMediaStore = AndroidMediaStore.instance;

  Future<List<SongModel>> scanStorage() async {
    return await _audioQuery.querySongs();
  }

  Future<bool> deleteAudio(AudioEntity audio) async {
    try {
      // 1. Attempt direct filesystem deletion first if path exists
      if (audio.path.isNotEmpty) {
        try {
          final file = File(audio.path);
          if (await file.exists()) {
            await file.delete();
            return true;
          }
        } catch (e) {
          debugPrint('Direct file deletion failed: $e');
        }
      }

      // 2. Fallback to AndroidMediaStore if URI exists
      if (audio.uri != null && audio.uri!.isNotEmpty) {
        try {
          final res = await _androidMediaStore.deleteMediaFile(audio.uri!);
          return res;
        } catch (e) {
          debugPrint('MediaStore deleteMediaFile failed: $e');
        }
      }

      return false;
    } catch (e) {
      debugPrint('deleteAudio general failure: $e');
      return false;
    }
  }
}
