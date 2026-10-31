import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sound_center/features/local_audio/data/repositories/local_player_rpository_imp.dart';
import 'package:sound_center/features/local_audio/domain/entities/audio.dart';
import 'package:sound_center/features/local_audio/domain/repositories/audio_repository.dart';
import 'package:sound_center/features/local_audio/presentation/bloc/local_bloc.dart';
import 'package:sound_center/generated/l10n.dart';
import 'package:sound_center/shared/Repository/player_repository.dart';
import 'package:sound_center/shared/widgets/glass.dart';
import 'package:sound_center/shared/widgets/scrolling_text.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({
    super.key,
    required this.title,
    required this.audios,
    required this.category,
    this.playlistRename,
  });

  final String title;
  final Function? playlistRename;
  final List<AudioEntity> audios;
  final Category category;

  void _shufflePlay(BuildContext context) {
    final bloc = context.read<LocalBloc>();
    final imp = LocalPlayerRepositoryImp();
    if (audios.isEmpty) return;

    imp.shuffleMode = ShuffleMode.shuffle;
    bloc.add(PlayAudio(audios: audios, index: Random().nextInt(audios.length)));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    final bloc = BlocProvider.of<LocalBloc>(context);

    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    IconData icon;
    switch (category) {
      case Category.playlists:
        icon = Icons.queue_music_rounded;
        break;
      case Category.artists:
        icon = Icons.person_rounded;
        break;
      case Category.albums:
        icon = Icons.album_rounded;
        break;
      case Category.genres:
        icon = Icons.music_note_rounded;
        break;
      case Category.folders:
        icon = Icons.folder_rounded;
        break;
      case Category.favorites:
        icon = Icons.favorite_rounded;
        break;
      case Category.allSongs:
        icon = Icons.music_note_rounded;
        break;
    }

    final avatarSize = isLandscape ? 40.0 : 64.0;
    final avatar = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(isLandscape ? 12 : 18),
      ),
      child: Icon(icon, size: isLandscape ? 22 : 32, color: cs.primary),
    );

    final titleBlock = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: ScrollingText(
                  title,
                  style: (isLandscape ? tt.titleMedium : tt.headlineSmall)
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                ),
              ),
              if (category == Category.playlists)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => playlistRename?.call(),
                  icon: Icon(Icons.edit_rounded, size: isLandscape ? 18 : 20),
                ),
            ],
          ),
          if (!isLandscape) const SizedBox(height: 4),
          Text(
            "${audios.length} ${S.of(context).tracks}",
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    final verticalPadding = isLandscape ? 6.0 : 8.0;
    final bottomPadding = isLandscape ? 8.0 : 16.0;

    final playButton = FilledButton.icon(
      onPressed: audios.isEmpty
          ? null
          : () => bloc.add(PlayAudio(audios: audios, index: 0)),
      label: Text(S.of(context).play),
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: isLandscape ? 8 : 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );

    final shuffleButton = OutlinedButton.icon(
      onPressed: audios.isEmpty ? null : () => _shufflePlay(context),
      label: Text(S.of(context).shufflePlay),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: isLandscape ? 8 : 12),
        foregroundColor: cs.onPrimaryContainer,
        side: BorderSide(color: cs.onPrimaryContainer.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Glass(
        borderRadius: 24,
        elevation: 4,
        useBorder: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, verticalPadding, 20, bottomPadding),
          child: isLandscape
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 12,
                  children: [
                    avatar,
                    titleBlock,
                    SizedBox(width: 110, child: playButton),
                    SizedBox(width: 150, child: shuffleButton),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 18,
                  children: [
                    Row(spacing: 15, children: [avatar, titleBlock]),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(child: playButton),
                        Expanded(child: shuffleButton),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
