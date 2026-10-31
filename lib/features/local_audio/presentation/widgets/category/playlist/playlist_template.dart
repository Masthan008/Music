import 'package:material_ui/material_ui.dart';
import 'package:sound_center/core/constants/constants.dart';
import 'package:sound_center/core/util/audio/audio_util.dart';
import 'package:sound_center/features/local_audio/domain/entities/local_play_list.dart';
import 'package:sound_center/generated/l10n.dart';
import 'package:sound_center/shared/widgets/glass.dart';

class PlaylistTemplate extends StatelessWidget {
  const PlaylistTemplate({
    super.key,
    required this.item,
    this.isMultiple = false,
    this.isSelected = false,
    this.onChanged,
  });

  final PlaylistEntity item;
  final bool isMultiple;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;

  final double size = 48;

  @override
  Widget build(BuildContext context) {
    final TextStyle infoTextStyle = TextStyle(
      color: Theme.of(
        context,
      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
      fontSize: 13,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Glass(
        borderRadius: 16,
        elevation: 3,
        useBorder: true,
        child: Container(
          height: LIST_ITEM_HEIGHT,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isMultiple
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10),
                        child: Checkbox(value: isSelected, onChanged: onChanged),
                      )
                    : const SizedBox.shrink(),
              ),
              if (isMultiple) const SizedBox(width: 8),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                ),
                child: Hero(
                  tag: item.title,
                  child: Icon(
                    Icons.queue_music_rounded,
                    size: 26,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${S.of(context).tracks}: ${item.itemCount}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: infoTextStyle,
                    ),
                  ],
                ),
              ),
              Text(AudioUtil.convertTime(item.totalDuration), style: infoTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}
