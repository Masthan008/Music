import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sound_center/main.dart';

class SleepTimerService {
  static final SleepTimerService _instance = SleepTimerService._internal();
  factory SleepTimerService() => _instance;
  SleepTimerService._internal();

  Timer? _countdownTimer;
  int _remainingSeconds = 0;

  final ValueNotifier<int> remainingSecondsNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> isRunningNotifier = ValueNotifier<bool>(false);

  bool get isRunning => isRunningNotifier.value;
  int get remainingSeconds => remainingSecondsNotifier.value;

  void startTimer(Duration duration) {
    cancelTimer();

    _remainingSeconds = duration.inSeconds;
    remainingSecondsNotifier.value = _remainingSeconds;
    isRunningNotifier.value = true;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        remainingSecondsNotifier.value = _remainingSeconds;
      } else {
        await _onTimerFinished();
      }
    });
  }

  void cancelTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _remainingSeconds = 0;
    remainingSecondsNotifier.value = 0;
    isRunningNotifier.value = false;
  }

  Future<void> _onTimerFinished() async {
    cancelTimer();
    try {
      await audioHandler.pause();
    } catch (e) {
      debugPrint('SleepTimer pause failed: $e');
    }
  }
}
