import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sound_center/features/local_audio/data/repositories/local_player_rpository_imp.dart';
import 'package:sound_center/features/local_audio/presentation/bloc/local_bloc.dart';
import 'package:sound_center/shared/widgets/confirm_dialog.dart';
import 'package:sound_center/shared/widgets/lyrics_dialog.dart';
import 'package:sound_center/shared/widgets/media_controller_button.dart';
import 'package:sound_center/shared/widgets/player/handler.dart';
import 'package:sound_center/shared/widgets/sleep_timer_dialog.dart';

class PlayerOps extends StatelessWidget {
  const PlayerOps({super.key});

  void _delete(BuildContext context, LocalPlayerRepositoryImp imp) async {
    final currentAudio = imp.getCurrentAudio;
    if (currentAudio == null) return;

    bool res =
        await showDialog(context: context, builder: (_) => ConfirmDialog()) ??
        false;
    if (res && context.mounted) {
      BlocProvider.of<LocalBloc>(context).add(DeleteAudios([currentAudio]));
    }
  }

  void _share(BuildContext context, LocalPlayerRepositoryImp imp) async {
    if (Platform.isLinux) return;

    final song = imp.getCurrentAudio;
    if (song == null) return;

    try {
      final file = File(song.path);
      if (await file.exists()) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(song.path, mimeType: 'audio/*')],
            subject: '${song.title} - ${song.artist}',
          ),
        );
      } else {
        await SharePlus.instance.share(
          ShareParams(text: '${song.title} - ${song.artist}'),
        );
      }
    } catch (_) {
      try {
        await SharePlus.instance.share(
          ShareParams(text: '${song.title} - ${song.artist}'),
        );
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final imp = LocalPlayerRepositoryImp();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MediaControllerButton(
          width: 44,
          height: 44,
          onPressed: () => _delete(context, imp),
          svg: "assets/icons/trash-can.svg",
        ),
        IconButton(
          tooltip: 'Sleep Timer',
          icon: const Icon(Icons.bedtime_rounded, size: 22),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const SleepTimerDialog(),
            );
          },
        ),
        IconButton(
          tooltip: 'Lyrics',
          icon: const Icon(Icons.lyrics_rounded, size: 22),
          onPressed: () {
            final song = imp.getCurrentAudio;
            if (song == null) return;
            showDialog(
              context: context,
              builder: (_) => LyricsDialog(
                trackName: song.title,
                artistName: song.artist,
              ),
            );
          },
        ),
        const Handler(),
        MediaControllerButton(
          width: 44,
          height: 44,
          onPressed: () => _share(context, imp),
          svg: "assets/icons/share.svg",
        ),
      ],
    );
  }
}
