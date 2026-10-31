import 'package:material_ui/material_ui.dart';
import 'package:sound_center/core/services/sleep_timer_service.dart';
import 'package:sound_center/shared/widgets/glass.dart';

class SleepTimerDialog extends StatelessWidget {
  const SleepTimerDialog({super.key});

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final timerService = SleepTimerService();
    final cs = Theme.of(context).colorScheme;

    final presets = [
      {'label': '15 Minutes', 'duration': const Duration(minutes: 15)},
      {'label': '30 Minutes', 'duration': const Duration(minutes: 30)},
      {'label': '45 Minutes', 'duration': const Duration(minutes: 45)},
      {'label': '60 Minutes', 'duration': const Duration(minutes: 60)},
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Glass(
        borderRadius: 24,
        elevation: 8,
        useBorder: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bedtime_rounded, color: cs.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Sleep Timer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: timerService.isRunningNotifier,
                builder: (context, isRunning, _) {
                  if (isRunning) {
                    return ValueListenableBuilder<int>(
                      valueListenable: timerService.remainingSecondsNotifier,
                      builder: (context, remaining, _) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Active: ${_formatTime(remaining)} remaining',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              ...presets.map((preset) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        timerService.startTimer(preset['duration'] as Duration);
                        Navigator.pop(context);
                      },
                      child: Text(preset['label'] as String),
                    ),
                  ),
                );
              }),
              ValueListenableBuilder<bool>(
                valueListenable: timerService.isRunningNotifier,
                builder: (context, isRunning, _) {
                  if (isRunning) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: cs.error,
                        ),
                        icon: const Icon(Icons.cancel_rounded, size: 18),
                        label: const Text('Turn Off Timer'),
                        onPressed: () {
                          timerService.cancelTimer();
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
