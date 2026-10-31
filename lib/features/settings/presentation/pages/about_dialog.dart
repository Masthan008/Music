import 'package:material_ui/material_ui.dart';
import 'package:sound_center/core/constants/constants.dart';

class AboutDialogBody extends StatelessWidget {
  const AboutDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  VERSION_NAME,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Indus Release Edition',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Sound Center is a high-performance audio player designed with modern Liquid Glass UI, featuring offline music playback, live radio streaming, podcast hub, and cloud tracks in 13 Indian languages.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Features: Liquid Glass Design • Synced Lyrics • Sleep Timer • Podcasts • 24/7 Live Radio • SoundCloud Streamer',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
